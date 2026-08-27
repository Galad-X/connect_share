import 'package:connect_share_client/connect_share_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';

import '../../../src/serverpod_client.dart';
import '../../consumer/screens/my_tokens_screen.dart';

class PaymentScreen extends StatefulWidget {
  final HotspotConfig hotspot;
  final Plan plan;

  const PaymentScreen({super.key, required this.hotspot, required this.plan});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  static const String _callbackUrl =
      String.fromEnvironment('PAYSTACK_CALLBACK_URL');

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_callbackUrl.isEmpty) {
        throw Exception('Payment is not configured. Set PAYSTACK_CALLBACK_URL.');
      }
      final userInfo = sessionManager.signedInUser;
      if (userInfo == null) throw Exception('User not authenticated');

      // Create a unique reference for the transaction
      final reference = 'tx_${DateTime.now().millisecondsSinceEpoch}';

      final initialization = await client.transaction.initializePayment(
        reference,
        userInfo.email ?? '',
        widget.hotspot.id!,
        widget.plan.id!,
      );
      if (initialization.length < 3 || initialization[0].isEmpty ||
          initialization[1].isEmpty) {
        throw Exception('Payment initialization failed.');
      }
      final initializedTransaction = PaystackInitializedTraction(
        status: true,
        message: 'Payment initialized',
        data: PaystackInitializedTractionData(
          authorizationUrl: initialization[0],
          accessCode: initialization[1],
          reference: initialization[2],
        ),
      );

      await PaymentService.showPaymentModal(
        context,
        transaction: initializedTransaction,
        callbackUrl: _callbackUrl,
      );
      await _handleSuccessfulPayment(initialization[2]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Payment failed: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: ${e.toString()}'),
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSuccessfulPayment(String reference) async {
    try {
      await client.transaction.verifyPaymentAndGenerateToken(
        reference,
        widget.hotspot.id!,
        widget.plan.id!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful! Token generated.'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to tokens screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyTokensScreen()),
        (route) => route.isFirst,
      );
    } catch (e) {
      throw Exception('Failed to process successful payment: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing payment...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Summary Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow('Plan', widget.plan.name),
                          _buildSummaryRow('Price',
                              '${widget.plan.price} ${widget.plan.currency}'),
                          _buildSummaryRow('Hotspot', widget.hotspot.name),
                          _buildSummaryRow(
                              'Duration',
                              widget.plan.durationType
                                  .toString()
                                  .split('.')
                                  .last),
                          if (widget.plan.dataLimitGB != null)
                            _buildSummaryRow(
                                'Data Limit',
                                widget.plan.dataLimitGB
                                    .toString()
                                    .split('.')
                                    .last),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Error message display
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Payment Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.payment),
                                const SizedBox(width: 8),
                                Text(
                                  'Pay ${widget.plan.price} ${widget.plan.currency}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Security note
                  const Center(
                    child: Text(
                      'Secured by Paystack',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
