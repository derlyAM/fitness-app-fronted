import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/deporte.dart';
import '../models/ejercicio.dart';
import '../models/rutina.dart';
import '../models/sesion.dart';

class ApiService {
  static const String baseUrl = 'https://fitness-app-backend-production-5ea3.up.railway.app';

  String? _token;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<Map<String, dynamic>> register(
      String nombre, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: _headers,
      body: jsonEncode({'nombre': nombre, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception(jsonDecode(response.body)['detail']);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception(jsonDecode(response.body)['detail']);
  }

  Future<List<Deporte>> getDeportes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/deportes/'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Deporte.fromJson(e)).toList();
    }
    throw Exception('Error al obtener deportes');
  }

  Future<Deporte> createDeporte(String nombre, String? icono) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/deportes/'),
      headers: _headers,
      body: jsonEncode({'nombre': nombre, 'icono': icono}),
    );
    if (response.statusCode == 200) return Deporte.fromJson(jsonDecode(response.body));
    throw Exception('Error al crear deporte');
  }

  Future<void> deleteDeporte(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/deportes/$id'), headers: _headers);
    if (response.statusCode != 200) throw Exception('Error al eliminar deporte');
  }

  Future<List<Ejercicio>> getEjerciciosByDeporte(int deporteId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/ejercicios/deporte/$deporteId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Ejercicio.fromJson(e)).toList();
    }
    throw Exception('Error al obtener ejercicios');
  }

  Future<Ejercicio> createEjercicio(Map<String, dynamic> datos) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/ejercicios/'),
      headers: _headers,
      body: jsonEncode(datos),
    );
    if (response.statusCode == 200) return Ejercicio.fromJson(jsonDecode(response.body));
    throw Exception('Error al crear ejercicio');
  }

  Future<void> deleteEjercicio(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/ejercicios/$id'), headers: _headers);
    if (response.statusCode != 200) throw Exception('Error al eliminar ejercicio');
  }

  Future<List<Rutina>> getRutinas() async {
    final response = await http.get(Uri.parse('$baseUrl/api/rutinas/'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Rutina.fromJson(e)).toList();
    }
    throw Exception('Error al obtener rutinas');
  }

  Future<Rutina> createRutina(
      String nombre, String? descripcion, int deporteId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/rutinas/'),
      headers: _headers,
      body: jsonEncode({'nombre': nombre, 'descripcion': descripcion, 'deporte_id': deporteId}),
    );
    if (response.statusCode == 200) return Rutina.fromJson(jsonDecode(response.body));
    throw Exception('Error al crear rutina');
  }

  Future<Rutina> updateRutina(int id, Map<String, dynamic> datos) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/rutinas/$id'),
      headers: _headers,
      body: jsonEncode(datos),
    );
    if (response.statusCode == 200) return Rutina.fromJson(jsonDecode(response.body));
    throw Exception('Error al actualizar rutina');
  }

  Future<void> deleteRutina(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/rutinas/$id'), headers: _headers);
    if (response.statusCode != 200) throw Exception('Error al eliminar rutina');
  }

  Future<List<Sesion>> getSesiones() async {
    final response = await http.get(Uri.parse('$baseUrl/api/sesiones/'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Sesion.fromJson(e)).toList();
    }
    throw Exception('Error al obtener sesiones');
  }

  Future<Sesion> createSesion(
      int rutinaId, int? duracion, String? notas) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/sesiones/'),
      headers: _headers,
      body: jsonEncode({'rutina_id': rutinaId, 'duracion': duracion, 'notas': notas}),
    );
    if (response.statusCode == 200) return Sesion.fromJson(jsonDecode(response.body));
    throw Exception('Error al crear sesión');
  }

  Future<Sesion> updateSesion(int id, Map<String, dynamic> datos) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/sesiones/$id'),
      headers: _headers,
      body: jsonEncode(datos),
    );
    if (response.statusCode == 200) return Sesion.fromJson(jsonDecode(response.body));
    throw Exception('Error al actualizar sesión');
  }

  Future<void> deleteSesion(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/sesiones/$id'), headers: _headers);
    if (response.statusCode != 200) throw Exception('Error al eliminar sesión');
  }
}
