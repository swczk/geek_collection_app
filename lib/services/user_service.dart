import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://fedora:5002';

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado. Por favor, faça login novamente.');
    }
    try {
      final response = await _dio.get(
        '$_baseUrl/user/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Erro ao buscar o perfil do usuário');
      }
    } catch (e) {
      throw Exception('Erro ao buscar o perfil do usuário: $e');
    }
  }
}
