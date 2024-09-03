import 'package:flutter/material.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:geek_collection/services/category_service.dart';
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
        _showError('Erro ao carregar categorias');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('Erro ao carregar categorias: $e');
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
      appBar: AppBar(title: const Text('Adicionar Novo Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Exibe o carregamento
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Nome do item'),
                        onSaved: (value) => _name = value ?? '',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Nome é obrigatório'
                            : null),
                    TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Descrição do item'),
                        onSaved: (value) => _description = value ?? '',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Descrição é obrigatória'
                            : null),
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
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      validator: (value) =>
                          value == null ? 'Categoria é obrigatória' : null,
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Condição do item'),
                        onSaved: (value) => _condition = value ?? '',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Condição é obrigatória'
                            : null),
                    const SizedBox(height: 20),
                    FilledButton(
                        onPressed: _submitForm, child: const Text('Adicionar')),
                  ],
                ),
              ),
      ),
    );
  }
}
