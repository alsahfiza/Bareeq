import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool loading = false;
  String? errorMsg;

  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() => errorMsg = "Email and password cannot be empty.");
      return;
    }

    setState(() {
      loading = true;
      errorMsg = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      if (!mounted) return;

      /// SUCCESS → Go to admin dashboard
      context.go("/admin/dashboard");

    } on FirebaseAuthException catch (e) {
      setState(() => errorMsg = e.message ?? "Login error occurred.");
    } catch (e) {
      setState(() => errorMsg = "Unexpected error: $e");
      #loading = false;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Admin Login",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              if (errorMsg != null)
                Text(
                  errorMsg!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  onPressed: loading ? null : login,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 16,"/admin/dashboard"),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
