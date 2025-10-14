// hotspot_detail_screen.dart

import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart'; 
import '../../../core/widgets/ui_helpers.dart'; 
import '../../../src/serverpod_client.dart';
import '../../payment/screens/payment_screen.dart'; 

class HotspotDetailScreen extends StatefulWidget {
  final HotspotConfig hotspot;

  const HotspotDetailScreen({super.key, required this.hotspot});

  @override
  State<HotspotDetailScreen> createState() => _HotspotDetailScreenState();
}

class _HotspotDetailScreenState extends State<HotspotDetailScreen> {
  List<Plan> _plans = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final plans = await client.plan.listPlansForHotspot(widget.hotspot.id!);
      if (!mounted) return;
      setState(() {
        _plans = plans;
        _isLoading = false;
        if (plans.isEmpty) {
          _errorMessage = 'No plans available for this hotspot at the moment.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // _errorMessage =
        //     'Failed to load plans: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor is handled by buildGlassmorphicBackground if needed
      extendBodyBehindAppBar: true, // Allows content to scroll behind AppBar
      appBar: buildModernAppBar(context, widget.hotspot.name),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading
                ? buildLoadingWidget(message: "Loading plans...")
                : _errorMessage != null && _plans.isEmpty
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _fetchPlans)
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: kToolbarHeight +
                  MediaQuery.of(context).padding.top -
                  30), // Space for AppBar
          _buildHotspotInfoCard(),
          const SizedBox(height: 24),
          Text(
            'Available Plans',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor), // Text on glass background
          ),
          const SizedBox(height: 12),
          if (_plans.isEmpty && _errorMessage == null)
            Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("No plans currently available.",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 16)),
            ))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                return _buildPlanCard(plan);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHotspotInfoCard() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hotspot.name,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.wifi_tethering_rounded, 'SSID: ${widget.hotspot.ssid}'),
          const SizedBox(height: 4),
          _buildInfoRow(Icons.location_on_outlined,
              'Location: (${widget.hotspot.latitude.toStringAsFixed(4)}, ${widget.hotspot.longitude.toStringAsFixed(4)})'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.hintColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: AppColors.hintColor),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(Plan plan) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor
            .withAlpha(52), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.price_change_outlined,
              'Price: ${plan.price.toStringAsFixed(2)} ${plan.currency.toUpperCase()}',
            ),
            _buildInfoRow(
              Icons.timer_outlined,
              'Duration: ${plan.durationValue} ${plan.durationType.name}',
            ),
            // if (plan.dataLimitMegabytes != null && plan.dataLimitMegabytes! > 0)
            //   _buildInfoRow(
            //     Icons.data_usage_outlined,
            //     'Data: ${plan.dataLimitMegabytes} MB',
            //   ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      hotspot: widget.hotspot,
                      plan: plan,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lemonTwist,
                    foregroundColor: AppColors.deepArmyDark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10)),
                child: const Text('Buy Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
