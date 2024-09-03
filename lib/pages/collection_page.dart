import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/pages/collection_crete_page.dart';
import 'package:geek_collection/pages/collection_detail_page.dart';
import 'package:geek_collection/services/collection_service.dart';
import 'package:geek_collection/domain/abstractions/error.dart';

class CollectionsScreen extends StatelessWidget {
  final CollectionService _collectionService = CollectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Collections')),
      body: FutureBuilder<Result<List<Collection>>>(
        future: _collectionService.fetchCollections(),
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
              return const Center(child: Text('Nenhuma coleção encontrada.'));
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
          return const Center(child: Text('Erro desconhecido.'));
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

  Widget getCard(BuildContext context, Collection collection) {
    return ListTile(
      title: Text(collection.name),
      subtitle: Text(collection.description),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CollectionDetailsScreen(collection: collection),
          ),
        );
      },
    );
  }
}
