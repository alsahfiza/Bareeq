// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditCategoryPage extends StatefulWidget {
  final String categoryId;

  const EditCategoryPage({super.key, required this.categoryId});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final TextEditingController _nameArCtrl = TextEditingController();

  Uint8List? newImageBytes;
  String? oldImageUrl;

  bool loading = true;
  bool saving = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  Future<void> loadCategory() async {
    var snap = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .get();

    var data = snap.data()!;
    _nameArCtrl.text = data["name_ar"];
    oldImageUrl = data["image_url"];

    setState(() => loading = false);
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    newImageBytes = await picked.readAsBytes();
    setState(() {});
  }

  Future<String> uploadImage(Uint8List bytes) async {
    final fileName = "category_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance.ref().child("categories/$fileName");

    await ref.putData(bytes, SettableMetadata(contentType: "image/jpeg"));
    return await ref.getDownloadURL();
  }

  Future<void> deleteOldImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (_) {
      // ignore 
    }
  }

  Future<void> saveChanges() async {
    if (_nameArCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name.")),
      );
      return;
    }

    setState(() => saving = true);

    String finalImageUrl = oldImageUrl!;

    // If a new image was selected
    if (newImageBytes != null) {
      await deleteOldImage(oldImageUrl!);
      finalImageUrl = await uploadImage(newImageBytes!);
    }

    // Save Firestore update
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .update({
      "name_ar": _nameArCtrl.text.trim(),
      "image_url": finalImageUrl,
      "updated_at": FieldValue.serverTimestamp(),
    });

    setState(() => saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Category updated successfully ✔")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
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
              child: newImageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(newImageBytes!, fit: BoxFit.cover),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(oldImageUrl!, fit: BoxFit.cover),
                    ),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: pickImage,
              child: const Text("Replace Image"),
            ),

            const SizedBox(height: 30),

            // NAME AR
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
                onPressed: saving ? null : saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
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
