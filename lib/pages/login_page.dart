import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geek_collection/domain/abstractions/result.dart';
import 'package:geek_collection/domain/users/loginDto.dart';
import 'package:geek_collection/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthService _authService = GetIt.I<AuthService>();

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
                'Welcome Geek!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Image(
                width: 128,
                image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/626/626580.png'),
              ),
              const SizedBox(height: 32.0),
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
              const SizedBox(height: 32.0),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    final formValues = _formKey.currentState!.value;
                    final loginModel = LoginModel(
                      email: formValues['email'],
                      password: formValues['password'],
                    );

                    final token = await _authService.login(loginModel);

                    if (token is Success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: const Text('Login successful!')),
                      );
                      Navigator.pushReplacementNamed(context, '/collections');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error logging in')),
                      );
                    }
                  }
                },
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
