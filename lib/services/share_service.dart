import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:geek_collection/services/auth_service.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/persistence_service.dart';
import 'package:geek_collection/domain/collections/collections.dart';

class ShareService {
  final Dio _dio = Dio();
  final authService = GetIt.I<AuthService>();
  final persistenceService = GetIt.I<PersistenceService>();
  static const String _baseUrl = 'http://fedora:5002';

  Future<Result<List<Collection>>> fetchSharedCollections() async {
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
      final response = await _dio.get('$_baseUrl/collections/shares',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        List<Collection> sharedCollections = (response.data as List)
            .map((data) => Collection.fromJson(data))
            .toList();

        return Success(sharedCollections);
      }
      return const Failure('Erro ao buscar coleções compartilhadas');
    } catch (e) {
      return Failure('Erro ao buscar coleções compartilhadas: $e');
    }
  }
}
