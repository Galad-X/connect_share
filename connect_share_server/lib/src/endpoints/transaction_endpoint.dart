import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart'; // Access to TransactionLog, UserProfile, HotspotConfig, Plan, AccessToken

class TransactionEndpoint extends Endpoint {
  Future<void> _ensureAdmin(Session session) async {
    final user = session.authenticated;
    if (user == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    if (!user.scopes.any((scope) => scope.name == 'admin')) {
      throw AuthenticationException(message: 'Admin access required.');
    }
  }

  /// Initializes hosted checkout without exposing the Paystack secret to the
  /// mobile application.
  Future<List<String>> initializePayment(
    Session session,
    String paystackReference,
    String email,
    int hotspotId,
    int planId,
  ) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final plan = await Plan.db.findById(session, planId);
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (plan == null ||
        !plan.isActive ||
        hotspot == null ||
        !hotspot.isActive ||
        plan.hotspotId != hotspotId ||
        email.trim().isEmpty) {
      throw ArgumentException(message: 'Invalid payment details.');
    }
    final secretKey = session.passwords['paystackSecretKey'];
    if (secretKey == null || secretKey.isEmpty) {
      throw Exception('Paystack is not configured on the server.');
    }

    final httpClient = HttpClient();
    try {
      final request = await httpClient.postUrl(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
      );
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer $secretKey')
        ..set(HttpHeaders.contentTypeHeader, 'application/json');
      request.write(jsonEncode({
        'email': email.trim(),
        'amount': (plan.price * 100).round(),
        'currency': plan.currency.toUpperCase(),
        'reference': paystackReference,
        'metadata': {'hotspot_id': hotspotId, 'plan_id': planId},
      }));
      final response = await request.close();
      final payload = jsonDecode(await response.transform(utf8.decoder).join());
      final data = payload is Map<String, dynamic>
          ? payload['data'] as Map<String, dynamic>?
          : null;
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          payload['status'] != true ||
          data == null) {
        throw ArgumentException(message: 'Unable to initialize payment.');
      }
      return [
        data['authorization_url']?.toString() ?? '',
        data['access_code']?.toString() ?? '',
        data['reference']?.toString() ?? paystackReference,
      ];
    } finally {
      httpClient.close(force: true);
    }
  }

  /// Verify payment on the server and issue a token only after the amount,
  /// currency, reference, and Paystack status match.
  Future<AccessToken> verifyPaymentAndGenerateToken(
    Session session,
    String paystackReference,
    int hotspotId,
    int planId,
  ) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    if (paystackReference.trim().isEmpty) {
      throw ArgumentException(message: 'Payment reference is required.');
    }

    final plan = await Plan.db.findById(session, planId);
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (plan == null ||
        !plan.isActive ||
        hotspot == null ||
        !hotspot.isActive ||
        plan.hotspotId != hotspotId) {
      throw ArgumentException(message: 'Plan or hotspot is unavailable.');
    }

    final secretKey = session.passwords['paystackSecretKey'];
    if (secretKey == null || secretKey.isEmpty) {
      throw Exception('Paystack is not configured on the server.');
    }

    final httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(Uri.parse(
          'https://api.paystack.co/transaction/verify/${Uri.encodeComponent(paystackReference)}'));
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $secretKey');
      final response = await request.close();
      final payload = jsonDecode(await response.transform(utf8.decoder).join());
      final data = payload is Map<String, dynamic>
          ? payload['data'] as Map<String, dynamic>?
          : null;
      final paidAmount = data?['amount'];
      final paidCurrency = data?['currency']?.toString().toUpperCase();
      final paidStatus = data?['status']?.toString().toLowerCase();
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          payload['status'] != true ||
          paidStatus != 'success' ||
          paidAmount is! num ||
          paidAmount.round() != (plan.price * 100).round() ||
          paidCurrency != plan.currency.toUpperCase()) {
        throw ArgumentException(message: 'Payment could not be verified.');
      }
    } finally {
      httpClient.close(force: true);
    }

    final existing = await TransactionLog.db.findFirstRow(
      session,
      where: (t) => t.paystackReference.equals(paystackReference),
    );
    if (existing != null) {
      if (existing.consumerId != authenticated.userId ||
          existing.hotspotId != hotspotId ||
          existing.planId != planId) {
        throw AuthenticationException(
            message: 'Payment reference is already in use.');
      }
      if (existing.accessTokenId != null) {
        final token =
            await AccessToken.db.findById(session, existing.accessTokenId!);
        if (token != null) return token;
      }
    }

    final now = DateTime.now().toUtc();
    final expiryDate = switch (plan.durationType) {
      PlanDurationType.daily => now.add(Duration(days: plan.durationValue)),
      PlanDurationType.weekly =>
        now.add(Duration(days: 7 * plan.durationValue)),
      PlanDurationType.monthly => DateTime.utc(
          now.year,
          now.month + plan.durationValue,
          now.day,
          now.hour,
          now.minute,
          now.second),
      PlanDurationType.custom => now.add(Duration(hours: plan.durationValue)),
    };
    return await session.db.transaction((dbTransaction) async {
      final token = await AccessToken.db.insertRow(
        session,
        AccessToken(
          tokenValue:
              'SPW-${base64UrlEncode(List<int>.generate(32, (_) => Random.secure().nextInt(256)))}',
          consumerId: authenticated.userId,
          hotspotId: hotspotId,
          planId: planId,
          issueDate: now,
          expiryDate: expiryDate,
          isActive: true,
          dataUsedBytes: BigInt.zero,
        ),
        transaction: dbTransaction,
      );

      final transaction = existing ??
          TransactionLog(
            consumerId: authenticated.userId,
            providerId: hotspot.providerId,
            hotspotId: hotspotId,
            planId: planId,
            accessTokenId: token.id,
            paystackReference: paystackReference,
            amountPaid: plan.price,
            currency: plan.currency,
            transactionDate: now,
            status: 'successful',
            platformFee: plan.price * 0.05,
            providerPayoutAmount: plan.price * 0.95,
            payoutStatus: 'pending_payout',
          );
      if (existing == null) {
        await TransactionLog.db.insertRow(
          session,
          transaction,
          transaction: dbTransaction,
        );
      } else {
        await TransactionLog.db.updateRow(
          session,
          transaction.copyWith(
            accessTokenId: token.id,
            status: 'successful',
            payoutStatus: 'pending_payout',
          ),
          transaction: dbTransaction,
        );
      }
      return token;
    });
  }

  // Create a new transaction after initiating a payment
  // Consumer must be authenticated
  Future<TransactionLog> createTransaction(
      Session session,
      int hotspotId,
      int planId,
      String paystackReference,
      double amountPaid,
      String currency) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final consumerId = authenticated.userId;

    // Validate plan and hotspot
    final plan = await Plan.db.findById(session, planId);
    if (plan == null || !plan.isActive) {
      throw ArgumentException(message: 'Plan not found or is inactive.');
    }
    if (plan.hotspotId != hotspotId) {
      throw ArgumentException(
          message: 'Plan does not belong to the specified hotspot.');
    }

    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || !hotspot.isActive) {
      throw ArgumentException(message: 'Hotspot not found or is inactive.');
    }

    // Validate input
    if (paystackReference.isEmpty || amountPaid <= 0 || currency.isEmpty) {
      throw ArgumentException(
          message:
              'Invalid transaction details (Paystack reference, amount, or currency).');
    }

    // Check for duplicate Paystack reference
    final existingTransaction = await TransactionLog.db.findFirstRow(
      session,
      where: (t) => t.paystackReference.equals(paystackReference),
    );
    if (existingTransaction != null) {
      throw ArgumentException(message: 'Paystack reference already exists.');
    }

    // Calculate platform fee (example: 5% of amountPaid)
    const platformFeePercentage = 0.05;
    final platformFee = amountPaid * platformFeePercentage;
    final providerPayoutAmount = amountPaid - platformFee;

    // Create transaction
    final transaction = TransactionLog(
      consumerId: consumerId,
      providerId: hotspot.providerId,
      hotspotId: hotspotId,
      planId: planId,
      accessTokenId: null, // Will be set after token generation
      paystackReference: paystackReference,
      amountPaid: amountPaid,
      currency: currency,
      transactionDate: DateTime.now().toUtc(),
      status: 'pending', // Initial status; updated after payment verification
      platformFee: platformFee,
      providerPayoutAmount: providerPayoutAmount,
      payoutStatus: 'pending_payout',
    );

    await TransactionLog.db.insertRow(session, transaction);
    return transaction;
  }

  // Update transaction status (e.g., after Paystack webhook confirms payment)
  // Restricted to admin or system (e.g., webhook) with proper authentication
  Future<TransactionLog> updateTransactionStatus(
      Session session, String paystackReference, String newStatus,
      {int? accessTokenId}) async {
    await _ensureAdmin(session);

    // Validate status
    if (!['pending', 'successful', 'failed', 'refunded'].contains(newStatus)) {
      throw ArgumentException(message: 'Invalid transaction status.');
    }

    final transaction = await TransactionLog.db.findFirstRow(
      session,
      where: (t) => t.paystackReference.equals(paystackReference),
    );
    if (transaction == null) {
      throw ArgumentException(message: 'Transaction not found.');
    }

    // Validate accessTokenId if provided
    if (accessTokenId != null) {
      final token = await AccessToken.db.findById(session, accessTokenId);
      if (token == null ||
          token.hotspotId != transaction.hotspotId ||
          token.planId != transaction.planId) {
        throw ArgumentException(message: 'Invalid access token ID.');
      }
    }

    // Update transaction
    final updatedTransaction = transaction.copyWith(
      status: newStatus,
      accessTokenId: accessTokenId ?? transaction.accessTokenId,
      payoutStatus: newStatus == 'successful'
          ? 'pending_payout'
          : newStatus == 'failed' || newStatus == 'refunded'
              ? null
              : transaction.payoutStatus,
    );

    await TransactionLog.db.updateRow(session, updatedTransaction);
    return updatedTransaction;
  }

  // List transactions for the authenticated consumer
  Future<List<TransactionLog>> listConsumerTransactions(Session session,
      {int? limit = 50}) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final consumerId = authenticated.userId;

    return await TransactionLog.db.find(
      session,
      where: (t) => t.consumerId.equals(consumerId),
      orderBy: (t) => t.transactionDate,
      orderDescending: true,
      limit: limit,
    );
  }

  // List transactions for the authenticated provider
  Future<List<TransactionLog>> listProviderTransactions(Session session,
      {int? limit = 50}) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final providerId = authenticated.userId;

    return await TransactionLog.db.find(
      session,
      where: (t) => t.providerId.equals(providerId),
      orderBy: (t) => t.transactionDate,
      orderDescending: true,
      limit: limit,
    );
  }

  // Update payout status for a transaction (e.g., after payout to provider)
  // Restricted to admin or system
  Future<TransactionLog> updatePayoutStatus(
      Session session, String paystackReference, String newPayoutStatus) async {
    await _ensureAdmin(session);

    // Validate payout status
    if (!['pending_payout', 'paid_out', 'payout_failed']
        .contains(newPayoutStatus)) {
      throw ArgumentException(message: 'Invalid payout status.');
    }

    final transaction = await TransactionLog.db.findFirstRow(
      session,
      where: (t) => t.paystackReference.equals(paystackReference),
    );
    if (transaction == null) {
      throw ArgumentException(message: 'Transaction not found.');
    }

    // Update transaction
    final updatedTransaction = transaction.copyWith(
      payoutStatus: newPayoutStatus,
    );

    await TransactionLog.db.updateRow(session, updatedTransaction);
    return updatedTransaction;
  }
}
