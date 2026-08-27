import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart';

class UserProfileEndpoint extends Endpoint {
  // Helper method to ensure admin access
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

  // Fetch user profile by userId (restricted to own profile or admin)
  Future<UserProfile?> getUserProfile(Session session, int userId) async {
    final userInfo = session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }

    // Allow access if userId matches or user is admin
    if (userInfo.userId != userId &&
        !userInfo.scopes.any((scope) => scope.name == 'admin')) {
      throw AuthenticationException(
          message: 'Access denied to this user profile');
    }

    return UserProfile.db
        .findFirstRow(session, where: (t) => t.userId.equals(userId));
  }

  // Fetch authenticated user's profile
  Future<UserProfile?> getProfile(Session session) async {
    final userInfo = session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    return await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfo.userId),
    );
  }

  // Update Paystack account ID in the user profile
  Future<bool> updatePaystackAccount(
      Session session, String paystackAccountId) async {
    final userInfo = session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }

    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfo.userId),
    );

    if (profile == null) return false;

    await UserProfile.db.updateRow(
      session,
      profile.copyWith(paystackAccountId: paystackAccountId),
    );

    return true;
  }

  // Make a user an admin
  Future<void> makeAdminByEmail(Session session, String email) async {
    await _ensureAdmin(session);

    // Find user by email using serverpod auth
    final userInfo = await auth.Users.findUserByEmail(session, email);
    if (userInfo == null) {
      throw ArgumentException(message: 'User with email "$email" not found');
    }

    // Use the existing makeAdmin method with the found userId
    await makeAdmin(session, userInfo.id!);
  }

  // Make a user an admin by userId
  Future<void> makeAdmin(Session session, int userId) async {
    await _ensureAdmin(session);

    final userInfo = await auth.UserInfo.db.findById(session, userId);
    if (userInfo == null) {
      throw ArgumentException(message: 'User not found');
    }

    // Update scopes
    final scopes = [
      ...userInfo.scopes.where((s) => s.name != 'admin').map((s) => s.name),
      'admin'
    ].whereType<String>().toList();
    await auth.UserInfo.db
        .updateRow(session, userInfo.copyWith(scopeNames: scopes));

    // Update UserProfile role
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile != null) {
      await UserProfile.db.updateRow(
        session,
        profile.copyWith(role: 'admin'),
      );
    } else {
      // Create new profile if none exists
      await UserProfile.db.insertRow(
          session,
          UserProfile(
            userId: userId,
            displayName: userInfo.userName ?? 'User $userId',
            sharedDataLimit: 0.0,
            role: 'admin',
          ));
    }
  }

  // Remove admin role from a user
  Future<void> removeAdmin(Session session, int userId) async {
    await _ensureAdmin(session);

    final userInfo = await auth.UserInfo.db.findById(session, userId);
    if (userInfo == null) {
      throw ArgumentException(message: 'User not found');
    }

    // Prevent removing admin role from self
    final currentUser = session.authenticated;
    if (currentUser!.userId == userId) {
      throw ArgumentException(
          message: 'Cannot remove admin role from yourself');
    }

    // Update scopes
    final scopeNames = userInfo.scopes
        .where((scope) => scope.name != 'admin')
        .map((scope) => scope.name)
        .whereType<String>()
        .toList();
    await auth.UserInfo.db
        .updateRow(session, userInfo.copyWith(scopeNames: scopeNames));

    // Update UserProfile role
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile != null) {
      final newRole = profile.isHotspotProvider ? 'provider' : 'consumer';
      await UserProfile.db.updateRow(
        session,
        profile.copyWith(role: newRole),
      );
    }
  }

  // List users by role (for admin use)
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
}
