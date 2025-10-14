// Add this widget to your SignInScreen for testing
import 'package:flutter/material.dart';
import '../src/serverpod_client.dart'; // Import to access client

class ConnectionTestWidget extends StatefulWidget {
  const ConnectionTestWidget({super.key});

  @override
  State<ConnectionTestWidget> createState() => _ConnectionTestWidgetState();
}

class _ConnectionTestWidgetState extends State<ConnectionTestWidget> {
  String _status = 'Not tested';
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing...';
    });

    try {
      // Test basic connectivity
      final result = await client.modules.auth.status.isSignedIn();
      setState(() {
        _status = 'Server connected! Auth status: $result';
      });
    } catch (e) {
      setState(() {
        _status = 'Connection failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Server Connection Test',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: $_status'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
