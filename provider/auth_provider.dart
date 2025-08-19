import 'package:book_store_app/repository/auth_repo.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final authRepo = AuthRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _loginRes = '';
  String get loginRes => _loginRes;

  String _loginError = '';
  String get loginError => _loginError;

  Future<void> loginUser(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await authRepo.loginUsers(username, password);

      if (res != null && res.isNotEmpty) {
        _loginRes = res;
      } else {
        _loginError = "Login failed: empty response";
      }
    } catch (e) {
      _loginError = "Error in provider: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
