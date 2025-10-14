// user_management_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<UserProfile> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String? _filterRole; // e.g., 'consumer', 'provider', 'admin'

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Assuming listUsers can take searchQuery and role filter
      final users = await client.userProfile.listUsers(
        limit: 20,
        role: _filterRole,
      );
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
        if (users.isEmpty) {
          _errorMessage = "No users found matching the criteria.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load users: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _performUserAction(Future<void> Function() action,
      String successMessage, String failureMessagePrefix) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(successMessage), backgroundColor: AppColors.success),
      );
      _fetchUsers(); // Refresh list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '$failureMessagePrefix: ${e.toString().split(":").last.trim()}'),
            backgroundColor: AppColors.error),
      );
    }
  }

  void _showUserDetailsDialog(UserProfile user) {
    // Placeholder for a more detailed user view/edit dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.deepArmyDark.withAlpha(228),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(user.displayName,
            style: TextStyle(color: AppColors.textColor)),
        content: SingleChildScrollView(
          child: ListBody(children: [
            Text('User ID: ${user.userId}',
                style: TextStyle(color: AppColors.hintColor)),
            Text('Bio: ${user.bio ?? "N/A"}',
                style: TextStyle(color: AppColors.hintColor)),
            Text('Role: ${user.role.capitalizeFirst()}',
                style: TextStyle(color: AppColors.hintColor)),
            Text('Rating: ${user.rating.toStringAsFixed(1)}',
                style: TextStyle(color: AppColors.hintColor)),
            // Add more details as needed
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child:
                  Text('Close', style: TextStyle(color: AppColors.hintColor)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: Column(
            children: [
              _buildSearchAndFilterBar(),
              Expanded(
                child: _isLoading
                    ? buildLoadingWidget(message: "Loading users...")
                    : _errorMessage != null && _users.isEmpty
                        ? buildErrorWidget(context, _errorMessage,
                            onRetry: _fetchUsers)
                        : _buildUsersList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    // Example roles for filter, adjust as per your UserProfile.role possibilities
    const List<String?> roles = [null, 'consumer', 'provider', 'admin'];
    const List<String> roleLabels = [
      'All Roles',
      'Consumers',
      'Providers',
      'Admins'
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GlassmorphicCard(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              style: TextStyle(color: AppColors.textColor),
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                hintStyle:
                    TextStyle(color: AppColors.hintColor.withAlpha(177)),
                prefixIcon:
                    Icon(Icons.search_rounded, color: AppColors.hintColor),
                border: InputBorder.none,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded,
                            color: AppColors.hintColor),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                          _fetchUsers();
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
              onSubmitted: (value) => _fetchUsers(),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(roles.length, (index) {
                final role = roles[index];
                final label = roleLabels[index];
                final isSelected = _filterRole == role;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _filterRole = selected ? role : null);
                      _fetchUsers();
                    },
                    backgroundColor:
                        AppColors.glassBackgroundColor.withAlpha(52),
                    selectedColor: AppColors.matcha.withAlpha(104),
                    labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.textColor
                            : AppColors.hintColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: isSelected
                              ? AppColors.matcha
                              : AppColors.glassBorderColor.withAlpha(128)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    if (_users.isEmpty) {
      return buildErrorWidget(
          context, _errorMessage ?? "No users found for the current filter.",
          onRetry: _fetchUsers);
    }
    return RefreshIndicator(
      onRefresh: _fetchUsers,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(UserProfile user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.matcha.withAlpha(77),
            child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                    color: AppColors.textColor, fontWeight: FontWeight.bold)),
          ),
          title: Text(user.displayName,
              style: TextStyle(
                  color: AppColors.textColor, fontWeight: FontWeight.w500)),
          subtitle: Text(
              '${user.displayName } • Role: ${user.role.capitalizeFirst()}',
              style: TextStyle(color: AppColors.hintColor, fontSize: 12)),
          onTap: () => _showUserDetailsDialog(user), // Open details dialog
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.hintColor),
            color: AppColors.deepArmyDark.withAlpha(244), // Glassy popup
            itemBuilder: (context) => [
              _buildPopupMenuItem('suspend', 'Suspend User',
                  Icons.block_rounded, AppColors.warning),
              _buildPopupMenuItem('delete', 'Delete User',
                  Icons.delete_forever_rounded, AppColors.error),
              if (user.role != 'admin')
                _buildPopupMenuItem('make_admin', 'Make Admin',
                    Icons.admin_panel_settings_rounded, AppColors.info),
              if (user.role == 'admin' &&
                  user.userId !=
                      sessionManager.signedInUser?.id) // Can't demote self
                _buildPopupMenuItem('remove_admin', 'Remove Admin',
                    Icons.remove_moderator_rounded, AppColors.error),
            ],
            onSelected: (value) {
              if (value == 'suspend') {
                _performUserAction(() => client.admin.suspendUser(user.userId),
                    'User suspended.', 'Failed to suspend user');
              } else if (value == 'delete') {
                _performUserAction(() => client.admin.deleteUser(user.userId),
                    'User deleted.', 'Failed to delete user');
              } else if (value == 'make_admin') {
                _performUserAction(
                    () => client.userProfile.makeAdmin(user.userId),
                    'User promoted to admin.',
                    'Failed to make admin');
              } else if (value == 'remove_admin') {
                _performUserAction(
                    () => client.userProfile.removeAdmin(user.userId),
                    'Admin role removed.',
                    'Failed to remove admin');
              }
            },
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String value, String text, IconData icon, Color iconColor) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(children: [
        Icon(icon, color: iconColor.withAlpha(204), size: 20),
        const SizedBox(width: 12),
        Text(text,
            style: TextStyle(
                color: AppColors.textColor.withAlpha(228), fontSize: 14)),
      ]),
    );
  }
}
