import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> createAdmin() async {
    try {
      setState(() => loading = true);

      String email = emailCtrl.text.trim();
      String password = passCtrl.text.trim();

      // 1 — Create Firebase Auth user
      UserCredential cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2 — Save in Firestore
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(cred.user!.uid)
          .set({
        "email": email,
        "role": "admin",
        "created_at": DateTime.now(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Admin created")));

      emailCtrl.clear();
      passCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Admin Settings",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),

          const Text("Create New Admin",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
          const SizedBox(height: 10),
          TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: loading ? null : createAdmin,
            child: loading
                ? const CircularProgressIndicator()
                : const Text("Create Admin"),
          ),
        ],
      ),
    );
  }
}
