import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/error.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/users/user.dart';
import 'package:geek_collection/services/persistence_service.dart';
import 'package:geek_collection/services/user_service.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatelessWidget {
  final persistenceService = GetIt.I<PersistenceService>();
  final userService = GetIt.I<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile'), centerTitle: true),
      body: FutureBuilder<Result<User>>(
        future: userService.fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            Navigator.of(context).pushReplacementNamed('/login');
            // return Center(child: Text('Erro: ${snapshot.error}'));
          }
          //else if (snapshot.hasData) {
          final result = snapshot.data;
          if (result is Success<User>) {
            User user = result.data;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: user.profilePicture != ""
                          ? NetworkImage(user.profilePicture)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      user.username,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        await persistenceService.removeToken();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
          } else if (result is Failure) {
            return Erro(icon: Icons.error, size: 64, mensagem: result!.error);
          }
          //}
          return const Center(child: Text('Unknown error.'));
        },
      ),
    );
  }
}
