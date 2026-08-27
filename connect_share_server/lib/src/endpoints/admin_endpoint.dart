import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  Future<void> _ensureAdmin(Session session) async {
    final userInfo = session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'Authentication required');
    }

    // Check if user has admin scope
    final hasAdminScope = userInfo.scopes.any((scope) => scope.name == 'admin');
    if (!hasAdminScope) {
      throw AuthenticationException(message: 'Admin access required');
    }
  }

  Future<List<UserProfile>> listUsers(Session session,
      {String? role, int? limit = 50}) async {
    await _ensureAdmin(session);
    return await UserProfile.db.find(
      session,
      where: role != null ? (t) => t.role.equals(role) : null,
      limit: limit,
      orderBy: (t) => t.displayName,
    );
  }

  Future<void> suspendUser(Session session, int userId) async {
    await _ensureAdmin(session);
    final userInfo = await auth.UserInfo.db.findById(session, userId);
    if (userInfo == null) throw ArgumentException(message: 'User not found');
    await auth.UserInfo.db.updateRow(session, userInfo.copyWith(blocked: true));
  }

  Future<void> deleteUser(Session session, int userId) async {
    await _ensureAdmin(session);
    final userInfo = await auth.UserInfo.db.findById(session, userId);
    if (userInfo == null) throw ArgumentException(message: 'User not found');
    await auth.UserInfo.db.deleteRow(session, userInfo);
    await UserProfile.db
        .deleteWhere(session, where: (t) => t.userId.equals(userId));
  }

  Future<Policy?> getPolicy(Session session, String type) async {
    await _ensureAdmin(session);
    if (!['terms', 'privacy'].contains(type)) {
      throw ArgumentException(message: 'Invalid policy type');
    }
    return await Policy.db.findFirstRow(
      session,
      where: (t) => t.type.equals(type),
    );
  }

  Future<void> updatePolicy(
      Session session, String type, String content) async {
    await _ensureAdmin(session);
    if (!['terms', 'privacy'].contains(type)) {
      throw ArgumentException(message: 'Invalid policy type');
    }
    if (content.isEmpty || content.length > 10000) {
      throw ArgumentException(message: 'Invalid policy content');
    }
    final userInfo = session.authenticated;
    final policy = await Policy.db
        .findFirstRow(session, where: (t) => t.type.equals(type));
    final now = DateTime.now().toUtc();
    if (policy == null) {
      await Policy.db.insertRow(
          session,
          Policy(
            type: type,
            content: content,
            updatedAt: now,
            updatedBy: userInfo!.userId,
          ));
    } else {
      await Policy.db.updateRow(
          session,
          policy.copyWith(
            content: content,
            updatedAt: now,
            updatedBy: userInfo!.userId,
          ));
    }
  }

  Future<List<Feedback>> listFeedback(Session session,
      {String? status, int? limit = 50}) async {
    await _ensureAdmin(session);
    return await Feedback.db.find(
      session,
      where: status != null ? (t) => t.status.equals(status) : null,
      limit: limit,
      orderBy: (t) => t.submittedAt,
      orderDescending: true,
    );
  }

  Future<void> respondToFeedback(
      Session session, int feedbackId, String response) async {
    await _ensureAdmin(session);
    if (response.isEmpty || response.length > 5000) {
      throw ArgumentException(message: 'Invalid response');
    }
    final feedback = await Feedback.db.findById(session, feedbackId);
    if (feedback == null)
      throw ArgumentException(message: 'Feedback not found');
    final userInfo = session.authenticated;
    await Feedback.db.updateRow(
        session,
        feedback.copyWith(
          status: 'responded',
          response: response,
          respondedAt: DateTime.now().toUtc(),
          respondedBy: userInfo!.userId,
        ));
  }

  Future<List<TransactionLog>> listTransactions(Session session,
      {String? status, int? limit = 50}) async {
    await _ensureAdmin(session);
    return await TransactionLog.db.find(
      session,
      where: status != null ? (t) => t.status.equals(status) : null,
      limit: limit,
      orderBy: (t) => t.transactionDate,
      orderDescending: true,
    );
  }

  Future<void> processPayout(Session session, String paystackReference) async {
    await _ensureAdmin(session);
    final transaction = await TransactionLog.db.findFirstRow(
      session,
      where: (t) => t.paystackReference.equals(paystackReference),
    );
    if (transaction == null)
      throw ArgumentException(message: 'Transaction not found');
    if (transaction.payoutStatus != 'pending_payout') {
      throw ArgumentException(message: 'Invalid payout status');
    }
    // Mock payout processing (integrate with actual payment API)
    await TransactionLog.db.updateRow(
        session,
        transaction.copyWith(
          payoutStatus: 'paid_out',
        ));
  }

// Quick fix - change return type to Map<String, Object>
  Future<AnalyticsData> getAnalytics(Session session) async {
    await _ensureAdmin(session);

    final users = await UserProfile.db.count(session);
    final hotspots = await HotspotConfig.db
        .count(session, where: (t) => t.isActive.equals(true));
    final transactions = await TransactionLog.db
        .count(session, where: (t) => t.status.equals('successful'));
    final dataUsed = await AccessToken.db.find(session);
    final totalDataUsed = dataUsed.fold<BigInt>(
      BigInt.zero,
      (sum, token) => sum + (token.dataUsedBytes ?? BigInt.zero),
    );

    return AnalyticsData(
      totalUsers: users,
      activeHotspots: hotspots,
      successfulTransactions: transactions,
      totalDataUsedMB: (totalDataUsed ~/ BigInt.from(1024 * 1024)).toInt(),
    );
  }
}
