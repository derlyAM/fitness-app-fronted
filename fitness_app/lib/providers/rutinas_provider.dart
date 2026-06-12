import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/rutina.dart';

class RutinasProvider extends ChangeNotifier {
  final ApiService _api;
  RutinasProvider(this._api);

  List<Rutina> _rutinas = [];
  bool _isLoading = false;
  String? _error;

  List<Rutina> get rutinas => _rutinas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRutinas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _rutinas = await _api.getRutinas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Rutina> getRutinasByDeporte(int deporteId) {
    return _rutinas.where((r) => r.deporteId == deporteId).toList();
  }

  Future<bool> createRutina(
      String nombre, String? descripcion, int deporteId) async {
    try {
      final nueva = await _api.createRutina(nombre, descripcion, deporteId);
      _rutinas.add(nueva);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<Rutina?> updateRutina(int id, Map<String, dynamic> datos) async {
    try {
      final actualizada = await _api.updateRutina(id, datos);
      final index = _rutinas.indexWhere((r) => r.id == id);
      if (index != -1) {
        _rutinas[index] = actualizada;
        notifyListeners();
      }
      return actualizada;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteRutina(int id) async {
    try {
      await _api.deleteRutina(id);
      _rutinas.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
