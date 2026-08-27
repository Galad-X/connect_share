// earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:connect_share_client/connect_share_client.dart'; // For TransactionLog
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  List<TransactionLog> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  double _totalNetEarnings = 0.0; // Net earnings for provider
  double _totalGrossSales = 0.0; // Total sales before fees

  final _currencyFormat = NumberFormat.currency(
      symbol: '', decimalDigits: 2); // Adjust symbol for currency

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final transactions = await client.transaction.listProviderTransactions();

      // Calculate total net earnings (providerPayoutAmount for all relevant transactions)
      // Assuming all listed transactions are relevant for provider's earnings.
      _totalNetEarnings = transactions.fold(
          0.0, (sum, t) => sum + (t.providerPayoutAmount ?? 0.0));

      // Calculate total gross sales (amount for all transactions)
      _totalGrossSales = transactions.fold(0.0, (sum, t) => sum + t.amountPaid);

      if (!mounted) return;
      setState(() {
        _transactions = transactions;
        _isLoading = false;
        if (transactions.isEmpty) {
          _errorMessage = "No transaction records found.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load transactions: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    // Determine currency from first transaction if available, else default
    String currencySymbol = _transactions.isNotEmpty
        ? _transactions.first.currency.toUpperCase()
        : "CUR";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'My Earnings',
        showBackButton: true, // Assuming it's navigated to
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            onPressed: _isLoading ? null : _fetchTransactions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: _isLoading
                ? buildLoadingWidget(message: "Loading earnings data...")
                : _errorMessage != null && _transactions.isEmpty
                    ? buildErrorWidget(context, _errorMessage,
                        onRetry: _fetchTransactions)
                    : _buildEarningsContent(currencySymbol),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsContent(String currencySymbol) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GlassmorphicCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryFigure("Total Sales",
                    "$currencySymbol ${_currencyFormat.format(_totalGrossSales)}"),
                Container(
                    width: 1, height: 50, color: AppColors.glassBorderColor),
                _buildSummaryFigure("Net Earnings",
                    "$currencySymbol ${_currencyFormat.format(_totalNetEarnings)}"),
              ],
            ),
          ),
        ),
        if (_transactions.isEmpty && _errorMessage == null && !_isLoading)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GlassmorphicCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_rounded,
                            color: AppColors.hintColor, size: 48),
                        const SizedBox(height: 16),
                        Text("No Transactions",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor)),
                        const SizedBox(height: 8),
                        Text("You haven't had any transactions yet.",
                            style: TextStyle(color: AppColors.hintColor)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchTransactions,
              color: AppColors.matcha,
              backgroundColor: AppColors.background,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionCard(transaction, currencySymbol);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryFigure(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
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
    );
  }

  Widget _buildTransactionCard(
      TransactionLog transaction, String currencySymbol) {
    Color statusColor;
    String statusText =
        transaction.payoutStatus?.replaceAll('_', ' ').toUpperCase() ?? 'N/A';
    switch (transaction.payoutStatus) {
      case 'paid_out':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'failed':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.inactive;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Ref: ${transaction.paystackReference}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withAlpha(52),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withAlpha(128))),
                  child: Text(statusText,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                )
              ],
            ),
            Divider(
                height: 16, thickness: 0.5, color: AppColors.glassBorderColor),
            _buildDetailRow(Icons.monetization_on_outlined, 'Sale Amount:',
                '$currencySymbol ${_currencyFormat.format(transaction.amountPaid)}'),
            _buildDetailRow(
                Icons.account_balance_wallet_outlined,
                'Your Payout:',
                '$currencySymbol ${_currencyFormat.format(transaction.providerPayoutAmount ?? 0.0)}'),
            _buildDetailRow(Icons.attach_money_outlined, 'Platform Fee:',
                '$currencySymbol ${_currencyFormat.format(transaction.platformFee ?? 0.0)}'),
            _buildDetailRow(Icons.event_note_outlined, 'Date:',
                _formatDateTime(transaction.transactionDate)),
            _buildDetailRow(Icons.article_outlined, 'Plan ID:',
                transaction.planId.toString()),
            _buildDetailRow(Icons.person_outline, 'Consumer ID:',
                transaction.consumerId.toString()),
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
          Icon(icon, color: AppColors.hintColor.withAlpha(204), size: 16),
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
