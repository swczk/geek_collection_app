import 'package:flutter/material.dart';
import 'package:geek_collection/services/collection_service.dart';

class CreateCollectionPage extends StatefulWidget {
  @override
  _CreateCollectionPageState createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  final CollectionService _collectionService = CollectionService();
  String _name = '';
  String _description = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _collectionService.createCollection(_name, _description);
        Navigator.pop(context);
      } catch (e) {
        print('Error creating collection: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Collection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Collection Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Collection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
