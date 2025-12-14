import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class EditCategoryPage extends StatefulWidget {
  final String categoryId;

  const EditCategoryPage({super.key, required this.categoryId});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  final nameArCtrl = TextEditingController();
  final nameEnCtrl = TextEditingController();

  String? existingImageUrl;
  File? selectedImage;

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadCategory();
  }

  @override
  void dispose() {
    nameArCtrl.dispose();
    nameEnCtrl.dispose();
    super.dispose();
  }

  /* -----------------------------------------------------------
  |                         LOAD DATA
  ------------------------------------------------------------ */

  Future<void> loadCategory() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .get();

      if (!doc.exists) {
        showMessage("القسم غير موجود");
        Navigator.pop(context);
        return;
      }

      final data = doc.data()!;
      nameArCtrl.text = data["name_ar"];
      nameEnCtrl.text = data["name_en"];
      existingImageUrl = data["image_url"];

    } catch (e) {
      showMessage("خطأ أثناء تحميل البيانات: $e");
    }

    setState(() => loading = false);
  }

  /* -----------------------------------------------------------
  |                  IMAGE PICK + COMPRESS
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
      ImageFileConfiguration(
        input: input,
        config: config,
      ),
    );

    final out = File("${file.path}_compressed.jpg");
    return await out.writeAsBytes(output.rawBytes);
  }

  /* -----------------------------------------------------------
  |                    UPDATE CATEGORY
  ------------------------------------------------------------ */

  Future<void> updateCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    String finalImageUrl = existingImageUrl ?? "";

    try {
      /* ---------- If new image selected: upload it ---------- */
      if (selectedImage != null) {
        // Compress
        final compressed = await compressImage(selectedImage!);

        // Upload
        final ref = FirebaseStorage.instance.ref(
          "categories/${DateTime.now().millisecondsSinceEpoch}.jpg",
        );

        await ref.putFile(compressed);
        finalImageUrl = await ref.getDownloadURL();

        // Delete old image only if exists
        if (existingImageUrl != null) {
          try {
            await FirebaseStorage.instance
                .refFromURL(existingImageUrl!)
                .delete();
          } catch (_) {}
        }
      }

      /* ---------- Update Firestore ---------- */
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .update({
        "name_ar": nameArCtrl.text.trim(),
        "name_en": nameEnCtrl.text.trim(),
        "image_url": finalImageUrl,
        "keywords": [
          nameArCtrl.text.trim(),
          nameEnCtrl.text.trim().toLowerCase(),
        ],
      });

      showMessage("تم تحديث القسم بنجاح");
      Navigator.pop(context);

    } catch (e) {
      showMessage("خطأ أثناء تحديث القسم: $e");
    }

    setState(() => saving = false);
  }

  /* -----------------------------------------------------------
  |                           UI
  ------------------------------------------------------------ */

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
        title: const Text("تعديل القسم"),
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
                    const SizedBox(height: 20),

                    // Image Picker / Preview
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
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey.shade200,
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : existingImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      existingImageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      "اضغط لتغيير الصورة",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // SAVE
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: updateCategory,
                      child: const Text(
                        "حفظ التعديلات",
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
