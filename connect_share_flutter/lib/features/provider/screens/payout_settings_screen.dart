// payout_settings_screen.dart
import 'package:connect_share_client/connect_share_client.dart'; // For UserProfile
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client, sessionManager

class PayoutSettingsScreen extends StatefulWidget {
  const PayoutSettingsScreen({super.key});

  @override
  State<PayoutSettingsScreen> createState() => _PayoutSettingsScreenState();
}

class _PayoutSettingsScreenState extends State<PayoutSettingsScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  final _paystackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _paystackController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final userInfo = sessionManager.signedInUser;
      if (userInfo == null) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'No user signed in.';
          _isLoading = false;
        });
        return;
      }
      final profile = await client.userProfile.getUserProfile(userInfo.id!);
      if (!mounted) return;
      setState(() {
        _userProfile = profile;
        _paystackController.text = profile?.paystackAccountId ?? '';
        _isLoading = false;
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

  Future<void> _savePaystackAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      final accountId = _paystackController.text.trim();
      await client.userProfile.updatePaystackAccount(accountId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Paystack account updated successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _loadProfile(); // Refresh profile to show updated ID
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to update: ${e.toString().split(":").last.trim()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'Payout Settings',
        showBackButton: true, // Assuming it's navigated to
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            onPressed: _isLoading || _isSaving ? null : _loadProfile,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading
                ? buildLoadingWidget(message: "Loading settings...")
                : _errorMessage != null
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _loadProfile)
                    : _buildSettingsForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassmorphicCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Paystack Account ID',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.hintColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userProfile?.paystackAccountId?.isNotEmpty ?? false
                        ? _userProfile!.paystackAccountId!
                        : 'Not Set',
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassmorphicCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Paystack Account ID",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _paystackController,
                      style: TextStyle(color: AppColors.textColor),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.textFieldFillColor,
                        hintText: 'Enter your Paystack Account ID',
                        hintStyle: TextStyle(
                            color: AppColors.hintColor.withAlpha(178)),
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined,
                            color: AppColors.hintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: AppColors.glassBorderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: AppColors.glassBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: AppColors.matcha, width: 1.5),
                        ),
                        errorStyle: TextStyle(
                            color: AppColors.error.withAlpha(229),
                            fontWeight: FontWeight.w500),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Account ID cannot be empty.';
                        }
                        // Add more specific validation for Paystack ID format if known
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isSaving
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.deepArmyDark))
                            : const Icon(Icons.save_alt_rounded),
                        label:
                            Text(_isSaving ? 'Saving...' : 'Save Account ID'),
                        onPressed: _isSaving ? null : _savePaystackAccount,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lemonTwist,
                            foregroundColor: AppColors.deepArmyDark,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            _buildInfoNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoNote() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.glassBackgroundColor.withAlpha(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.hintColor.withAlpha(204), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Ensure your Paystack Account ID is correct to receive payouts. This ID is typically provided by Paystack when you set up a Subaccount or as a merchant.",
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.hintColor.withAlpha(229),
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
