import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geek_collection/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthService _authService = GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - Geek Collections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao Geek Collections',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      errorText: 'Email é obrigatório'),
                  FormBuilderValidators.email(
                      errorText: 'Informe um email válido'),
                ]),
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Senha é obrigatória'),
                  FormBuilderValidators.minLength(3,
                      errorText: 'A senha deve ter pelo menos 3 caracteres'),
                ]),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    final formValues = _formKey.currentState!.value;
                    final email = formValues['email'];
                    final password = formValues['password'];

                    final token = await _authService.login(email, password);

                    if (token != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login realizado com sucesso!')),
                      );
                      Navigator.pushReplacementNamed(context, '/collections');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao realizar login')),
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
                child: const Text('Ainda não tem uma conta? Registre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
