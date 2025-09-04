import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  
  AuthProvider(this._authService) {
    _checkAuthStatus();
  }
  
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  
  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        _user = await _authService.getCurrentUser();
      }
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final success = await _authService.login(email, password);
      if (success) {
        _isLoggedIn = true;
        _user = await _authService.getCurrentUser();
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<bool> register(String email, String password, String name, {String? phone, bool isProfessional = false}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final success = await _authService.register(email, password, name, phone: phone, isProfessional: isProfessional);
      if (success) {
        _isLoggedIn = true;
        _user = await _authService.getCurrentUser();
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}