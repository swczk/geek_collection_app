import 'package:flutter/material.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/pages/collection_uptade_page.dart';
import 'package:geek_collection/pages/item_create_page.dart';
import 'package:geek_collection/pages/item_edit_page.dart';
import 'package:geek_collection/pages/share_create_page.dart';

class CollectionDetailsScreen extends StatelessWidget {
  final Collection collection;

  CollectionDetailsScreen({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          collection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditCollectionScreen(collection: collection),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  collection.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Shared with',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddShareScreen(
                              collectionId: collection.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: collection.shares.length,
                  itemBuilder: (context, index) {
                    final share = collection.shares[index];
                    final user = share.user;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: user.profilePicture != ""
                              ? NetworkImage(user.profilePicture)
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                        ),
                        title: Text(
                          user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Email: ${user.email}'),
                      ),
                    );
                  },
                ),
                if (collection.shares.isEmpty)
                  const Center(child: Text("None")),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Itens',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddItemScreen(collectionId: collection.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: collection.items.length,
                  itemBuilder: (context, index) {
                    final item = collection.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(item.name),
                        leading: const Icon(Icons.abc),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.description),
                            Text('Category: ${item.category.name}'),
                            Text('Condição: ${item.condition}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditItemScreen(
                                      collectionId: collection.id, item: item)),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (collection.items.isEmpty)
                  const Center(child: Text("None")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
