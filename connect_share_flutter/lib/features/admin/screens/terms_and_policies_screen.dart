// terms_and_policies_screen.dart

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class TermsAndPoliciesScreen extends StatefulWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  State<TermsAndPoliciesScreen> createState() => _TermsAndPoliciesScreenState();
}

class _TermsAndPoliciesScreenState extends State<TermsAndPoliciesScreen> {
  final _termsController = TextEditingController();
  final _privacyController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSavingTerms = false;
  bool _isSavingPrivacy = false;

  @override
  void initState() {
    super.initState();
    _fetchPolicies();
  }

  @override
  void dispose() {
    _termsController.dispose();
    _privacyController.dispose();
    super.dispose();
  }

  Future<void> _fetchPolicies() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final terms = await client.admin
          .getPolicy('terms_of_service'); // Ensure key matches backend
      final privacy = await client.admin
          .getPolicy('privacy_policy'); // Ensure key matches backend
      if (!mounted) return;
      setState(() {
        _termsController.text = terms?.content ?? '';
        _privacyController.text = privacy?.content ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // _errorMessage =
        //     'Failed to load policies: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePolicy(
      String typeKey, String content, ValueChanged<bool> setSavingState) async {
    if (!mounted) return;
    setSavingState(true);
    try {
      await client.admin.updatePolicy(typeKey, content);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${typeKey.replaceAll("_", " ").capitalizeFirst()} updated successfully.'),
            backgroundColor: AppColors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to update ${typeKey.toLowerCase()}: ${e.toString().split(":").last.trim()}'),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setSavingState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: _isLoading
              ? buildLoadingWidget(message: "Loading policies...")
              : _errorMessage != null
                  ? buildErrorWidget(context, _errorMessage,
                      onRetry: _fetchPolicies)
                  : _buildPoliciesForm(),
        ),
      ],
    );
  }

  Widget _buildPoliciesForm() {
    return RefreshIndicator(
      onRefresh: _fetchPolicies,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPolicyEditor(
              title: 'Terms of Service',
              controller: _termsController,
              isSaving: _isSavingTerms,
              onSave: () => _updatePolicy(
                  'terms_of_service',
                  _termsController.text,
                  (val) => setState(() => _isSavingTerms = val)),
            ),
            const SizedBox(height: 24),
            _buildPolicyEditor(
              title: 'Privacy Policy',
              controller: _privacyController,
              isSaving: _isSavingPrivacy,
              onSave: () => _updatePolicy(
                  'privacy_policy',
                  _privacyController.text,
                  (val) => setState(() => _isSavingPrivacy = val)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyEditor({
    required String title,
    required TextEditingController controller,
    required bool isSaving,
    required VoidCallback onSave,
  }) {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              ElevatedButton.icon(
                icon: isSaving
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.deepArmyDark))
                    : const Icon(Icons.save_alt_rounded, size: 18),
                label: Text(isSaving ? 'Saving...' : 'Save Changes'),
                onPressed: isSaving ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lemonTwist,
                  foregroundColor: AppColors.deepArmyDark,
                ),
              ),
            ],
          ),
           Divider(height: 20, color: AppColors.glassBorderColor),
          TextField(
            controller: controller,
            style: TextStyle(
                color: AppColors.textColor.withAlpha(229),
                fontSize: 14,
                height: 1.5),
            maxLines: 15, // Adjust as needed
            minLines: 8,
            decoration: InputDecoration(
              hintText: 'Enter $title content here...',
              hintStyle: TextStyle(color: AppColors.hintColor.withAlpha(152)),
              filled: true,
              fillColor: AppColors.textFieldFillColor.withAlpha(128),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.matcha, width: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
