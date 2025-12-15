import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../admin/admin_app.dart';
import '../../customer/customer_app.dart';

class RoleGuard extends StatelessWidget {
  final User user;
  const RoleGuard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final role = snapshot.data!['role'];

        if (role == 'admin') {
          return const AdminApp();
        } else {
          return const CustomerApp();
        }
      },
    );
  }
}
