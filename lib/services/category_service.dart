import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://fedora:5002';

  Future<List<Category>> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/category',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.data);
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar categorias');
    }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
