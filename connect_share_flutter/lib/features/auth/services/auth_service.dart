import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_client/module.dart';

import '../../../src/serverpod_client.dart';

class AuthState extends ChangeNotifier {
  UserInfo? _userInfo;
  bool _isLoading = true;
  String? _errorMessage;

  UserInfo? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthState() {
    _loadCurrentUser();
  }

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
