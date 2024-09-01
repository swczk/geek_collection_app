import 'package:flutter/material.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/pages/item_edit_page.dart';
import 'package:geek_collection/services/collection_service.dart';

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
                  const Center(
                    child: Text(
                      "None",
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Itens',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddItemScreen(
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
                                  collectionId: collection.id,
                                  item: item,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (collection.shares.isEmpty)
                  const Center(
                    child: Text(
                      "None",
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddShareScreen extends StatefulWidget {
  final int collectionId;

  AddShareScreen({required this.collectionId});

  @override
  _AddShareScreenState createState() => _AddShareScreenState();
}

class _AddShareScreenState extends State<AddShareScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Lógica para adicionar compartilhamento
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share with a Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Email do usuário'),
                onSaved: (value) => _email = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Email é obrigatório'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Share'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  final int collectionId;

  AddItemScreen({required this.collectionId});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = '';
  String _itemDescription = '';
  String _itemCondition = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Lógica para adicionar item
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome do item'),
                onSaved: (value) => _itemName = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Nome é obrigatório'
                    : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Descrição do item'),
                onSaved: (value) => _itemDescription = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Descrição é obrigatória'
                    : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Condição do item'),
                onSaved: (value) => _itemCondition = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Condição é obrigatória'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditCollectionScreen extends StatefulWidget {
  final Collection collection;

  EditCollectionScreen({required this.collection});

  @override
  _EditCollectionScreenState createState() => _EditCollectionScreenState();
}

class _EditCollectionScreenState extends State<EditCollectionScreen> {
  final CollectionService _collectionService = CollectionService();
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _description;

  @override
  void initState() {
    super.initState();
    _name = widget.collection.name;
    _description = widget.collection.description;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _collectionService.updateCollection(
            widget.collection, _name, _description);
        Navigator.pop(context);
      } catch (e) {
        print('Erro ao atualizar coleção: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Collection'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Nome é obrigatório'
                    : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Descrição é obrigatória'
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: _submitForm,
                    child: const Text('Update'),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
