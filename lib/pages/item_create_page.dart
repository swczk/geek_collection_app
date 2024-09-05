import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:geek_collection/domain/items/item_create_dto.dart';
import 'package:geek_collection/services/category_service.dart';
import 'package:geek_collection/services/item_service.dart';
import 'package:get_it/get_it.dart';

class AddItemScreen extends StatefulWidget {
  final int collectionId;

  AddItemScreen({required this.collectionId});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final categoryService = GetIt.I<CategoryService>();
  final itemService = GetIt.I<ItemService>();

  late String _name;
  late String _description;
  Category? _category;
  late String _condition;

  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    try {
      var result = await categoryService.fetchCategories();
      if (result is Success) {
        setState(() {
          _categories = result.data;
          _isLoading = false;
        });
      } else if (result is Failure) {
        _showError('Error loading categories');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('Error loading categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final categoryId = _category?.id;
      if (categoryId == null) {
        _showError('Category is required');
        return;
      }

      final itemCreate = ItemCreate(
        name: _name,
        description: _description,
        categoryId: categoryId,
        condition: _condition,
      );

      final result = await itemService.createItem(
        collectionId: widget.collectionId,
        itemCreate: itemCreate,
      );

      if (result is Success) {
        Navigator.pop(context);
      } else if (result is Failure) {
        _showError(result.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onSaved: (value) => _name = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      onSaved: (value) => _description = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Description is required'
                          : null,
                    ),
                    DropdownButtonFormField<Category>(
                      value: _category,
                      items: _categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (Category? newValue) {
                        setState(() {
                          _category = newValue;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator: (value) =>
                          value == null ? 'Category is required' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Condition'),
                      onSaved: (value) => _condition = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Condition is required'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _submitForm,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
