import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geek_collection/domain/users/user.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/persistence_service.dart';

class UserService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://fedora:5002';
  final persistenceService = GetIt.I<PersistenceService>();

  Future<Result<User>> fetchUserProfile() async {
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
      final response = await _dio.get('$_baseUrl/user/profile',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);

        return Success(user);
      }
      return Failure('Unexpected response status code: ${response.statusCode}');
    } catch (e) {
      return Failure('Erro ao buscar o perfil do usuário: $e');
    }
  }
}
