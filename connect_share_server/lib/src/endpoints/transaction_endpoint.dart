import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart'; // Access to TransactionLog, UserProfile, HotspotConfig, Plan, AccessToken

class TransactionEndpoint extends Endpoint {
  // Create a new transaction after initiating a payment
  // Consumer must be authenticated
  Future<TransactionLog> createTransaction(
      Session session,
      int hotspotId,
      int planId,
      String paystackReference,
      double amountPaid,
      String currency) async {
    final authenticated = await session.authenticated;
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
      throw ArgumentException(message: 'Plan does not belong to the specified hotspot.');
    }

    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || !hotspot.isActive) {
      throw ArgumentException(message: 'Hotspot not found or is inactive.');
    }

    // Validate input
    if (paystackReference.isEmpty || amountPaid <= 0 || currency.isEmpty) {
      throw ArgumentException(message: 
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
    final authenticated = await session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    // TODO: Restrict to admin or system (e.g., check scopeNames for 'admin')

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
    final authenticated = await session.authenticated;
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
    final authenticated = await session.authenticated;
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
    final authenticated = await session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    // TODO: Restrict to admin or system (e.g., check scopeNames for 'admin')

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
