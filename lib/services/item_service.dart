import 'package:dio/dio.dart';
import 'package:geek_collection/domain/items/item_update_dto.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:geek_collection/domain/items/item.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/persistence_service.dart';

class ItemService {
  final Dio _dio = Dio();
  final persistenceService = GetIt.I<PersistenceService>();
  static const String _baseUrl = 'http://fedora:5002';

  Future<Result<void>> updateItem(
      int collectionId, ItemUpdate updateItem) async {
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
      final response = await _dio.put(
          '$_baseUrl/collections/$collectionId/items/${updateItem.id}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: updateItem.toJson());

      if (response.statusCode != 200) {
        return Failure('Erro ao atualizar item: ${response.statusMessage}');
      }
      return const Success(null);
    } catch (e) {
      print('Erro ao atualizar item: $e');
      return Failure('Erro ao atualizar item: $e');
    }
  }

  Future<Result<void>> deleteItem(int collectionId, int itemId) async {
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
      final response = await _dio.delete(
          '$_baseUrl/collections/$collectionId/items/$itemId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode != 200 && response.statusCode != 204) {
        return Failure('Erro ao Deletar item: ${response.statusMessage}');
      }
      return const Success(null);
    } catch (e) {
      print('Erro ao atualizar item: $e');
      return Failure('Erro ao atualizar item: $e');
    }
  }
}
