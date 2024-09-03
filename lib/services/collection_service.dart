import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geek_collection/services/auth_service.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/persistence_service.dart';
import 'package:geek_collection/domain/collections/collections.dart';

class CollectionService {
  final Dio _dio = Dio();
  final authService = GetIt.I<AuthService>();
  final persistenceService = GetIt.I<PersistenceService>();
  static const String _baseUrl = 'http://fedora:8080';

  Future<Result<List<Collection>>> fetchCollections() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('Você está sem internet!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.get('$_baseUrl/collections',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        List<Collection> sharedCollections = (response.data as List)
            .map((data) => Collection.fromJson(data))
            .toList();

        return Success(sharedCollections);
      }
      return const Failure('Erro ao buscar coleções compartilhadas');
    } catch (e) {
      return Failure('Erro na requisição: $e');
    }
  }

  Future<Result<void>> createCollection(String name, String description) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('Você está sem internet!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.post('$_baseUrl/collections',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'name': name,
            'description': description,
          });

      if (response.statusCode != 200 && response.statusCode != 201) {
        return Failure('Erro ao criar coleção: ${response.statusMessage}');
      }
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao criar coleção: $e');
    }
  }

  Future<Result<Collection>> updateCollection(
      Collection collection, String name, String description) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('Você está sem internet!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.put('$_baseUrl/collections/${collection.id}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'name': name,
            'description': description,
          });

      if (response.statusCode != 200 && response.statusCode != 201) {
        return Failure('Erro ao atualizar coleção: ${response.statusMessage}');
      }
      collection.name = name;
      collection.description = description;

      return Success(collection);
    } catch (e) {
      return Failure('Erro ao atualizar coleção: $e');
    }
  }

  Future<Result<void>> deleteCollection(int collectionId) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('Você está sem internet!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.delete('$_baseUrl/collections/$collectionId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return Failure('Erro ao atualizar coleção: ${response.statusMessage}');
      }

      return const Success(null);
    } catch (e) {
      return Failure('Erro ao atualizar coleção: $e');
    }
  }
}
