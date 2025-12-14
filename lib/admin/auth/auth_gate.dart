import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthGate extends StatelessWidget {
  final Widget child;

  const AdminAuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snap.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("admins")
              .doc(user.uid)
              .get(),
          builder: (context, adminSnap) {
            if (!adminSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!adminSnap.data!.exists) {
              // ❌ USER IS NOT ADMIN → log out immediately
              FirebaseAuth.instance.signOut();
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Access Denied — Admins Only",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              );
            }

            return child; // ✅ USER IS ADMIN
          },
        );
      },
    );
  }
}
