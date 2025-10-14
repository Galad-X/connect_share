// provider_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:connect_share_client/connect_share_client.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client and sessionManager

// Import screen destinations
import '../../shared/screens/profile_screen.dart'; // For example, if profile is here
import 'active_hotspot_monitor_screen.dart';
import 'earnings_screen.dart'; // Assuming you'll add an Earnings button
import 'manage_hotspot_screen.dart';
import 'manage_plans_screen.dart';
import 'payout_settings_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  List<HotspotConfig> _hotspots = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _activeHotspotCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Fetch hotspots
      final hotspots = await client.hotspot.listHotspotsForProvider();
      // Potentially fetch active session count or other summary data here
      // For now, just counting active from the fetched list
      _activeHotspotCount = hotspots.where((h) => h.isActive).length;

      if (!mounted) return;
      setState(() {
        _hotspots = hotspots;
        _isLoading = false;
        if (hotspots.isEmpty) {
          // _errorMessage = 'You haven\'t set up any hotspots yet.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load dashboard data: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme for colors not on glass

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'Provider Dashboard',
        showBackButton: false, // If it's a root screen for provider
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline_rounded,
                color: AppColors.textColor.withAlpha(229)),
            tooltip: "Profile",
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProfileScreen())), // Navigate to Profile
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            tooltip: "Refresh Dashboard",
            onPressed: _isLoading ? null : _fetchDashboardData,
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading && _hotspots.isEmpty
                ? buildLoadingWidget(message: "Loading dashboard...")
                : _errorMessage != null && _hotspots.isEmpty
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _fetchDashboardData)
                    : _buildDashboardContent(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _fetchDashboardData,
      color: AppColors.matcha,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Enable refresh even if content fits
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            Text(
              "Quick Actions",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor),
            ),
            const SizedBox(height: 12),
            _buildActionGrid(theme),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Hotspots (${_hotspots.length})",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor),
                ),
                if (_hotspots.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageHotspotScreen(
                                sessionManager: sessionManager))),
                    icon: Icon(Icons.settings_ethernet_rounded,
                        size: 18, color: AppColors.hintColor),
                    label: Text("Manage All",
                        style: TextStyle(color: AppColors.hintColor)),
                  )
              ],
            ),
            const SizedBox(height: 12),
            _hotspots.isEmpty
                ? _buildEmptyHotspotState()
                : _buildHotspotListPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.router_rounded,
                    color: AppColors.lemonTwist, size: 28),
                const SizedBox(height: 8),
                Text(
                  _hotspots.length.toString(),
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textTertiary),
                ),
                Text("Total Hotspots",
                    style:
                        TextStyle(color: AppColors.textTertiary, fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.wifi_tethering_rounded,
                    color: AppColors.matcha, size: 28),
                const SizedBox(height: 8),
                Text(
                  _activeHotspotCount
                      .toString(), // Placeholder, fetch actual active hotspots
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                ),
                Text("Active Now",
                    style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(ThemeData theme) {
    final actions = [
      _DashboardActionItem(
        icon: Icons.add_circle_outline_rounded,
        label: "New Hotspot",
        color: AppColors.matcha,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ManageHotspotScreen(
                    sessionManager: sessionManager, openCreateDialog: true))),
      ),
      _DashboardActionItem(
        icon: Icons.article_outlined,
        label: "Manage Plans",
        color: AppColors.lemonTwist,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ManagePlansScreen())),
      ),
      _DashboardActionItem(
        icon: Icons.insights_rounded,
        label: "Monitor Usage",
        color: AppColors.deepArmyLight, // Or another distinct color
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ActiveHotspotMonitorScreen())),
      ),
      _DashboardActionItem(
        icon: Icons.paid_outlined,
        label: "Earnings",
        color: Colors.blueAccent, // Example color
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EarningsScreen())),
      ),
      _DashboardActionItem(
        icon: Icons.account_balance_wallet_outlined,
        label: "Payout Settings",
        color: Colors.purpleAccent, // Example color
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PayoutSettingsScreen())),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust for screen size if needed
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0, // Make them square-ish
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GlassmorphicCard(
          padding: const EdgeInsets.all(0), // Padding handled inside
          backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
          child: InkWell(
            onTap: action.onTap,
            borderRadius:
                BorderRadius.circular(20.0), // Matches card border radius
            child: Padding(
              // Added padding inside InkWell
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon,
                      size: 32, color: action.color ?? AppColors.textColor),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.hintColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHotspotListPreview() {
    // Show only a few hotspots, e.g., the first 3
    final previewHotspots = _hotspots.take(3).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: previewHotspots.length,
      itemBuilder: (context, index) {
        final hotspot = previewHotspots[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: GlassmorphicCard(
            backgroundColor: AppColors.glassBackgroundColor.withAlpha(26),
            child: ListTile(
              leading: Icon(
                hotspot.isActive
                    ? Icons.wifi_tethering_rounded
                    : Icons.wifi_off_rounded,
                color: hotspot.isActive ? AppColors.matcha : AppColors.inactive,
                size: 28,
              ),
              title: Text(hotspot.name,
                  style: TextStyle(
                      color: AppColors.textColor, fontWeight: FontWeight.w500)),
              subtitle: Text(hotspot.ssid!,
                  style: TextStyle(color: AppColors.hintColor, fontSize: 12)),
              trailing:
                  Icon(Icons.chevron_right_rounded, color: AppColors.hintColor),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageHotspotScreen(
                            sessionManager: sessionManager,
                            initialHotspotId: hotspot.id)));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyHotspotState() {
    return GlassmorphicCard(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.router_rounded,
              size: 48, color: AppColors.hintColor.withAlpha(178)),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? "No hotspots created yet.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "Create your first hotspot to start sharing internet.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.hintColor),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Create Hotspot"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageHotspotScreen(
                        sessionManager: sessionManager,
                        openCreateDialog: true))),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lemonTwist,
              foregroundColor: AppColors.deepArmyDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  _DashboardActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
