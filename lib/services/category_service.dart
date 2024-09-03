import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:geek_collection/services/persistence_service.dart';
import 'package:get_it/get_it.dart';

class CategoryService {
  final Dio _dio = Dio();
  final persistenceService = GetIt.I<PersistenceService>();
  static const String _baseUrl = 'http://fedora:5002';

  Future<Result<List<Category>>> fetchCategories() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('Você está sem internet!');
    }

    Result<String?> tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    var token = (tokenResult as Success<String?>).data;

    if (tokenResult is Failure) {
      return const Failure('Token invalid or expired');
    }
    token = (tokenResult).data;

    try {
      final response = await _dio.get('$_baseUrl/categories',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        print("Category => ");
        List<Category> categories = (response.data as List)
            .map((data) => Category.fromJson(data))
            .toList();

        return Success(categories);
      }
      return Failure('Unexpected response status code: ${response.statusCode}');
    } catch (e) {
      throw Failure('Erro na requisição: $e');
    }
  }
}
