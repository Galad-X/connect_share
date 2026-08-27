// my_tokens_screen.dart
import 'package:connect_share_client/connect_share_client.dart'; // Assuming your AccessToken model is here
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/ui_helpers.dart';
import '../../../src/serverpod_client.dart';

class MyTokensScreen extends StatefulWidget {
  const MyTokensScreen({super.key});

  @override
  State<MyTokensScreen> createState() => _MyTokensScreenState();
}

class _MyTokensScreenState extends State<MyTokensScreen> {
  List<AccessToken> _tokens = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTokens();
  }

  Future<void> _fetchTokens() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Assuming client.token.listMyActiveTokens() returns List<AccessToken>
      // matching your defined model.
      final tokens = await client.token.listMyActiveTokens();
      if (!mounted) return;
      setState(() {
        _tokens = tokens;
        _isLoading = false;
        // if (tokens.isEmpty) {
        //   _errorMessage = 'No active tokens found.';
        // }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load tokens: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          buildModernAppBar(context, 'My Access Tokens', showBackButton: false),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading
                ? buildLoadingWidget(message: "Loading your tokens...")
                : _errorMessage != null && _tokens.isEmpty
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _fetchTokens)
                    : _buildTokenList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenList() {
    if (_tokens.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GlassmorphicCard(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.no_encryption_gmailerrorred_rounded,
                      color: AppColors.hintColor, size: 48),
                  const SizedBox(height: 16),
                  Text("No Active Tokens",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor)),
                  const SizedBox(height: 8),
                  Text("Purchase a plan to get an access token.",
                      style: TextStyle(color: AppColors.hintColor)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchTokens,
      color: AppColors.matcha,
      backgroundColor: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _tokens.length,
        itemBuilder: (context, index) {
          final token = _tokens[index];
          return _buildTokenCard(token);
        },
      ),
    );
  }

  Widget _buildTokenCard(AccessToken token) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    // final shortDateFormat = DateFormat('MMM dd, yyyy');

    final String displayTokenValue = token.tokenValue.length > 12
        ? '${token.tokenValue.substring(0, 8)}...${token.tokenValue.substring(token.tokenValue.length - 4)}'
        : token.tokenValue;

    final dataUsedMB = (token.dataUsedBytes != null
        ? (token.dataUsedBytes!.toInt() / (1024 * 1024))
        : 0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassmorphicCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    // Consider fetching HotspotConfig.name if available via token.hotspotId relation
                    'Token for Hotspot ID: ${token.hotspotId}',
                    style: TextStyle(
                        fontSize: 17, // Slightly smaller for better fit
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    token.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                        color: token.isActive
                            ? AppColors.deepArmyDark
                            : AppColors.white.withAlpha(178),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  backgroundColor: token.isActive
                      ? AppColors.lemonTwist
                      : AppColors.inactive.withAlpha(128),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  labelPadding: EdgeInsets.zero, // Adjust if needed
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            const SizedBox(height: 12),

            _buildTokenInfoRow(
                Icons.vpn_key_rounded, 'Value: $displayTokenValue'),
            _buildTokenInfoRow(Icons.event_available_rounded,
                'Issued: ${dateFormat.format(token.issueDate.toLocal())}'),
            _buildTokenInfoRow(Icons.timelapse_rounded,
                'Expires: ${dateFormat.format(token.expiryDate.toLocal())}'),

            if (token.activationDate != null)
              _buildTokenInfoRow(Icons.play_circle_outline_rounded,
                  'Activated: ${dateFormat.format(token.activationDate!.toLocal())}'),

            if (token.lastUsed != null)
              _buildTokenInfoRow(Icons.history_toggle_off_rounded,
                  'Last Used: ${dateFormat.format(token.lastUsed!.toLocal())}'),

            if (token.dataUsedBytes != null &&
                token.dataUsedBytes! > BigInt.zero)
              _buildTokenInfoRow(Icons.data_usage_rounded,
                  'Data Used: ${dataUsedMB.toStringAsFixed(1)} MB'),

            // If you had access to plan details, e.g. Plan Name
            // _buildTokenInfoRow(Icons.article_outlined, 'Plan ID: ${token.planId}'), // Or Plan Name if fetched
            if (token.lastUsedDeviceIdentifier != null &&
                token.lastUsedDeviceIdentifier!.isNotEmpty)
              _buildTokenInfoRow(Icons.devices_rounded,
                  'Last Device: ${token.lastUsedDeviceIdentifier}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Increased vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align icon and text top
        children: [
          Icon(icon,
              color: AppColors.hintColor.withAlpha(229),
              size: 18), // Slightly larger icon
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: AppColors.hintColor),
            ),
          ),
        ],
      ),
    );
  }
}
