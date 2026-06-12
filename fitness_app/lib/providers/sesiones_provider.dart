import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/sesion.dart';

class SesionesProvider extends ChangeNotifier {
  final ApiService _api;
  SesionesProvider(this._api);

  List<Sesion> _sesiones = [];
  bool _isLoading = false;
  String? _error;

  List<Sesion> get sesiones => _sesiones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSesiones() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _sesiones = await _api.getSesiones();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSesion(
      int rutinaId, int? duracion, String? notas) async {
    try {
      final nueva = await _api.createSesion(rutinaId, duracion, notas);
      _sesiones.add(nueva);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<Sesion?> updateSesion(int id, Map<String, dynamic> datos) async {
    try {
      final actualizada = await _api.updateSesion(id, datos);
      final index = _sesiones.indexWhere((s) => s.id == id);
      if (index != -1) {
        _sesiones[index] = actualizada;
        notifyListeners();
      }
      return actualizada;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteSesion(int id) async {
    try {
      await _api.deleteSesion(id);
      _sesiones.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
