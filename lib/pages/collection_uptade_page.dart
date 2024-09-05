import 'package:flutter/material.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/services/collection_service.dart';

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
        print('Error updating collection: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Collection'), centerTitle: true),
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
                      ? 'Name is required'
                      : null),
              TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value ?? '',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Description is required'
                      : null),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                      onPressed: _submitForm, child: const Text('Update')),
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
