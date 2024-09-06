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
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _shareService = GetIt.I<ShareService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share with a Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
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
              FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formValues = _formKey.currentState!.value;
                      final result = await _shareService.shareCollections(
                          widget.collectionId, formValues['email']);

                      if (result is Success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Collection shared successfully!')),
                        );
                        Navigator.pop(context, true);
                      } else if (result is Failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.error)),
                        );
                      }
                    }
                  },
                  child: const Text('Share')),
            ],
          ),
        ),
      ),
    );
  }
}
