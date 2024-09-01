import 'package:flutter/material.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/pages/share_detail_page.dart';
import 'package:geek_collection/services/collection_service.dart';

class SharedCollectionsScreen extends StatelessWidget {
  final CollectionService _collectionService = CollectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared with me'),
		  centerTitle: true,
      ),
      body: FutureBuilder<List<Collection>>(
        future: _collectionService.fetchSharedCollections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma coleção compartilhada encontrada.'));
          }

          final sharedCollections = snapshot.data!;

          return ListView.builder(
            itemCount: sharedCollections.length,
            itemBuilder: (context, index) {
              final collection = sharedCollections[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: collection.owner.profilePicture != ""
                      ? NetworkImage(collection.owner.profilePicture)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
                title: Text(collection.name),
                subtitle: Text(collection.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SharedDetailsScreen(collection: collection),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
