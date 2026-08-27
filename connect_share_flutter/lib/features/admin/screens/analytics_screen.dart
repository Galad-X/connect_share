// analytics_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For number formatting

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsData? _analytics;
  bool _isLoading = true;
  String? _errorMessage;
  int _touchedIndex = -1; // For PieChart interactivity

  final _numberFormat = NumberFormat.compact();

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
      final analytics = await client.admin
          .getAnalytics(); // Assuming this endpoint provides comprehensive data
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

  List<PieChartSectionData> _buildPieChartSections() {
    if (_analytics == null) return [];

    final int totalUsers = (_analytics!.totalUsers);
    final int activeHotspots = (_analytics!.activeHotspots);
    final int successfulTransactions = (_analytics!.successfulTransactions);

    // Normalize values if they are too different, or use as is
    // For this example, using raw values. Could also calculate percentages.

    final sections = [
      PieChartSectionData(
        color: AppColors.matcha,
        value: totalUsers.toDouble(),
        title: '${_numberFormat.format(totalUsers)}\nUsers',
        radius: _touchedIndex == 0 ? 70 : 60,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 0 ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor),
        showTitle: true,
      ),
      PieChartSectionData(
        color: AppColors.lemonTwist,
        value: activeHotspots.toDouble(),
        title: '${_numberFormat.format(activeHotspots)}\nHotspots',
        radius: _touchedIndex == 1 ? 70 : 60,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 1 ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: AppColors.deepArmyDark),
        showTitle: true,
      ),
      PieChartSectionData(
        color: AppColors.info,
        value: successfulTransactions.toDouble(),
        title: '${_numberFormat.format(successfulTransactions)}\nTxns',
        radius: _touchedIndex == 2 ? 70 : 60,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 2 ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor),
        showTitle: true,
      ),
    ];
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: _isLoading
              ? buildLoadingWidget(message: "Fetching analytics data...")
              : _errorMessage != null
                  ? buildErrorWidget(context, _errorMessage,
                      onRetry: _fetchAnalytics)
                  : _buildAnalyticsContent(),
        ),
      ],
    );
  }

  Widget _buildAnalyticsContent() {
    if (_analytics == null) {
      return buildErrorWidget(context, "Analytics data is missing.",
          onRetry: _fetchAnalytics);
    }

    final double totalDataUsedMB = (_analytics!.totalDataUsedMB.toDouble());
    // final double totalRevenue =
    //     (_analytics.totalRevenue).toDouble(); // Assuming 'totalRevenue' key
    // final String currency = 'NGN';

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
            Text(
              "Platform Overview",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor),
            ),
            const SizedBox(height: 20),
            GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 1.5, // Adjust aspect ratio as needed
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 50, // Creates a donut chart
                    sections: _buildPieChartSections(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildMetricCard(
                "Total Data Consumed",
                "${_numberFormat.format(totalDataUsedMB)} MB",
                Icons.data_usage_rounded,
                AppColors.warning),
            // const SizedBox(height: 16),
            // _buildMetricCard(
            //     "Total Revenue Generated",
            //     "$currency ${_numberFormat.format(totalRevenue)}",
            //     Icons.monetization_on_rounded,
            //     AppColors.success),

            const SizedBox(height: 24),
            GlassmorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "More detailed reporting and filtering options will be available in future updates.",
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

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 36, color: color.withAlpha(229)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.hintColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
