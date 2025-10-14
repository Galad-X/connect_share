// transactions_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<TransactionLog> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _filterStatus; // For filtering by status

  final _currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

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
      final transactions =
          await client.admin.listTransactions(status: _filterStatus);
      if (!mounted) return;
      setState(() {
        _transactions = transactions;
        _isLoading = false;
        if (transactions.isEmpty) {
          _errorMessage = _filterStatus == null
              ? "No transactions found."
              : "No transactions found with status: '$_filterStatus'.";
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: Column(
            children: [
              _buildFilterBar(),
              Expanded(
                child: _isLoading
                    ? buildLoadingWidget(message: "Loading transactions...")
                    : _errorMessage != null && _transactions.isEmpty
                        ? buildErrorWidget(context, _errorMessage,
                            onRetry: _fetchTransactions)
                        : _buildTransactionsList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    // Example statuses, adjust based on your TransactionLog.status possibilities
    const List<String?> statuses = [
      null,
      'successful',
      'failed',
      'pending',
      'refunded'
    ];
    const List<String> labels = [
      'All',
      'Successful',
      'Failed',
      'Pending',
      'Refunded'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(statuses.length, (index) {
            final status = statuses[index];
            final label = labels[index];
            final isSelected = _filterStatus == status;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _filterStatus = selected ? status : null;
                  });
                  _fetchTransactions();
                },
                backgroundColor:
                    AppColors.glassBackgroundColor.withAlpha(52),
                selectedColor: AppColors.matcha.withAlpha(104),
                labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.textColor : AppColors.hintColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      color: isSelected
                          ? AppColors.matcha
                          : AppColors.glassBorderColor.withAlpha(128)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return buildErrorWidget(
          context, _errorMessage ?? "No transactions found for this filter.",
          onRetry: _fetchTransactions);
    }
    return RefreshIndicator(
      onRefresh: _fetchTransactions,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return _buildTransactionCard(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionLog transaction) {
    final String currencySymbol = transaction.currency.toUpperCase();
    Color statusColor;
    switch (transaction.status.toLowerCase()) {
      case 'successful':
        statusColor = AppColors.success;
        break;
      case 'failed':
        statusColor = AppColors.error;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'refunded':
        statusColor = AppColors.info;
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
              children: [
                Icon(Icons.receipt_long,
                    size: 20, color: AppColors.textColor.withAlpha(204)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                  'Ref: ${transaction.paystackReference}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor),
                  overflow: TextOverflow.ellipsis,
                )),
                Chip(
                  label: Text(transaction.status.toUpperCase(),
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                  backgroundColor: statusColor.withAlpha(39),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
           Divider(height: 16, color: AppColors.glassBorderColor),
            _buildDetailRow(Icons.monetization_on_outlined, 'Amount Paid:',
                '$currencySymbol ${_currencyFormat.format(transaction.amountPaid)}'),
            _buildDetailRow(Icons.person_outline, 'Consumer ID:',
                transaction.consumerId.toString()),
            _buildDetailRow(Icons.router_outlined, 'Hotspot ID:',
                transaction.hotspotId.toString()),
            _buildDetailRow(Icons.article_outlined, 'Plan ID:',
                transaction.planId.toString()),
            _buildDetailRow(
                Icons.event_note_outlined,
                'Date:',
                DateFormat('MMM dd, yyyy HH:mm')
                    .format(transaction.transactionDate.toLocal())),
            if (transaction.providerPayoutAmount != null &&
                transaction.providerPayoutAmount! > 0) ...[
               Divider(
                  height: 12,
                  color: AppColors.glassBorderColor.withAlpha(77)),
              _buildDetailRow(
                  Icons.account_balance_wallet_outlined,
                  'Provider Payout:',
                  '$currencySymbol ${_currencyFormat.format(transaction.providerPayoutAmount)} (${transaction.payoutStatus?.replaceAll("_", " ").capitalizeFirst() ?? "N/A"})'),
            ]
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
          Icon(icon, color: AppColors.hintColor.withAlpha(177), size: 15),
          const SizedBox(width: 10),
          Text('$label ',
              style: TextStyle(
                  fontSize: 12, color: AppColors.hintColor.withAlpha(228))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 12,
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
