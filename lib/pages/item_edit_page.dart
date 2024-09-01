import 'package:flutter/material.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:geek_collection/domain/items/item.dart';
import 'package:geek_collection/services/collection_service.dart';

class EditItemScreen extends StatefulWidget {
  final int collectionId;
  final Item item;

  EditItemScreen({required this.collectionId, required this.item});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final CollectionService _collectionService = CollectionService();
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _description;
  late Category _category;
  late String _condition;

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _name = widget.item.name;
    _description = widget.item.description;
    _category = widget.item.category;
    _condition = widget.item.condition;

    _loadCategories();
  }

  void _loadCategories() async {
    try {
      final categories = await _collectionService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final updatedItem = Item(
          id: widget.item.id,
          name: _name,
          description: _description,
          category: _category,
          condition: _condition,
        );
        await _collectionService.updateItem(widget.collectionId, updatedItem);
        Navigator.pop(context);
      } catch (e) {
        print('Erro ao atualizar item: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Item'),
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
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Nome é obrigatório' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Descrição é obrigatória' : null,
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
                    _category = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (value) => value == null ? 'Categoria é obrigatória' : null,
              ),
              TextFormField(
                initialValue: _condition,
                decoration: const InputDecoration(labelText: 'Condição'),
                onSaved: (value) => _condition = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Condição é obrigatória' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
