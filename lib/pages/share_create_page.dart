import 'package:flutter/material.dart';

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
                      : null),
              const SizedBox(height: 20),
              FilledButton(onPressed: _submitForm, child: const Text('Share')),
            ],
          ),
        ),
      ),
    );
  }
}
