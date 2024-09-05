import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/pages/collection_uptade_page.dart';
import 'package:geek_collection/pages/item_create_page.dart';
import 'package:geek_collection/pages/item_edit_page.dart';
import 'package:geek_collection/pages/share_create_page.dart';
import 'package:geek_collection/services/share_service.dart';
import 'package:get_it/get_it.dart';

class CollectionDetailsScreen extends StatelessWidget {
  final Collection collection;
  final _shareService = GetIt.I<ShareService>();

  CollectionDetailsScreen({required this.collection});

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to remove this shared collection?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                final result =
                    await _shareService.deleteShare(collection.id, userId);
                if (result is Success) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Share deleted successfully!')));
                } else if (result is Failure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result.error)));
                }
              },
            ),
          ],
        );
      },
    );
  }

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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, user.id);
                          },
                        ),
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
                    const Text('Items',
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
                            Text('Condition: ${item.condition}'),
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
                if (collection.items.isEmpty) const Center(child: Text("None")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
