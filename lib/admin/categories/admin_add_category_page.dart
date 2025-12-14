import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  final nameArCtrl = TextEditingController();
  final nameEnCtrl = TextEditingController();

  File? selectedImage;
  bool saving = false;

  @override
  void dispose() {
    nameArCtrl.dispose();
    nameEnCtrl.dispose();
    super.dispose();
  }

  /* -----------------------------------------------------------
  |                     IMAGE PICK + COMPRESS
  ------------------------------------------------------------ */

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<File> compressImage(File file) async {
    final config = Configuration(
      outputType: ImageOutputType.jpg,
      quality: 40,
    );

    final input = ImageFile(
      rawBytes: await file.readAsBytes(),
      filePath: file.path,
    );

    final output = await compressor.compress(
      ImageFileConfiguration(input: input, config: config),
    );

    final out = File("${file.path}_compressed.jpg");
    return await out.writeAsBytes(output.rawBytes);
  }

  /* -----------------------------------------------------------
  |                     ADD CATEGORY TO FIRESTORE
  ------------------------------------------------------------ */

  Future<void> saveCategory() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedImage == null) {
      showMessage("يجب اختيار صورة للقسم");
      return;
    }

    setState(() => saving = true);

    try {
      // Compress image
      final compressed = await compressImage(selectedImage!);

      // Upload image
      final ref = FirebaseStorage.instance
          .ref("categories/${DateTime.now().millisecondsSinceEpoch}.jpg");

      await ref.putFile(compressed);
      final imageUrl = await ref.getDownloadURL();

      // Save Firestore category
      await FirebaseFirestore.instance.collection("categories").add({
        "name_ar": nameArCtrl.text.trim(),
        "name_en": nameEnCtrl.text.trim(),
        "image_url": imageUrl,
        "created_at": FieldValue.serverTimestamp(),
        "keywords": [
          nameArCtrl.text.trim(),
          nameEnCtrl.text.trim().toLowerCase(),
        ],
      });

      showMessage("تم إضافة القسم بنجاح");
      Navigator.pop(context);

    } catch (e) {
      showMessage("خطأ أثناء الحفظ: $e");
    }

    setState(() => saving = false);
  }

  /* -----------------------------------------------------------
  |                          UI
  ------------------------------------------------------------ */

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة قسم جديد"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name AR
                    TextFormField(
                      controller: nameArCtrl,
                      decoration: const InputDecoration(
                        labelText: "اسم القسم (عربي)",
                      ),
                      validator: (v) => v!.isEmpty ? "الحقل مطلوب" : null,
                    ),
                    const SizedBox(height: 16),

                    // Name EN
                    TextFormField(
                      controller: nameEnCtrl,
                      decoration: const InputDecoration(
                        labelText: "اسم القسم (English)",
                      ),
                      validator: (v) => v!.isEmpty ? "الحقل مطلوب" : null,
                    ),
                    const SizedBox(height: 16),

                    // Image Picker
                    GestureDetector(
                      onTap: () async {
                        final img = await pickImage();
                        if (img != null) {
                          setState(() {
                            selectedImage = img;
                          });
                        }
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey.shade200,
                        ),
                        child: selectedImage == null
                            ? const Center(
                                child: Text(
                                  "اضغط لاختيار صورة",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Save Button
                    ElevatedButton(
                      onPressed: saveCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "إضافة القسم",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
