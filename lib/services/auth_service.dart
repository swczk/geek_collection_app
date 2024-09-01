import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://fedora:5002';

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/user/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        return token;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
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

  Future<String?> register(
      String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/user/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return 'Erro ao registrar usuário: ${response.statusMessage}';
      }
    } catch (e) {
      return 'Erro de conexão: $e';
    }
  }
}
