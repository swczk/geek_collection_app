import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/categories/categories.dart';
import 'package:geek_collection/domain/items/item.dart';
import 'package:geek_collection/domain/items/item_update_dto.dart';
import 'package:geek_collection/services/category_service.dart';
import 'package:geek_collection/services/item_service.dart';
import 'package:get_it/get_it.dart';

class EditItemScreen extends StatefulWidget {
  final int collectionId;
  final Item item;
  final void Function(int itemId)? onItemDeleted;

  EditItemScreen(
      {required this.collectionId, required this.item, this.onItemDeleted});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final itemService = GetIt.I<ItemService>();
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
    _name = widget.item.name;
    _description = widget.item.description;
    _category = widget.item.category;
    _condition = widget.item.condition;

    _loadCategories();
  }

  void _loadCategories() async {
    try {
      var result = await categoryService.fetchCategories();
      if (result is Success) {
        setState(() {
          _categories = result.data as List<Category>;
          _category =
              _categories.contains(_category) ? _category : _categories.first;
          _isLoading = false;
        });
        _formKey.currentState?.patchValue({'category': _category});
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

  void _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      try {
        final selectedCategory = formData['category'] as Category;
        final updatedItem = ItemUpdate(
          id: widget.item.id,
          name: formData['name'],
          description: formData['description'],
          categoryId: selectedCategory.id,
          condition: formData['condition'],
        );
        var result = await itemService.updateItem(
          collectionId: widget.collectionId,
          updateItem: updatedItem,
        );

        if (result is Failure) {}
        if (result is Success) {
          widget.item.name = updatedItem.name;
          widget.item.description = updatedItem.description;
          widget.item.category = selectedCategory;
          widget.item.condition = updatedItem.condition;
          print(" =>> ${widget.item.category.toJson()}");
        }
        Navigator.pop(context);
      } catch (e) {
        _showError('Error updating item: $e');
      }
    }
  }

  void _confirmDelete() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Você tem certeza que deseja excluir este item?'),
          actions: <Widget>[
            FilledButton(
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
      _deleteItem();
    }
  }

  void _deleteItem() async {
    try {
      var result =
          await itemService.deleteItem(widget.collectionId, widget.item.id);
      if (result is Failure) {
        _showError('Error deleting item');
      } else if (result is Success) {
        Navigator.pop(context, true);
        if (widget.onItemDeleted != null) {
          widget.onItemDeleted!(widget.item.id);
        }
      }
    } catch (e) {
      _showError('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      initialValue: _name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'description',
                      initialValue: _description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderDropdown<Category>(
                      name: 'category',
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: _categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'condition',
                      initialValue: _condition,
                      decoration: const InputDecoration(labelText: 'Condition'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                            onPressed: _submitForm,
                            child: const Text('Update')),
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
