// admin_dashboard_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart'; 
import '../../../core/widgets/ui_helpers.dart'; 
import '../../../src/serverpod_client.dart'; 

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AnalyticsData? _analytics;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final analytics = await client.admin.getAnalytics();
      if (!mounted) return;
      setState(() {
        _analytics = analytics;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load analytics: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This screen is already part of AdminMainNavigation, so AppBar is handled there.
    // We just build the body.
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: _isLoading
              ? buildLoadingWidget(message: "Loading dashboard stats...")
              : _errorMessage != null
                  ? buildErrorWidget(context, _errorMessage,
                      onRetry: _fetchAnalytics)
                  : _buildDashboardContent(),
        ),
      ],
    );
  }

  Widget _buildDashboardContent() {
    if (_analytics == null) {
      return buildErrorWidget(context, "Analytics data is unavailable.",
          onRetry: _fetchAnalytics);
    }
    final summaryItems = [
      _SummaryData("Total Users", _analytics!.totalUsers,
          Icons.people_alt_rounded, AppColors.matcha),
      _SummaryData("Active Hotspots", _analytics!.activeHotspots,
          Icons.wifi_tethering_rounded, AppColors.lemonTwist),
      _SummaryData(
          "Successful Transactions",
          _analytics!.successfulTransactions,
          Icons.verified_user_rounded,
          AppColors.info),
      _SummaryData("Total Data Used (MB)", _analytics!.totalDataUsedMB,
          Icons.sd_storage_rounded, AppColors.warning),
    ];

    return RefreshIndicator(
      onRefresh: _fetchAnalytics,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid for summary cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: summaryItems.length,
              itemBuilder: (context, index) {
                final item = summaryItems[index];
                return GlassmorphicCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(item.icon,
                          size: 32, color: item.color.withAlpha(204)),
                      Text(
                        item.value.toString(),
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.hintColor,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            GlassmorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Further analytics and detailed reports can be found in the 'Analytics' section from the menu.",
                  style: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SummaryData {
  final String title;
  final dynamic value; // Can be int or double
  final IconData icon;
  final Color color;
  _SummaryData(this.title, this.value, this.icon, this.color);
}
