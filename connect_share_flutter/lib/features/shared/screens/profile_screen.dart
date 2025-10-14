// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:connect_share_client/connect_share_client.dart'; // For UserProfile
import 'package:serverpod_auth_client/module.dart'; // For UserInfo

// Assuming your serverpod_client.dart and ui_helpers.dart are correctly pathed
import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client and sessionManager

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfo? _userInfo;
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _userInfo = sessionManager.signedInUser;
      if (_userInfo == null) {
        if (!mounted) return;
        setState(() {
          _errorMessage =
              'No user signed in. Please sign in to view your profile.';
          _isLoading = false;
        });
        return;
      }
      // Assuming UserProfile model has an id field that corresponds to UserInfo.id
      // If not, and getUserProfile takes UserInfo.id, that's fine.
      final profile = await client.userProfile.getUserProfile(_userInfo!.id!);
      if (!mounted) return;
      setState(() {
        _userProfile = profile;
        _isLoading = false;
        if (profile == null) {
          // This case might indicate a new user who doesn't have a UserProfile record yet.
          // You might want to prompt them to create one or handle it gracefully.
          _errorMessage =
              "Profile details not found. You might need to complete your profile setup.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load profile: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    // Show confirmation dialog
    final confirmSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text('Confirm Sign Out',
              style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('Are you sure you want to sign out?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.matchaDark)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Sign Out',
                  style: TextStyle(color: AppColors.white)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmSignOut == true) {
      await sessionManager.signOutDevice();
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'My Profile',
        showBackButton: false, // Assuming this is a root tab screen
        actions: [
          if (_userInfo !=
              null) // Only show sign out if user is technically signed in
            IconButton(
              icon: Icon(Icons.logout_rounded,
                  color: AppColors.textColor.withAlpha(204)),
              tooltip: "Sign Out",
              onPressed: _signOut,
            ),
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            tooltip: "Refresh Profile",
            onPressed: _isLoading ? null : _loadProfile,
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading
                ? buildLoadingWidget(message: "Loading profile...")
                : _errorMessage != null &&
                        _userInfo ==
                            null // Critical error like "No user signed in"
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _loadProfile)
                    : _buildProfileContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_userInfo == null) {
      // Should be caught by the error widget above, but as a fallback.
      return buildErrorWidget(context, "User information is not available.",
          onRetry: _loadProfile);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUserHeader(),
          const SizedBox(height: 20),
          if (_userProfile != null) ...[
            _buildSectionCard(
              title: "Profile Details",
              icon: Icons.person_pin_rounded,
              children: [
                _buildInfoRow(Icons.badge_outlined, "Display Name:",
                    _userProfile!.displayName),
                _buildInfoRow(Icons.description_outlined, "Bio:",
                    _userProfile!.bio ?? "Not set"),
                _buildInfoRow(Icons.star_outline_rounded, "Rating:",
                    _userProfile!.rating.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 20),
            _buildRoleSpecificInfo(),
          ] else if (_errorMessage != null && _userProfile == null) ...[
            // Error specifically for profile details not found, but user is signed in
            GlassmorphicCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.sentiment_dissatisfied_rounded,
                        color: AppColors.warning, size: 36),
                    const SizedBox(height: 10),
                    Text(_errorMessage!,
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 16),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to an edit profile screen or profile creation screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Edit Profile screen not implemented yet.")),
                          );
                        },
                        icon: const Icon(Icons.edit_note_rounded),
                        label: const Text("Complete Profile"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lemonTwist,
                            foregroundColor: AppColors.deepArmyDark))
                  ],
                ))
          ],
          const SizedBox(height: 20),
          _buildSectionCard(
            title: "Account Information",
            icon: Icons.account_circle_outlined,
            children: [
              _buildInfoRow(Icons.alternate_email_rounded, "Username:",
                  _userInfo!.userName!),
              _buildInfoRow(Icons.email_outlined, "Email:",
                  _userInfo!.email ?? "Not available"),
              _buildInfoRow(Icons.verified_user_outlined, "Roles:",
                  _userInfo!.scopeNames.join(', ')),
            ],
          ),

          // Consider adding an "Edit Profile" button if applicable
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    // Potentially display a profile picture here
    String initials = "";
    if (_userProfile?.displayName.isNotEmpty ?? false) {
      initials = _userProfile!.displayName
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .take(2)
          .join()
          .toUpperCase();
    } else if (_userInfo?.userName!.isNotEmpty ?? false) {
      initials = _userInfo!.userName![0].toUpperCase();
    }

    return GlassmorphicCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.matcha.withAlpha(204),
            child: Text(
              initials,
              style: TextStyle(
                  fontSize: 28,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userProfile?.displayName ?? _userInfo!.userName!,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                  overflow: TextOverflow.ellipsis,
                ),
                if (_userInfo!.email != null)
                  Text(
                    _userInfo!.email!,
                    style: TextStyle(fontSize: 14, color: AppColors.hintColor),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textTertiary, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary),
              ),
            ],
          ),
          Divider(
              height: 20, thickness: 0.5, color: AppColors.glassBorderColor),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.hintColor.withAlpha(229)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.hintColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? "N/A" : value,
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificInfo() {
    if (_userProfile == null) return const SizedBox.shrink();

    List<Widget> roleDetails = [];

    if (_userProfile!.isHotspotProvider) {
      roleDetails.addAll([
        _buildInfoRow(Icons.router_outlined, "Hotspot Count:",
            _userProfile!.hotspotCount.toString()),
        _buildInfoRow(Icons.sd_storage_outlined, "Shared Data Limit:",
            "${_userProfile!.sharedDataLimit} GB"),
      ]);
      return _buildSectionCard(
          title: "Provider Details",
          icon: Icons.business_center_outlined,
          children: roleDetails);
    } else if (_userInfo!.scopeNames.contains('consumer')) {
      roleDetails.addAll([
        _buildInfoRow(Icons.data_saver_on_outlined, "Current Data Usage:",
            "${_userProfile!.currentDataUsage} GB"),
      ]);
      return _buildSectionCard(
          title: "Consumer Details",
          icon: Icons.shopping_bag_outlined,
          children: roleDetails);
    }
    // Add more `else if` for other roles if needed.
    return const SizedBox
        .shrink(); // No specific section for other roles or if no known role matches
  }
}
