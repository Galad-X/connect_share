// admin_main_navigation.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For sessionManager

// Import admin screens
import 'admin_dashboard_screen.dart';
import 'analytics_screen.dart';
import 'complaints_and_suggestions_screen.dart';
import 'payouts_screen.dart';
import 'permissions_screen.dart';
import 'terms_and_policies_screen.dart';
import 'transactions_screen.dart';
import 'user_management_screen.dart';

class AdminMainNavigation extends StatefulWidget {
  const AdminMainNavigation({super.key});

  @override
  State<AdminMainNavigation> createState() => _AdminMainNavigationState();
}

class _AdminMainNavigationState extends State<AdminMainNavigation> {
  int _selectedIndex = 0;

  // Titles for the AppBar
  final List<String> _screenTitles = [
    'Admin Dashboard',
    'User Management',
    'Platform Analytics',
    'Admin Permissions',
    'Terms & Policies',
    'User Feedback',
    'All Transactions',
    'Process Payouts',
  ];

  // The screens remain the same
  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const UserManagementScreen(),
    const AnalyticsScreen(),
    const PermissionsScreen(),
    const TermsAndPoliciesScreen(),
    const ComplaintsAndSuggestionsScreen(),
    const TransactionsScreen(),
    const PayoutsScreen(),
  ];

  void _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); // Close the drawer
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.deepArmyDark.withAlpha(229),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Confirm Sign Out',
            style: TextStyle(color: AppColors.textColor)),
        content: Text('Are you sure you want to sign out from the admin panel?',
            style: TextStyle(color: AppColors.hintColor)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child:
                  Text('Cancel', style: TextStyle(color: AppColors.hintColor))),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await sessionManager.signOutDevice(); 
     
        if (!mounted) return;
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = sessionManager.signedInUser;
    if (userInfo == null || !userInfo.scopeNames.contains('admin')) {
      // This screen should ideally not be reachable if not admin.
      // Consider redirecting to login or a "not authorized" screen.
      return Scaffold(
        backgroundColor:
            AppColors.background, // Or a specific "access denied" theme
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.gpp_bad_outlined, size: 80, color: AppColors.error),
              const SizedBox(height: 20),
              const Text('Admin Access Required',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('You do not have permission to view this page.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Sign In'),
                  onPressed: () {
                    // Navigate to your sign-in screen
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                            '/signin', (Route<dynamic> route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.matcha))
            ],
          ),
        ),
      );
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true, // Important for glassmorphic AppBar
      extendBody:
          true, // Allows body content behind a potentially transparent drawer overlay
      appBar: buildModernAppBar(
          context, _screenTitles[_selectedIndex], 
          // Use a custom leading to open the drawer, as the default one might not play well with glassmorphism
          showBackButton: false, 
          leading: IconButton(
            icon: Icon(Icons.menu_rounded,
                color: AppColors.textColor.withAlpha(229)),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          )),
      drawer: _buildGlassmorphicDrawer(userInfo),
      body: IndexedStack(
        // Using IndexedStack to keep state of screens
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }

  Widget _buildGlassmorphicDrawer(dynamic userInfo) {
    // UserInfo? type from serverpod_auth_client
    return ClipRRect(
      // Clip the drawer for rounded corners if desired, but BackdropFilter handles the main effect
      // borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Drawer(
          elevation: 0,
          backgroundColor: AppColors.glassBackgroundColor
              .withAlpha(152), // More opaque for readability
          child: Column(
            children: [
              _buildDrawerHeader(userInfo),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(0, 'Dashboard', Icons.dashboard_rounded),
                    _buildDrawerItem(
                        1, 'User Management', Icons.people_alt_rounded),
                    _buildDrawerItem(2, 'Analytics', Icons.analytics_rounded),
                    _buildDrawerItem(6, 'Transactions',
                        Icons.receipt_long_rounded), // Reordered
                    _buildDrawerItem(7, 'Payouts',
                        Icons.account_balance_wallet_rounded), // Reordered
                     Divider(
                        color: AppColors.glassBorderColor,
                        indent: 16,
                        endIndent: 16),
                    _buildDrawerItem(
                        3, 'Permissions', Icons.admin_panel_settings_rounded),
                    _buildDrawerItem(
                        4, 'Terms & Policies', Icons.description_rounded),
                    _buildDrawerItem(5, 'Feedback', Icons.feedback_rounded),
                     Divider(
                        color: AppColors.glassBorderColor,
                        indent: 16,
                        endIndent: 16),
                  ],
                ),
              ),
              _buildDrawerItem(-1, 'Sign Out', Icons.logout_rounded,
                  isSignOut: true), // Special index for sign out
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(dynamic userInfo) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 20),
      decoration: BoxDecoration(
          // Optional: subtle gradient or image
          // gradient: LinearGradient(colors: [AppColors.matcha.withAlpha(77), AppColors.deepArmy.withAlpha(77)])
          ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.matcha.withAlpha(128),
            child: Text(
              userInfo?.userName?.substring(0, 1).toUpperCase() ?? "A",
              style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo?.userName ?? 'Admin',
                  style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userInfo?.email ?? 'admin@example.com',
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, String title, IconData icon,
      {bool isSignOut = false}) {
    final bool isSelected = _selectedIndex == index;
    return Material(
      // For InkWell ripple effect
      color: Colors.transparent,
      child: InkWell(
        onTap: isSignOut ? _signOut : () => _onSelectItem(index),
        splashColor: AppColors.matcha.withAlpha(52),
        highlightColor: AppColors.matcha.withAlpha(26),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.matcha.withAlpha(77)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color:
                      isSelected ? AppColors.lemonTwist : AppColors.hintColor,
                  size: 22),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? AppColors.textColor : AppColors.hintColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
