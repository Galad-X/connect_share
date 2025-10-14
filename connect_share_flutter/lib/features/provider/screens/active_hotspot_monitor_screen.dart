// active_hotspot_monitor_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connect_share_client/connect_share_client.dart'; // For AccessToken
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class ActiveHotspotMonitorScreen extends StatefulWidget {
  const ActiveHotspotMonitorScreen({super.key});

  @override
  State<ActiveHotspotMonitorScreen> createState() =>
      _ActiveHotspotMonitorScreenState();
}

class _ActiveHotspotMonitorScreenState
    extends State<ActiveHotspotMonitorScreen> {
  List<AccessToken> _activeSessions = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  DateTime? _lastRefreshed;

  @override
  void initState() {
    super.initState();
    _fetchActiveSessions();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30),
        (_) => _fetchActiveSessions(showLoading: false));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchActiveSessions({bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final sessions = await client.hotspot.listActiveSessionsForProvider();
      if (!mounted) return;
      setState(() {
        _activeSessions = sessions;
        _isLoading = false;
        _lastRefreshed = DateTime.now();
        if (sessions.isEmpty) {
          _errorMessage = 'No active user sessions found at the moment.';
        } else {
          _errorMessage = null; // Clear previous error if sessions are found
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load active sessions: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('MMM dd, HH:mm:ss').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'Active Sessions',
        showBackButton: true, // Assuming it's navigated to
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            onPressed: _isLoading ? null : () => _fetchActiveSessions(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading &&
                    _activeSessions
                        .isEmpty // Show full loading only on initial load
                ? buildLoadingWidget(message: "Fetching active sessions...")
                : _errorMessage != null && _activeSessions.isEmpty
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _fetchActiveSessions)
                    : _buildSessionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    if (_activeSessions.isEmpty && _errorMessage == null && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GlassmorphicCard(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      color: AppColors.hintColor, size: 48),
                  const SizedBox(height: 16),
                  Text("No Active Sessions",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor)),
                  const SizedBox(height: 8),
                  Text(
                    "There are currently no users connected to your hotspots.",
                    style: TextStyle(color: AppColors.hintColor),
                    textAlign: TextAlign.center,
                  ),
                  if (_lastRefreshed != null) ...[
                    const SizedBox(height: 10),
                    Text("Last checked: ${_formatDateTime(_lastRefreshed)}",
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.hintColor.withAlpha(178))),
                  ]
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_lastRefreshed != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Text(
              "Last updated: ${_formatDateTime(_lastRefreshed)}",
              style: TextStyle(
                  fontSize: 12, color: AppColors.hintColor.withAlpha(178)),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchActiveSessions,
            color: AppColors.matcha,
            backgroundColor: AppColors.background,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _activeSessions.length,
              itemBuilder: (context, index) {
                final session = _activeSessions[index];
                return _buildSessionCard(session);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(AccessToken session) {
    final dataUsedMB = (session.dataUsedBytes != null
        ? (session.dataUsedBytes!.toInt() / (1024 * 1024))
        : 0);
    final String displayTokenValue = session.tokenValue.length > 12
        ? '${session.tokenValue.substring(0, 6)}...${session.tokenValue.substring(session.tokenValue.length - 4)}'
        : session.tokenValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consumer ID: ${session.consumerId}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
                Icons.router_outlined, 'Hotspot ID: ${session.hotspotId}'),
            _buildInfoRow(Icons.article_outlined, 'Plan ID: ${session.planId}'),
            _buildInfoRow(Icons.vpn_key_outlined, 'Token: $displayTokenValue'),
            _buildInfoRow(Icons.play_arrow_rounded,
                'Activated: ${_formatDateTime(session.activationDate)}'),
            _buildInfoRow(Icons.timer_off_outlined,
                'Expires: ${_formatDateTime(session.expiryDate)}'),
            if (session.dataUsedBytes != null)
              _buildInfoRow(Icons.data_usage_outlined,
                  'Data Used: ${dataUsedMB.toStringAsFixed(2)} MB'),
            if (session.lastUsed != null)
              _buildInfoRow(Icons.history_rounded,
                  'Last Activity: ${_formatDateTime(session.lastUsed)}'),
            if (session.lastUsedDeviceIdentifier != null &&
                session.lastUsedDeviceIdentifier!.isNotEmpty)
              _buildInfoRow(Icons.devices_other_rounded,
                  'Device: ${session.lastUsedDeviceIdentifier}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.hintColor.withAlpha(204), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: AppColors.hintColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
