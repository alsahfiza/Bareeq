// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameArCtrl = TextEditingController();

  Uint8List? imageBytes;
  bool saving = false;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    imageBytes = await picked.readAsBytes();
    setState(() {});
  }

  Future<String> uploadImage(Uint8List bytes) async {
    final fileName = "category_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance.ref().child("categories/$fileName");
    await ref.putData(bytes, SettableMetadata(contentType: "image/jpeg"));
    return await ref.getDownloadURL();
  }

  Future<void> saveCategory() async {
    if (_nameArCtrl.text.isEmpty || imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name and select an image.")),
      );
      return;
    }

    setState(() => saving = true);

    try {
      // UPLOAD IMAGE
      String imageUrl = await uploadImage(imageBytes!);

      // ADD TO FIRESTORE
      await FirebaseFirestore.instance.collection("categories").add({
        "name_ar": _nameArCtrl.text.trim(),
        "image_url": imageUrl,
        "created_at": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category added successfully ✔")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // IMAGE PREVIEW
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: imageBytes == null
                  ? const Center(child: Text("No Image"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(imageBytes!, fit: BoxFit.cover),
                    ),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: pickImage,
              child: const Text("Choose Image"),
            ),

            const SizedBox(height: 30),

            // CATEGORY NAME
            TextField(
              controller: _nameArCtrl,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: "اسم القسم (عربي)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Category",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
