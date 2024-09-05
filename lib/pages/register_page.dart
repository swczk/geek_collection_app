import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class RegisterScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final authService = GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Be Geek!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Image(
                width: 128,
                image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/626/626580.png'),
              ),
              const SizedBox(height: 32.0),
              FormBuilderTextField(
                name: 'username',
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(
                    errorText: 'Username is required'),
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Password is required'),
                  FormBuilderValidators.minLength(3,
                      errorText: 'Password must be at least 3 characters long'),
                ]),
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'confirm_password',
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Password confirmation is required'),
                  FormBuilderValidators.minLength(3,
                      errorText:
                          'Password confirmation must be at least 3 characters long'),
                ]),
              ),
              const SizedBox(height: 32.0),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    final formValues = _formKey.currentState!.value;
                    final username = formValues['username'];
                    final email = formValues['email'];
                    final password = formValues['password'];

                    var result =
                        await authService.register(username, email, password);

                    if (result is Failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${result.error}')),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: const Text("Sucess!")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
