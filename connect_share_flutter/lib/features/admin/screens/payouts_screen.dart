// payouts_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/ui_helpers.dart';
import '../../../src/serverpod_client.dart';

class PayoutsScreen extends StatefulWidget {
  const PayoutsScreen({super.key});

  @override
  State<PayoutsScreen> createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {
  List<TransactionLog> _pendingPayouts = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _isProcessingPayoutForRef = "";
  final _currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _fetchPendingPayouts();
  }

  Future<void> _fetchPendingPayouts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Fetch transactions that are successful AND have payoutStatus 'pending_payout'
      // Your backend might need a specific endpoint for this, or client-side filtering
      final allSuccessfulTransactions = await client.admin.listTransactions(
          status:
              'successful'); // Assuming 'successful' means payment from user
      if (!mounted) return;

      setState(() {
        _pendingPayouts = allSuccessfulTransactions
            .where((t) => t.payoutStatus == 'pending_payout')
            .toList();
        _isLoading = false;
        if (_pendingPayouts.isEmpty) {
          _errorMessage = "No payouts currently pending processing.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load pending payouts: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _processPayout(String paystackReference) async {
    if (!mounted) return;
    setState(() => _isProcessingPayoutForRef = paystackReference);

    try {
      await client.admin.processPayout(paystackReference);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Payout successfully marked as processed.'),
            backgroundColor: AppColors.success),
      );
      _fetchPendingPayouts(); // Refresh the list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to process payout: ${e.toString().split(":").last.trim()}'),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isProcessingPayoutForRef = "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: _isLoading
              ? buildLoadingWidget(message: "Loading pending payouts...")
              : _errorMessage != null && _pendingPayouts.isEmpty
                  ? buildErrorWidget(context, _errorMessage,
                      onRetry: _fetchPendingPayouts)
                  : _buildPayoutsList(),
        ),
      ],
    );
  }

  Widget _buildPayoutsList() {
    if (_pendingPayouts.isEmpty) {
      return buildErrorWidget(context, _errorMessage ?? "No pending payouts.",
          onRetry: _fetchPendingPayouts);
    }
    return RefreshIndicator(
      onRefresh: _fetchPendingPayouts,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _pendingPayouts.length,
        itemBuilder: (context, index) {
          final payout = _pendingPayouts[index];
          return _buildPayoutCard(payout);
        },
      ),
    );
  }

  Widget _buildPayoutCard(TransactionLog payout) {
    final bool isProcessingThis =
        _isProcessingPayoutForRef == payout.paystackReference;
    final String currencySymbol = payout.currency.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment_rounded,
                    size: 20, color: AppColors.textColor.withAlpha(204)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                  'Ref: ${payout.paystackReference}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            Divider(height: 16, color: AppColors.glassBorderColor),
            _buildDetailRow(Icons.person_pin_circle_outlined, 'Provider ID:',
                payout.providerId.toString()),
            _buildDetailRow(
                Icons.account_balance_wallet_outlined,
                'Payout Amount:',
                '$currencySymbol ${_currencyFormat.format(payout.providerPayoutAmount ?? 0.0)}'),
            _buildDetailRow(
                Icons.event_available_rounded,
                'Transaction Date:',
                DateFormat('MMM dd, yyyy')
                    .format(payout.transactionDate.toLocal())),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isProcessingThis
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.deepArmyDark))
                    : const Icon(Icons.send_to_mobile_rounded, size: 18),
                label: Text(
                    isProcessingThis ? 'Processing...' : 'Mark as Processed'),
                onPressed: isProcessingThis
                    ? null
                    : () => _processPayout(payout.paystackReference),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lemonTwist,
                    foregroundColor: AppColors.deepArmyDark,
                    padding: const EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.hintColor.withAlpha(177), size: 16),
          const SizedBox(width: 10),
          Text('$label ',
              style: TextStyle(
                  fontSize: 13, color: AppColors.hintColor.withAlpha(228))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
