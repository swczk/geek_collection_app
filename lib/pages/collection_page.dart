import 'package:flutter/material.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/pages/collection_crete_page.dart';
import 'package:geek_collection/pages/collection_detail_page.dart';
import 'package:geek_collection/services/collection_service.dart';

class CollectionsScreen extends StatelessWidget {
  final CollectionService _collectionService = CollectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collections'),
      ),
      body: FutureBuilder<List<Collection>>(
        future: _collectionService.fetchCollections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma coleção encontrada.'));
          }

          final collections = snapshot.data!;

          return ListView.builder(
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return ListTile(
                title: Text(collection.name),
                subtitle: Text(collection.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollectionDetailsScreen(
                          collection: collection),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCollectionPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Criar nova coleção',
      ),
    );
  }
}
