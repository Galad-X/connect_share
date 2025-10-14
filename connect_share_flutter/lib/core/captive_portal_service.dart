import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../src/serverpod_client.dart';
import 'hotspot_service.dart';

class CaptivePortalService {
  HttpServer? _server;
  late String _portalHtml;
  final HotspotService _hotspotService;
  final int _hotspotId;

  CaptivePortalService(this._hotspotService, this._hotspotId);

  Future<void> initialize() async {
    try {
      _portalHtml = await rootBundle.loadString('assets/captive_portal.html');
    } catch (e) {
      debugPrint('Failed to load captive portal HTML: $e');
      _portalHtml = '<h1>Error: Could not load portal page</h1>';
    }
  }

  Future<bool> start(int port) async {
    try {
      final router = Router();

      // Serve captive portal page
      router.get('/', (shelf.Request request) {
        return shelf.Response.ok(
          _portalHtml,
          headers: {'content-type': 'text/html'},
        );
      });

      // Handle token validation
      router.post('/validate-token', (shelf.Request request) async {
        try {
          final body = await request.readAsString();
          final data = jsonDecode(body);
          final String? token = data['token'];
          final String clientMac =
              request.headers['x-client-mac'] ?? 'unknown';

          if (token == null) {
            return shelf.Response(
              400,
              body: jsonEncode({'success': false, 'message': 'Token required'}),
              headers: {'content-type': 'application/json'},
            );
          }

          final result = await client.token.validateAccessTokenForCaptivePortal(
            token,
            clientMac,
            _hotspotId,
          );

          if (result.isValid) {
            // Placeholder: Attempt to allow device (requires root/VPN)
            await _hotspotService.allowDevice(
              clientMac,
              result.planDetails?.bandwidthDownMbps?.toDouble() ?? 0.0,
              result.planDetails?.bandwidthUpMbps?.toDouble() ?? 0.0,
            );
            return shelf.Response.ok(
              jsonEncode({
                'success': true,
                'message': result.message,
                'remainingDataGB': result.remainingDataBytes != null
                    ? result.remainingDataBytes! / (1024 * 1024 * 1024)
                    : null,
                'expiryTime': result.sessionExpiryTime?.toIso8601String(),
              }),
              headers: {'content-type': 'application/json'},
            );
          } else {
            return shelf.Response(
              401,
              body: jsonEncode({'success': false, 'message': result.message}),
              headers: {'content-type': 'application/json'},
            );
          }
        } catch (e) {
          debugPrint('Error validating token: $e');
          return shelf.Response(
            500,
            body: jsonEncode({'success': false, 'message': 'Server error'}),
            headers: {'content-type': 'application/json'},
          );
        }
      });

      final handler = const shelf.Pipeline()
          .addMiddleware(shelf.logRequests())
          .addHandler(router.call);

      _server = await io.serve(handler, InternetAddress.anyIPv4, port);
      debugPrint('Captive portal server started on port ${_server!.port}');
      return true;
    } catch (e) {
      debugPrint('Failed to start captive portal server: $e');
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _server?.close(force: true);
      _server = null;
      debugPrint('Captive portal server stopped');
    } catch (e) {
      debugPrint('Failed to stop captive portal server: $e');
    }
  }
}
