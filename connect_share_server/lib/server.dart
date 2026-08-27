import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'package:connect_share_server/src/web/routes/root.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

Future<void> _sendTransactionalEmail(
  Session session, {
  required String recipient,
  required String subject,
  required String html,
}) async {
  final apiKey = Serverpod.instance.passwords['resendApiKey'];
  final from = Serverpod.instance.passwords['emailFrom'];
  if (apiKey == null || apiKey.isEmpty || from == null || from.isEmpty) {
    throw Exception('Transactional email is not configured on the server.');
  }

  final httpClient = HttpClient();
  try {
    final request = await httpClient.postUrl(
      Uri.parse('https://api.resend.com/emails'),
    );
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'Bearer $apiKey')
      ..set(HttpHeaders.contentTypeHeader, 'application/json');
    request.write(jsonEncode({
      'from': from,
      'to': [recipient],
      'subject': subject,
      'html': html,
    }));
    final response = await request.close();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.transform(utf8.decoder).join();
      session.log('Email provider rejected message: $body', level: LogLevel.error);
      throw Exception('Email provider rejected the message.');
    }
  } finally {
    httpClient.close(force: true);
  }
}

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.

 

  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );
  
  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      await _sendTransactionalEmail(
        session,
        recipient: email,
        subject: 'ConnectShare verification code',
        html: '<p>Your ConnectShare verification code is:</p>'
            '<p><strong>$validationCode</strong></p>',
      );
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      final email = userInfo.email;
      if (email == null || email.isEmpty) {
        throw Exception('Cannot send password reset without an email address.');
      }
      await _sendTransactionalEmail(
        session,
        recipient: email,
        subject: 'ConnectShare password reset code',
        html: '<p>Your ConnectShare password reset code is:</p>'
            '<p><strong>$validationCode</strong></p>',
      );
      return true;
    },
  ));

  // Start the server.
  await pod.start();
}
