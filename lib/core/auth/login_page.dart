import 'package:flutter/material.dart';
import '../../shared/services/auth_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                      child: const Text('Login'),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate())
                          return;

                        setState(() => loading = true);
                        try {
                          await _auth.login(
                              email.text, password.text);
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
              TextButton(
                child: const Text('Create account'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
