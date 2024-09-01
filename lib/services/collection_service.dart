import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/domain/items/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://fedora:5002';

  Future<List<Collection>> fetchCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/collections',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Collection.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar coleções.');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<Collection> fetchCollectionDetails(int collectionId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/collections/$collectionId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Collection.fromJson(response.data);
      } else {
        throw Exception('Erro ao buscar os detalhes da coleção');
      }
    } catch (e) {
      throw Exception('Erro ao buscar os detalhes da coleção: $e');
    }
  }

  Future<void> createCollection(String name, String description) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/collections',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar coleção: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao criar coleção: $e');
      throw Exception('Erro ao criar coleção: $e');
    }
  }

  Future<void> updateCollection(Collection collection, String name, String description) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.put(
        '$_baseUrl/collections/${collection.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao atualizar coleção: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao atualizar coleção: $e');
      throw Exception('Erro ao atualizar coleção: $e');
    }
  }

  Future<Item> fetchItemDetails(int collectionId, int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/collections/$collectionId/items/$itemId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return Item.fromJson(response.data);
      } else {
        throw Exception(
            'Erro ao carregar detalhes do item: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar detalhes do item: $e');
    }
  }

  Future<void> updateItem(int collectionId, Item item) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.put(
        '$_baseUrl/collections/$collectionId/items/${item.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'name': item.name,
          'description': item.description,
          'category': item.category.id,
          'condition': item.condition,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao atualizar item: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao atualizar item: $e');
      throw Exception('Erro ao atualizar item: $e');
    }
  }

  Future<List<Collection>> fetchSharedCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/collections/shares',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Collection.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar coleções compartilhadas');
      }
    } catch (e) {
      throw Exception('Erro ao buscar coleções compartilhadas: $e');
    }
  }

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
