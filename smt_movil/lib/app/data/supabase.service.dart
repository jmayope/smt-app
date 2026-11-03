// lib/services/supabase_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SupabaseService extends GetxService {
  static const String supabaseUrl = 'https://lfixohlfrqyzxilpdazs.supabase.co/rest/v1/';
  static const String supabaseApiKey = 'sb_publishable_VwtDyc_4HoaLKyCLSr_ZKw_g_3xIvkN';
  
  // Headers comunes para todas las peticiones
  Map<String, String> get _headers => {
    'apikey': supabaseApiKey,
    'Authorization': 'Bearer $supabaseApiKey',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
  };

  // Configuración base para las peticiones
  Map<String, String> get _httpConfig => _headers;

  /// Método genérico para SELECT
  Future<List<dynamic>> select(
    String table, {
    String? select,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? order,
    int? limit,
    Map<String, dynamic>? range,
  }) async {
    try {
      String url = '$supabaseUrl$table';
      
      // Construir query parameters
      final Map<String, String> queryParams = {};
      
      // Filtrar por columnas específicas
      if (select != null) {
        queryParams['select'] = select;
      }
      
      // Filtros WHERE
      if (filters != null) {
        filters.forEach((key, value) {
          if (value is List) {
            // Filtro IN
            queryParams[key] = 'in.(${value.join(',')})';
          } else {
            // Filtro normal EQ
            queryParams[key] = 'eq.$value';
          }
        });
      }
      
      // Ordenamiento
      if (order != null) {
        final column = order['column'];
        final direction = order['direction'] ?? 'desc';
        queryParams['order'] = '$column.$direction';
      }
      
      // Límite
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      
      // Rango
      if (range != null) {
        if (range['offset'] != null) {
          queryParams['offset'] = range['offset'].toString();
        }
        if (range['limit'] != null) {
          queryParams['limit'] = range['limit'].toString();
        }
      }
      
      // Construir URL final
      if (queryParams.isNotEmpty) {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        url = uri.toString();
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en SELECT: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en SELECT: $e');
      rethrow;
    }
  }

  /// Método genérico para INSERT
  Future<List<dynamic>> insert(String table, Map<String, dynamic> data) async {
    try {
      final headers = Map<String, String>.from(_headers);
      headers['Prefer'] = 'return=representation';
      
      final response = await http.post(
        Uri.parse('$supabaseUrl$table'),
        headers: headers,
        body: jsonEncode(data),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en INSERT: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en INSERT: $e');
      rethrow;
    }
  }

  /// Método genérico para INSERT múltiple
  Future<List<dynamic>> insertMultiple(String table, List<Map<String, dynamic>> dataList) async {
    try {
      final headers = Map<String, String>.from(_headers);
      headers['Prefer'] = 'return=representation';
      
      final response = await http.post(
        Uri.parse('$supabaseUrl$table'),
        headers: headers,
        body: jsonEncode(dataList),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en INSERT múltiple: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en INSERT múltiple: $e');
      rethrow;
    }
  }

  /// Método genérico para UPDATE
  Future<List<dynamic>> update(
    String table,
    dynamic id,
    Map<String, dynamic> data, {
    String idColumn = 'id',
  }) async {
    try {
      final headers = Map<String, String>.from(_headers);
      headers['Prefer'] = 'return=representation';
      
      final response = await http.patch(
        Uri.parse('$supabaseUrl$table?$idColumn=eq.$id'),
        headers: headers,
        body: jsonEncode(data),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en UPDATE: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en UPDATE: $e');
      rethrow;
    }
  }

  /// Método genérico para UPDATE con filtros
  Future<List<dynamic>> updateWithFilters(
    String table,
    Map<String, dynamic> data,
    Map<String, dynamic> filters,
  ) async {
    try {
      final headers = Map<String, String>.from(_headers);
      headers['Prefer'] = 'return=representation';
      
      // Construir query string con filtros
      final Map<String, String> queryParams = {};
      filters.forEach((key, value) {
        queryParams[key] = 'eq.$value';
      });
      
      final uri = Uri.parse('$supabaseUrl$table').replace(queryParameters: queryParams);
      
      final response = await http.patch(
        uri,
        headers: headers,
        body: jsonEncode(data),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en UPDATE con filtros: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en UPDATE con filtros: $e');
      rethrow;
    }
  }

  /// Método genérico para DELETE
  Future<dynamic> delete(
    String table,
    dynamic id, {
    String idColumn = 'id',
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$supabaseUrl$table?$idColumn=eq.$id'),
        headers: _headers,
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.statusCode == 204 ? null : jsonDecode(response.body);
      } else {
        throw Exception('Error en DELETE: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en DELETE: $e');
      rethrow;
    }
  }

  /// Método genérico para DELETE con filtros
  Future<dynamic> deleteWithFilters(
    String table,
    Map<String, dynamic> filters,
  ) async {
    try {
      // Construir query string con filtros
      final Map<String, String> queryParams = {};
      filters.forEach((key, value) {
        queryParams[key] = 'eq.$value';
      });
      
      final uri = Uri.parse('$supabaseUrl$table').replace(queryParameters: queryParams);
      
      final response = await http.delete(
        uri,
        headers: _headers,
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.statusCode == 204 ? null : jsonDecode(response.body);
      } else {
        throw Exception('Error en DELETE con filtros: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en DELETE con filtros: $e');
      rethrow;
    }
  }

  /// Método para realizar una consulta personalizada (con RPC)
  Future<dynamic> rpc(
    String functionName,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$supabaseUrl/rpc/$functionName'),
        headers: _headers,
        body: jsonEncode(params),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en RPC: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en RPC: $e');
      rethrow;
    }
  }

  /// Método para manejar errores de forma consistente
  Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (e) {
      // Aquí puedes agregar lógica de logging o mostrar notificaciones
      Get.snackbar(
        'Error',
        'Ocurrió un error en la operación: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    }
  }
}