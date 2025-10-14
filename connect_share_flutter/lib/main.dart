import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_client/module.dart';

import 'features/admin/screens/admin_main_navigation.dart';
import 'features/consumer/screens/consumer_main_navigation.dart';
import 'features/provider/screens/provider_main_navigation.dart';
import 'features/shared/screens/sign_in_screen.dart';
import 'features/shared/screens/splash_screen.dart';
import 'src/serverpod_client.dart';

// Authentication controller

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServerpodClient();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const ConnectShareApp(),
    ),
  );
}

// Authentication state management
class AuthState extends ChangeNotifier {
  UserInfo? _userInfo;
  bool _isLoading = true;
  String? _errorMessage;

  AuthState() {
    _loadCurrentUser();
  }

  UserInfo? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUserInfo(UserInfo? userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final currentUser = sessionManager.signedInUser;
      setUserInfo(currentUser);
    } catch (e) {
      _errorMessage = 'Failed to connect to server: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// Main application widget
class ConnectShareApp extends StatelessWidget {
  const ConnectShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectShare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Consumer<AuthState>(
        builder: (context, authState, _) {
          if (authState.isLoading) {
            return const SplashScreen(message: 'Connecting to server...');
          } else if (authState.errorMessage != null) {
            return SplashScreen(message: authState.errorMessage!);
          } else if (authState.userInfo == null) {
            return const SignInScreen();
          } else {
            final scopes = authState.userInfo!.scopeNames;
           
            if (scopes.contains('provider')) {
              return const ProviderMainNavigation();
            } else if (scopes.contains('consumer')) {
              return const ConsumerMainNavigation();
            } else if (scopes.contains('admin')) {
              return const AdminMainNavigation();
            } else {
              return const Center(child: Text('Unknown role'));
            }
          }
        },
      ),
      routes: {
         '/signin': (context) => const  SignInScreen(),
        // '/profile': (context) => const ProfileScreen(),
        // '/transactions': (context) => const TransactionHistoryScreen(),
      },
    );
  }
}
