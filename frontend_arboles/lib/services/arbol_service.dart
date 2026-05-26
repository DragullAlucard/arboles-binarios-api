import 'dart:convert';
import 'package:http/http.dart' as http;

class ArbolService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  static Future<Map<String, dynamic>> insertarNodo({
    String valor = '',
    String? lado,
    String? padre,
  }) async {
    final url = Uri.parse('$baseUrl/insertar');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'valor': valor,
        'lado': lado,
        'padre': padre,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> obtenerArbol() async {
    final url = Uri.parse('$baseUrl/arbol');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> obtenerRecorridos() async {
    final url = Uri.parse('$baseUrl/recorridos');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> reconstruirArbol({
    List<String> preorden = const [],
    List<String> inorden = const [],
  }) async {
    final url = Uri.parse('$baseUrl/reconstruir');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'preorden': preorden,
        'inorden': inorden,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> limpiarArbol() async {
    final url = Uri.parse('$baseUrl/limpiar');
    final response = await http.delete(url);
    return jsonDecode(response.body);
  }
}