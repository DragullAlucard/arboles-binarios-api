import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArbolService {
  static const String baseUrl = 'https://arboles-binarios-api.onrender.com';

  static Future<String> _obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();

    String? usuarioId = prefs.getString('usuarioId');

    if (usuarioId == null) {
      final random = Random().nextInt(999999);
      usuarioId = 'usuario_${DateTime.now().millisecondsSinceEpoch}_$random';
      await prefs.setString('usuarioId', usuarioId);
    }

    return usuarioId;
  }

  static Future<Map<String, dynamic>> insertarNodo({
    String valor = '',
    String? lado,
    String? padre,
  }) async {
    final usuarioId = await _obtenerUsuarioId();

    final url = Uri.parse('$baseUrl/insertar');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'usuarioId': usuarioId,
        'valor': valor,
        'lado': lado,
        'padre': padre,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> obtenerArbol() async {
    final usuarioId = await _obtenerUsuarioId();

    final url = Uri.parse('$baseUrl/arbol?usuarioId=$usuarioId');

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> obtenerRecorridos() async {
    final usuarioId = await _obtenerUsuarioId();

    final url = Uri.parse('$baseUrl/recorridos?usuarioId=$usuarioId');

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> reconstruirArbol({
    List<String> preorden = const [],
    List<String> inorden = const [],
  }) async {
    final usuarioId = await _obtenerUsuarioId();

    final url = Uri.parse('$baseUrl/reconstruir');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'usuarioId': usuarioId,
        'preorden': preorden,
        'inorden': inorden,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> limpiarArbol() async {
    final usuarioId = await _obtenerUsuarioId();

    final url = Uri.parse('$baseUrl/limpiar?usuarioId=$usuarioId');

    final response = await http.delete(url);

    return jsonDecode(response.body);
  }
}