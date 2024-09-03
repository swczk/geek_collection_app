import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/users/loginDto.dart';
import 'package:geek_collection/services/persistence_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://fedora:8080';
  final persistenceService = GetIt.I<PersistenceService>();

  Future<Result<bool>> login(LoginModel loginModel) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi)) {
      return const Failure('Você está sem internet!');
    }

    try {
      final response =
          await _dio.post('$_baseUrl/user/login', data: loginModel.toJson());

      if (response.statusCode == 200) {
        String token = response.data['token'];
        final setTokenResult = await persistenceService.setToken(token);

        if (setTokenResult is Failure) {
          return const Failure('Failed to save token');
        }
        return const Success(true);
      }
      return Failure('Login failed with status code: ${response.statusCode}');
    } catch (e) {
      return Failure('Login failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<Result<bool>> register(
      String username, String email, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/user/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });

      if (response.statusCode != 200) {
        return Failure('Erro ao registrar usuário: ${response.statusMessage}');
      }
      return const Success(true);
    } catch (e) {
      return Failure('Login failed: $e');
    }
  }

  Future<Result<bool>> isValidToken() async {
    final tokenResult = await persistenceService.getToken();
    if (tokenResult is Failure) {
      return const Failure('Failed to retrieve token');
    }
    final token = (tokenResult as Success<String?>).data;

    try {
      final response = await _dio.get('$_baseUrl/user/verify',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (response.statusCode == 401) {
        await persistenceService.removeToken();
        return const Success(false);
      }
      return const Success(true);
    } catch (e) {
      return Failure('Token verification failed: $e');
    }
  }
}
