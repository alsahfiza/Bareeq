import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class AdminAddProductsPage extends StatefulWidget {
  const AdminAddProductsPage({super.key});

  @override
  State<AdminAddProductsPage> createState() => _AdminAddProductsPageState();
}

class _AdminAddProductsPageState extends State<AdminAddProductsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameArCtrl = TextEditingController();
  final nameEnCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String? selectedCategory;
  String? imageUrl;

  bool loading = false;
  File? imageFile;

  @override
  void dispose() {
    nameArCtrl.dispose();
    nameEnCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  /* -----------------------------------------------------------
  |                    IMAGE PICKING + COMPRESSION
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
  |               FIREBASE STORAGE UPLOAD
  ------------------------------------------------------------ */

  Future<String> uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref("products/${DateTime.now().millisecondsSinceEpoch}.jpg");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /* -----------------------------------------------------------
  |                     SAVE PRODUCT
  ------------------------------------------------------------ */

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      showMessage("اختر القسم");
      return;
    }

    if (imageFile == null) {
      showMessage("اختر صورة للمنتج");
      return;
    }

    setState(() => loading = true);

    try {
      // Compress then upload
      final compressed = await compressImage(imageFile!);
      final imageURL = await uploadImage(compressed);

      await FirebaseFirestore.instance.collection("products").add({
        "name_ar": nameArCtrl.text.trim(),
        "name_en": nameEnCtrl.text.trim(),
        "price": double.parse(priceCtrl.text.trim()),
        "description": descCtrl.text.trim(),
        "category_id": selectedCategory,
        "image_url": imageURL,
        "created_at": FieldValue.serverTimestamp(),
      });

      showMessage("تم إضافة المنتج بنجاح");
      Navigator.pop(context);

    } catch (e) {
      showMessage("خطأ: $e");
    }

    setState(() => loading = false);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /* -----------------------------------------------------------
  |                     CATEGORY DROPDOWN
  ------------------------------------------------------------ */

  Future<List<QueryDocumentSnapshot>> fetchCategories() async {
    var snap = await FirebaseFirestore.instance.collection("categories").get();
    return snap.docs;
  }

  /* -----------------------------------------------------------
  |                     PAGE UI
  ------------------------------------------------------------ */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة منتج"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchCategories(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = snap.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // NAME AR
                        TextFormField(
                          controller: nameArCtrl,
                          decoration: const InputDecoration(
                            labelText: "اسم المنتج (عربي)",
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "الحقل مطلوب" : null,
                        ),
                        const SizedBox(height: 16),

                        // NAME EN
                        TextFormField(
                          controller: nameEnCtrl,
                          decoration: const InputDecoration(
                            labelText: "اسم المنتج (English)",
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "الحقل مطلوب" : null,
                        ),
                        const SizedBox(height: 16),

                        // PRICE
                        TextFormField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "السعر",
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "أدخل السعر" : null,
                        ),
                        const SizedBox(height: 16),

                        // DESCRIPTION
                        TextFormField(
                          controller: descCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "الوصف",
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CATEGORY DROPDOWN
                        DropdownButtonFormField(
                          value: selectedCategory,
                          decoration: const InputDecoration(labelText: "القسم"),
                          items: categories
                              .map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c["name_ar"]),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() {
                            selectedCategory = val;
                          }),
                        ),
                        const SizedBox(height: 16),

                        // IMAGE UPLOADER
                        GestureDetector(
                          onTap: () async {
                            final picked = await pickImage();
                            if (picked != null) {
                              setState(() => imageFile = picked);
                            }
                          },
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: imageFile == null
                                ? const Center(
                                    child: Text("اختر صورة"),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // SAVE BUTTON
                        ElevatedButton(
                          onPressed: saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("حفظ المنتج",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
