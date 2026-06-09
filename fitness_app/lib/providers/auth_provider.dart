import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  Usuario? _usuario;
  bool _isLoading = false;
  String? _error;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _usuario != null;
  ApiService get api => _api;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _api.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['access_token']);
      _api.setToken(data['access_token']);
      _usuario = Usuario.fromJson(data['usuario']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.register(nombre, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _api.clearToken();
    _usuario = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) _api.setToken(token);
    notifyListeners();
  }
}
