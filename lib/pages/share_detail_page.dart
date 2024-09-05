import 'package:flutter/material.dart';
import 'package:geek_collection/domain/collections/collections.dart';

class SharedDetailsScreen extends StatelessWidget {
  final Collection collection;

  SharedDetailsScreen({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          collection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                const Text(
                  'Owner',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    final owener = collection.owner;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: owener.profilePicture != ""
                              ? NetworkImage(owener.profilePicture)
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                        ),
                        title: Text(
                          owener.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Email: ${owener.email}'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
