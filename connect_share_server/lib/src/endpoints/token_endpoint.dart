import 'package:serverpod/serverpod.dart';
import 'dart:convert';
import 'dart:math'; // For random token generation
import '../generated/protocol.dart';


class TokenEndpoint extends Endpoint {
  // Consumer purchases a plan and a token is generated.
  // Consumer must be authenticated.
  Future<AccessToken?> purchasePlanAndGenerateToken(
      Session session, int hotspotId, int planId) async {
    final authenticated = await session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final userId = authenticated.userId;

    final plan = await Plan.db.findById(session, planId);
    if (plan == null || !plan.isActive) {
      throw Exception('Plan not found or is inactive.');
    }
    if (plan.hotspotId != hotspotId) {
      throw ArgumentException(message: 'Plan does not belong to the specified hotspot.');
    }

    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || !hotspot.isActive) {
      throw Exception('Hotspot not found or is inactive.');
    }

    // TODO: Integrate with payment verification here.
    // This endpoint should be called *after* payment is confirmed.

    final now = DateTime.now().toUtc();
    DateTime expiryDate;
    switch (plan.durationType) {
      case PlanDurationType.daily:
        expiryDate = now.add(Duration(days: plan.durationValue));
        break;
      case PlanDurationType.weekly:
        expiryDate = now.add(Duration(days: 7 * plan.durationValue));
        break;
      case PlanDurationType.monthly:
        expiryDate = DateTime.utc(now.year, now.month + plan.durationValue,
            now.day, now.hour, now.minute, now.second);
        break;
      case PlanDurationType.custom:
        expiryDate = now.add(Duration(hours: plan.durationValue));
        break;
    }

    final tokenValue = _generateSecureToken();
    final accessToken = AccessToken(
      tokenValue: tokenValue,
      consumerId: userId,
      hotspotId: hotspotId,
      planId: planId,
      issueDate: now,
      expiryDate: expiryDate,
      isActive: true,
      dataUsedBytes: BigInt.zero, // Initialize as BigInt
    );

    await AccessToken.db.insertRow(session, accessToken);
    return accessToken;
  }

  // Captive portal validates a token.
  Future<AccessTokenValidationResult> validateAccessTokenForCaptivePortal(
      Session session,
      String tokenValue,
      String clientMacAddress,
      int hotspotId) async {
    if (tokenValue.isEmpty || clientMacAddress.isEmpty) {
      return AccessTokenValidationResult(
          isValid: false, message: 'Invalid token or device identifier.');
    }

    final token = await AccessToken.db.findFirstRow(
      session,
      where: (t) =>
          t.tokenValue.equals(tokenValue) & t.hotspotId.equals(hotspotId),
    );

    if (token == null) {
      return AccessTokenValidationResult(
          isValid: false, message: 'Token not found for this hotspot.');
    }

    if (!token.isActive) {
      return AccessTokenValidationResult(
          isValid: false, message: 'Token is inactive.');
    }

    final now = DateTime.now().toUtc();
    if (token.expiryDate.isBefore(now)) {
      await AccessToken.db.updateRow(
          session,
          token.copyWith(
              isActive: false, lastUsedDeviceIdentifier: clientMacAddress));
      return AccessTokenValidationResult(
          isValid: false, message: 'Token has expired.');
    }

    final plan = await Plan.db.findById(session, token.planId);
    if (plan == null) {
      print('Plan not found for token ID: ${token.id}');
      return AccessTokenValidationResult(
          isValid: false, message: 'Associated plan not found.');
    }

    if (plan.type == PlanType.metered) {
      final dataLimitBytes =
          BigInt.from((plan.dataLimitGB ?? 0) * 1024 * 1024 * 1024);
      if ((token.dataUsedBytes ?? BigInt.zero) >= dataLimitBytes) {
        await AccessToken.db.updateRow(
            session,
            token.copyWith(
                isActive: false, lastUsedDeviceIdentifier: clientMacAddress));
        return AccessTokenValidationResult(
            isValid: false, message: 'Data limit reached for this token.');
      }
    }

    DateTime? activationDateToSet = token.activationDate;
    if (token.activationDate == null) {
      activationDateToSet = now;
    }
    await AccessToken.db.updateRow(
        session,
        token.copyWith(
          activationDate: activationDateToSet,
          lastUsed: now,
          lastUsedDeviceIdentifier: clientMacAddress,
        ));

    return AccessTokenValidationResult(
      isValid: true,
      message: 'Access granted.',
      userId: token.consumerId,
      planDetails: plan,
      remainingDataBytes: plan.type == PlanType.metered
          ? (BigInt.from((plan.dataLimitGB ?? 0) * 1024 * 1024 * 1024) -
                  (token.dataUsedBytes ?? BigInt.zero))
              .toDouble()
          : null,
      sessionExpiryTime: token.expiryDate,
    );
  }

  // Provider's app reports data usage for a token (for metered plans)
  Future<void> reportDataUsage(
      Session session, String tokenValue, int bytesUsed) async {
    final authenticated = await session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final userId = authenticated.userId;

    final token = await AccessToken.db
        .findFirstRow(session, where: (t) => t.tokenValue.equals(tokenValue));
    if (token == null) {
      throw Exception('Token not found.');
    }

    final hotspot = await HotspotConfig.db.findById(session, token.hotspotId);
    if (hotspot == null || hotspot.providerId != userId) {
      throw AuthenticationException(
          message: 'Provider not authorized for this token.');
    }

    if (!token.isActive) return;

    final newTotalBytes =
        (token.dataUsedBytes ?? BigInt.zero) + BigInt.from(bytesUsed);
    await AccessToken.db
        .updateRow(session, token.copyWith(dataUsedBytes: newTotalBytes));

    final plan = await Plan.db.findById(session, token.planId);
    if (plan != null && plan.type == PlanType.metered) {
      final dataLimitBytes =
          BigInt.from((plan.dataLimitGB ?? 0) * 1024 * 1024 * 1024);
      if (newTotalBytes >= dataLimitBytes) {
        await AccessToken.db.updateRow(session,
            token.copyWith(isActive: false, dataUsedBytes: newTotalBytes));
      }
    }
  }

  // Get active tokens for the authenticated consumer
 // Get active tokens for the authenticated consumer
  Future<List<AccessToken>> listMyActiveTokens(Session session) async {
    final authenticated = await session.authenticated;
    if (authenticated == null) {
      throw AuthenticationException(message: 'User not authenticated.');
    }
    final userId = authenticated.userId;

    final now = DateTime.now().toUtc();
    return await AccessToken.db.find(
      session,
      where: (t) =>
          t.consumerId.equals(userId) &
          t.isActive.equals(true) &
          (t.expiryDate > now), // Reverted to correct operator
      orderBy: (t) => t.expiryDate,
    );
  }

  String _generateSecureToken() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return 'SPW-${base64UrlEncode(values)}';
  }
}
