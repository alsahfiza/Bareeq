import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool loading = false;
  String? errorMessage;
  bool rememberMe = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadSavedLogin();
  }

  /// Load saved login from SharedPreferences
  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString("admin_email");
    String? savedPass = prefs.getString("admin_password");

    if (savedEmail != null && savedPass != null) {
      _emailCtrl.text = savedEmail;
      _passCtrl.text = savedPass;
    }
  }

  /// Save login for next session
  Future<void> saveLogin() async {
    if (!rememberMe) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("admin_email", _emailCtrl.text.trim());
    prefs.setString("admin_password", _passCtrl.text.trim());
  }

  /// Handle login
  Future<void> login() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final email = _emailCtrl.text.trim();
      final pass = _passCtrl.text.trim();

      print("🔍 Trying to sign in: $email");

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      print("✅ Login successful: ${cred.user?.uid}");

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.code} - ${e.message}");
      setState(() => error = e.message ?? e.code);
    } catch (e) {
      print("❌ Unknown error: $e");
      setState(() => error = "Unexpected error: $e");
    } finally {
      setState(() => loading = false);
    }
  }


  /// Convert Firebase error codes to friendly messages
  String mapFirebaseError(String code) {
    switch (code) {
      case "wrong-password":
        return "❌ Incorrect password.";
      case "user-not-found":
        return "❌ No admin found with this email.";
      case "invalid-email":
        return "❌ Invalid email format.";
      case "network-request-failed":
        return "❌ Network error, check your internet.";
      default:
        return "❌ Login failed: $code";
    }
  }

  /// Forgot Password
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailCtrl.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reset link sent to your email.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send reset email.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "BAREEQ Admin Login",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),

              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (v) {
                      setState(() => rememberMe = v ?? true);
                    },
                  ),
                  const Text("Remember Me"),
                ],
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),

              TextButton(
                onPressed: resetPassword,
                child: const Text("Forgot Password?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
