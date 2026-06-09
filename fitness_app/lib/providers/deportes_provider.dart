import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/deporte.dart';

class DeportesProvider extends ChangeNotifier {
  final ApiService _api;
  DeportesProvider(this._api);

  List<Deporte> _deportes = [];
  bool _isLoading = false;
  String? _error;

  List<Deporte> get deportes => _deportes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDeportes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _deportes = await _api.getDeportes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDeporte(String nombre, String? icono) async {
    try {
      final nuevo = await _api.createDeporte(nombre, icono);
      _deportes.add(nuevo);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteDeporte(int id) async {
    try {
      await _api.deleteDeporte(id);
      _deportes.removeWhere((d) => d.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
