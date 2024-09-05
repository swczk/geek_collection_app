import 'package:dio/dio.dart';
import 'package:geek_collection/domain/items/item_create_dto.dart';
import 'package:geek_collection/domain/items/item_update_dto.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/persistence_service.dart';

class ItemService {
  final Dio _dio = Dio();
  final persistenceService = GetIt.I<PersistenceService>();
  static const String _baseUrl = 'http://fedora:5002';

  Future<Result<void>> createItem({
    required int collectionId,
    required ItemCreate itemCreate,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('You are offline!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;
    try {
      final response = await _dio.post(
        '$_baseUrl/collections/$collectionId/items',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: itemCreate.toJson(),
      );

      if (response.statusCode == 201) {
        return const Success(null);
      }
      return const Failure('Error creating item');
    } catch (e) {
      return Failure('Error creating item: $e');
    }
  }

  Future<Result<void>> updateItem({
    required int collectionId,
    required ItemUpdate updateItem,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('You are offline!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.put(
          '$_baseUrl/collections/$collectionId/items/${updateItem.id}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: updateItem.toJson());

      if (response.statusCode != 200) {
        return Failure('Error updating item: ${response.statusMessage}');
      }
      return const Success(null);
    } catch (e) {
      return Failure('Error updating item: $e');
    }
  }

  Future<Result<void>> deleteItem(int collectionId, int itemId) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('You are offline!');
    }

    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.delete(
          '$_baseUrl/collections/$collectionId/items/$itemId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode != 200 && response.statusCode != 204) {
        return Failure('Error deleting item: ${response.statusMessage}');
      }
      return const Success(null);
    } catch (e) {
      return Failure('Error deleting item: $e');
    }
  }
}
