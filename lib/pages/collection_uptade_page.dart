import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/collections/collections.dart';
import 'package:geek_collection/services/collection_service.dart';

class EditCollectionScreen extends StatefulWidget {
  final Collection collection;
  final void Function(int collectionId)? onCollectionDeleted;

  EditCollectionScreen({required this.collection, this.onCollectionDeleted});

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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _confirmDelete() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Collection'),
          content:
              const Text('Are you sure you want to delete this collection?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      _deleteCollection();
    }
  }

  void _deleteCollection() async {
    try {
      var result =
          await _collectionService.deleteCollection(widget.collection.id);
      if (result is Failure) {
        _showError('Error deleting collection');
      } else if (result is Success) {
        Navigator.pop(context, true);
        if (widget.onCollectionDeleted != null) {
          widget.onCollectionDeleted!(widget.collection.id);
        }
      }
    } catch (e) {
      _showError('Error deleting collection: $e');
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
                  IconButton(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
