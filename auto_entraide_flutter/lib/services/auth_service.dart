import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  final ApiService _apiService;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  AuthService(this._apiService);
  
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      
      final token = response['token'];
      final userData = response['user'];
      
      if (token != null && userData != null) {
        _apiService.setAuthToken(token);
        await _saveToken(token);
        await _saveUser(User.fromJson(userData));
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  
  Future<bool> register(String email, String password, String name, {String? phone, bool isProfessional = false}) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'isProfessional': isProfessional,
      });
      
      final token = response['token'];
      final userData = response['user'];
      
      if (token != null && userData != null) {
        _apiService.setAuthToken(token);
        await _saveToken(token);
        await _saveUser(User.fromJson(userData));
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }
  
  Future<void> logout() async {
    _apiService.clearAuthToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
  
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    if (token != null) {
      _apiService.setAuthToken(token);
      return true;
    }
    return false;
  }
  
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJsonString(userJson);
    }
    return null;
  }
  
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJsonString());
  }
}