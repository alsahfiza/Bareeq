import 'package:flutter/material.dart';
import '../../shared/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: email,
                decoration:
                    const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: password,
                decoration:
                    const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) =>
                    v!.length < 6 ? 'Min 6 chars' : null,
              ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      child: const Text('Create Account'),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate())
                          return;

                        setState(() => loading = true);
                        try {
                          await _auth.registerCustomer(
                            email.text,
                            password.text,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                                content: Text(e.toString())),
                          );
                        }
                        setState(() => loading = false);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
