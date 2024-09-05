import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/share_service.dart';
import 'package:get_it/get_it.dart';

class AddShareScreen extends StatefulWidget {
  final int collectionId;

  AddShareScreen({required this.collectionId});

  @override
  _AddShareScreenState createState() => _AddShareScreenState();
}

class _AddShareScreenState extends State<AddShareScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shareService = GetIt.I<ShareService>();

  String _email = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result =
          await _shareService.shareCollections(widget.collectionId, _email);

      if (result is Success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Collection shared successfully!')),
        );
        Navigator.pop(context, true);
      } else if (result is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error)),
        );
      }
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
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Email is required'),
                  FormBuilderValidators.email(
                      errorText: 'Please enter a valid email'),
                ]),
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: _submitForm, child: const Text('Share')),
            ],
          ),
        ),
      ),
    );
  }
}
