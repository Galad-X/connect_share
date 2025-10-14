import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late SessionManager sessionManager;
late Client client;

Future<void> initializeServerpodClient() async {
  // The android emulator does not have access to the localhost of the machine.
  // const ipAddress = '10.0.2.2'; // Android emulator ip for the host

  // On a real device replace the ipAddress with the IP address of your computer.

  // Configure server URL from environment or default to localhost
  const serverUrlFromEnv = String.fromEnvironment('SERVERPOD_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://192.168.111.48:8083/' : serverUrlFromEnv;

  debugPrint('Connecting to Serverpod server at: $serverUrl'); // Debug log

  // Initialize Serverpod client
  client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();


  // Sets up a singleton client object that can be used to talk to the server from
  // anywhere in our app. The client is generated from your server code.
  // The client is set up to connect to a Serverpod running on a local server on
  // the default port. You will need to modify this to connect to staging or
  // production servers.
  

  // The session manager keeps track of the signed-in state of the user. You
  // can query it to see if the user is currently signed in and get information
  // about the user.
  sessionManager = SessionManager(
    caller: client.modules.auth,
  );

  await sessionManager.initialize();
}
