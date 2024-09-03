import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  PersistenceService();

  Future<Result<String>> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return const Success('');
      }
      return Success(token);
    } catch (e) {
      return Failure('Failed to get token: $e');
    }
  }

  Future<Result<void>> setToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return const Success(null);
    } catch (e) {
      return Failure('Failed to set token: $e');
    }
  }

  Future<Result<void>> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      return const Success(null);
    } catch (e) {
      return Failure('Failed to remove token: $e');
    }
  }
}
