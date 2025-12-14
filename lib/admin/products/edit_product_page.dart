import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  final nameArCtrl = TextEditingController();
  final nameEnCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String? selectedCategory;
  String? imageUrl; // current image
  File? newImageFile; // new selected image

  bool loading = true;
  bool updating = false;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  @override
  void dispose() {
    nameArCtrl.dispose();
    nameEnCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  /* -----------------------------------------------------------
  |                   LOAD PRODUCT DETAILS
  ------------------------------------------------------------ */

  Future<void> loadProduct() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.productId)
          .get();

      if (!doc.exists) {
        showMessage("المنتج غير موجود");
        Navigator.pop(context);
        return;
      }

      var data = doc.data()!;

      nameArCtrl.text = data["name_ar"];
      nameEnCtrl.text = data["name_en"];
      priceCtrl.text = data["price"].toString();
      descCtrl.text = data["description"] ?? "";
      selectedCategory = data["category_id"];
      imageUrl = data["image_url"];

      setState(() => loading = false);
    } catch (e) {
      showMessage("خطأ في تحميل البيانات: $e");
      Navigator.pop(context);
    }
  }

  /* -----------------------------------------------------------
  |                   IMAGE PICK + COMPRESS
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
  |                   UPDATE PRODUCT
  ------------------------------------------------------------ */

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => updating = true);

    try {
      String finalImageUrl = imageUrl!;

      // If user selected a new image:
      if (newImageFile != null) {
        final compressed = await compressImage(newImageFile!);

        // Upload new
        final ref = FirebaseStorage.instance
            .ref("products/${DateTime.now().millisecondsSinceEpoch}.jpg");

        await ref.putFile(compressed);
        finalImageUrl = await ref.getDownloadURL();

        // Delete old one
        try {
          await FirebaseStorage.instance.refFromURL(imageUrl!).delete();
        } catch (_) {
          // ignore if image doesn't exist
        }
      }

      await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.productId)
          .update({
        "name_ar": nameArCtrl.text.trim(),
        "name_en": nameEnCtrl.text.trim(),
        "price": double.tryParse(priceCtrl.text.trim()) ?? 0,
        "description": descCtrl.text.trim(),
        "category_id": selectedCategory,
        "image_url": finalImageUrl,
        "updated_at": FieldValue.serverTimestamp(),
      });

      showMessage("تم تحديث المنتج بنجاح");
      Navigator.pop(context);

    } catch (e) {
      showMessage("خطأ: $e");
    }

    setState(() => updating = false);
  }

  /* -----------------------------------------------------------
  |                   LOAD CATEGORIES
  ------------------------------------------------------------ */

  Future<List<QueryDocumentSnapshot>> fetchCategories() async {
    var snap =
        await FirebaseFirestore.instance.collection("categories").get();
    return snap.docs;
  }

  /* -----------------------------------------------------------
  |                   UI
  ------------------------------------------------------------ */

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("تعديل المنتج")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل المنتج"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: updating
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
                      children: [
                        // NAME AR
                        TextFormField(
                          controller: nameArCtrl,
                          decoration:
                              const InputDecoration(labelText: "اسم المنتج (عربي)"),
                          validator: (v) =>
                              v!.isEmpty ? "الحقل مطلوب" : null,
                        ),
                        const SizedBox(height: 16),

                        // NAME EN
                        TextFormField(
                          controller: nameEnCtrl,
                          decoration:
                              const InputDecoration(labelText: "اسم المنتج (English)"),
                          validator: (v) =>
                              v!.isEmpty ? "الحقل مطلوب" : null,
                        ),
                        const SizedBox(height: 16),

                        // PRICE
                        TextFormField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "السعر"),
                          validator: (v) =>
                              v!.isEmpty ? "أدخل السعر" : null,
                        ),
                        const SizedBox(height: 16),

                        // DESCRIPTION
                        TextFormField(
                          controller: descCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(labelText: "الوصف"),
                        ),
                        const SizedBox(height: 16),

                        // CATEGORY DROPDOWN
                        DropdownButtonFormField(
                          value: selectedCategory,
                          decoration:
                              const InputDecoration(labelText: "القسم"),
                          items: categories
                              .map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c["name_ar"]),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedCategory = val),
                        ),
                        const SizedBox(height: 16),

                        // IMAGE SELECTOR
                        GestureDetector(
                          onTap: () async {
                            final picked = await pickImage();
                            if (picked != null) {
                              setState(() {
                                newImageFile = picked;
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
                            child: newImageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      newImageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        ElevatedButton(
                          onPressed: updateProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("تحديث المنتج",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
