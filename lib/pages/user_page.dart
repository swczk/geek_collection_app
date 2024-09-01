import 'package:flutter/material.dart';
import 'package:geek_collection/services/user_service.dart';
import 'package:geek_collection/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
		  centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userService.fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('Erro ao carregar o perfil do usuário.'));
          }

          final userProfile = snapshot.data!;
          final profilePicture = userProfile['profilePicture'];
          final username = userProfile['username'];
          final email = userProfile['email'];

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: profilePicture != null
                        ? NetworkImage(profilePicture)
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _authService.logout();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
