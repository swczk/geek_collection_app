import 'package:geek_collection/domain/abstractions/error.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:geek_collection/services/share_service.dart';
import 'package:geek_collection/pages/share_detail_page.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/collections/collections.dart';

class SharedCollectionsScreen extends StatelessWidget {
  final shareService = GetIt.I<ShareService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared with me'), centerTitle: true),
      body: FutureBuilder<Result<List<Collection>>>(
        future: shareService.fetchSharedCollections(),
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
          if (result is Success<List<Collection>>) {
            List<Collection> collections = result.data;

            if (collections.isEmpty) {
              return const Center(child: Text('No collections found.'));
            }

            return ListView.builder(
              itemCount: collections.length,
              itemBuilder: (context, index) {
                return getCard(context, collections[index]);
              },
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

  Widget getCard(BuildContext context, Collection collection) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: collection.owner.profilePicture != ""
            ? NetworkImage(collection.owner.profilePicture)
            : const AssetImage('assets/default_profile.png') as ImageProvider,
      ),
      title: Text(collection.name),
      subtitle: Text(collection.description),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SharedDetailsScreen(collection: collection),
          ),
        );
      },
    );
  }
}
