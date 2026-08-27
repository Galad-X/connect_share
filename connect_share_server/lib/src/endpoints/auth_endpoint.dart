import 'package:serverpod/server.dart' as auth;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart'; // Access to UserProfile

class AuthEndpoint extends Endpoint {
  Future<auth.UserInfo?> completeUserSetupAndProfile(
    Session session,
    int userId, // The ID of the UserInfo created by serverpod_auth
    String displayNameForProfile, // The username chosen by the user
    String roleName,
  ) async {
    session.log(
        'completeUserSetupAndProfile called for userId: $userId, role: $roleName',
        level: LogLevel.debug);

    // Fetch the existing UserInfo object created by serverpod_auth
    var userInfo = await auth.Users.findUserByUserId(session, userId);
    if (userInfo == null) {
      session.log('User not found in completeUserSetupAndProfile. ID: $userId',
          level: LogLevel.error);
      throw Exception('User not found after email verification. ID: $userId');
    }

    // Validate roleName
    String normalizedRoleName = roleName.toLowerCase();
    if (!['consumer', 'provider'].contains(normalizedRoleName)) {
      throw ArgumentException(
          message: 'Invalid role specified. Must be "consumer" or "provider".');
    }
    if (displayNameForProfile.trim().isEmpty ||
        displayNameForProfile.length > 120) {
      throw ArgumentException(message: 'Invalid display name.');
    }

    // Prepare scopeNames list - add to existing scopes
    // serverpod_auth's `Users.createUser` (called internally by `EmailEndpoint.createAccount`)
    // already adds 'user' scope by default.
    List<String> userScopeNames = userInfo.scopeNames.toList();
    userScopeNames.add(normalizedRoleName); // Add the specific role
    if (!userScopeNames.contains('user')) {
      userScopeNames.add('user'); // Defensive
    }
    userInfo.scopeNames = userScopeNames.toSet().toList(); // Remove duplicates

    // Update the UserInfo with new scopes
    // IMPORTANT: Ensure the UserInfo object being passed to updateUser has an ID.
    // The one from findUserById will have it.
    // Convert scope names to Scope objects
    Set<auth.Scope> scopes =
        userScopeNames.map((scopeName) => auth.Scope(scopeName)).toSet();
    await auth.Users.updateUserScopes(session, userId, scopes);
    session.log(
        'UserInfo scopes updated for user ID $userId. New scopes: ${userInfo.scopeNames}',
        level: LogLevel.info);

    // Create or update corresponding UserProfile
    var existingProfile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.userId.equals(userId),
    );

    if (existingProfile == null) {
      var userProfile = UserProfile(
        userId: userId,
        displayName: displayNameForProfile,
        isHotspotProvider: normalizedRoleName == 'provider',
        sharedDataLimit: 0.0,
        currentDataUsage: 0.0,
        hotspotCount: 0,
        rating: 5.0,
      );
      await UserProfile.db.insertRow(session, userProfile);
      session.log('UserProfile created for user ID $userId',
          level: LogLevel.info);
    } else {
      session.log('UserProfile already exists for user ID $userId. Updating.',
          level: LogLevel.debug);
      existingProfile.displayName = displayNameForProfile; // Update if needed
      existingProfile.isHotspotProvider = normalizedRoleName == 'provider';
      await UserProfile.db.updateRow(session, existingProfile);
    }

    return userInfo; // Return the updated UserInfo
  }
}
