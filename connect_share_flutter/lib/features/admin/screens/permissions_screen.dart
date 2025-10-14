// permissions_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  List<UserProfile> _admins = [];
  bool _isLoading = true;
  String? _errorMessage;
  final _newAdminEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchAdmins();
  }

  @override
  void dispose() {
    _newAdminEmailController.dispose();
    super.dispose();
  }

  Future<void> _fetchAdmins() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final admins = await client.userProfile.listUsers(role: 'admin');
      if (!mounted) return;
      setState(() {
        _admins = admins;
        _isLoading = false;
        if (admins.isEmpty) {
          _errorMessage = "No admin users found.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load admin users: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _addAdminByEmail(String email) async {
    if (!mounted) return;
    // Basic email validation
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid email address.'),
            backgroundColor: AppColors.warning),
      );
      return;
    }

    try {
      await client.userProfile
          .makeAdminByEmail(email); // Assuming this endpoint exists
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'User with email $email promoted to admin (if they exist).'),
            backgroundColor: AppColors.success),
      );
      _newAdminEmailController.clear();
      _fetchAdmins(); // Refresh list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to promote user: ${e.toString().split(":").last.trim()}'),
            backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _removeAdmin(int userId, String adminName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.deepArmyDark.withAlpha(228),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Confirm Removal',
            style: TextStyle(color: AppColors.textColor)),
        content: Text(
            'Are you sure you want to remove admin rights from "$adminName"?',
            style: TextStyle(color: AppColors.hintColor)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child:
                  Text('Cancel', style: TextStyle(color: AppColors.hintColor))),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Remove Admin'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await client.userProfile.removeAdmin(userId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Admin role removed successfully.'),
              backgroundColor: AppColors.success),
        );
        _fetchAdmins(); // Refresh list
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to remove admin: ${e.toString().split(":").last.trim()}'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: Column(
            children: [
              _buildAddAdminForm(),
              Expanded(
                child: _isLoading
                    ? buildLoadingWidget(message: "Loading admin users...")
                    : _errorMessage != null && _admins.isEmpty
                        ? buildErrorWidget(context, _errorMessage,
                            onRetry: _fetchAdmins)
                        : _buildAdminsList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddAdminForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassmorphicCard(
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _newAdminEmailController,
                  style: TextStyle(color: AppColors.textColor),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter user email to make admin',
                    hintStyle:
                        TextStyle(color: AppColors.hintColor.withAlpha(178)),
                    prefixIcon:
                        Icon(Icons.email_outlined, color: AppColors.hintColor),
                    filled: true,
                    fillColor: AppColors.textFieldFillColor,
                    border: InputBorder
                        .none, // Remove default border as card has one
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorStyle: TextStyle(
                        color: AppColors.error.withAlpha(228),
                        fontWeight: FontWeight.w500,
                        fontSize: 0,
                        height: 0), // Hide error text
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.error, width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.error, width: 1.5)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email cannot be empty.';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Invalid email format.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addAdminByEmail(_newAdminEmailController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.matcha,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                child: const Icon(Icons.person_add_alt_1_rounded,
                    color: AppColors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminsList() {
    if (_admins.isEmpty) {
      return buildErrorWidget(
          context, _errorMessage ?? "No admin users assigned.",
          onRetry: _fetchAdmins);
    }
    return RefreshIndicator(
      onRefresh: _fetchAdmins,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _admins.length,
        itemBuilder: (context, index) {
          final admin = _admins[index];
          return _buildAdminCard(admin);
        },
      ),
    );
  }

  Widget _buildAdminCard(UserProfile admin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.matcha.withAlpha(77),
            child: Text(
                admin.displayName.isNotEmpty
                    ? admin.displayName[0].toUpperCase()
                    : 'A',
                style: TextStyle(
                    color: AppColors.textColor, fontWeight: FontWeight.bold)),
          ),
          title: Text(admin.displayName,
              style: TextStyle(
                  color: AppColors.textColor, fontWeight: FontWeight.w500)),
          subtitle: Text(sessionManager.signedInUser!.email ?? 'No email',
              style: TextStyle(color: AppColors.hintColor, fontSize: 12)),
          trailing: IconButton(
            icon: Icon(Icons.remove_moderator_rounded,
                color: AppColors.error.withAlpha(204)),
            tooltip: "Remove Admin Rights",
            onPressed: () => _removeAdmin(admin.userId, admin.displayName),
          ),
        ),
      ),
    );
  }
}
