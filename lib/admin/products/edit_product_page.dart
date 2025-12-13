import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final nameAr = TextEditingController();
  final price = TextEditingController();
  final description = TextEditingController();

  bool loading = true;

  List<String> existingImages = [];       // URLs already stored
  List<File> newImages = [];              // new uploads (mobile)
  List<Uint8List> newImagesWeb = [];      // new uploads (web)
  List<String> removedImages = [];        // images removed to delete from storage

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    final doc = await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .get();

    final data = doc.data()!;
    nameAr.text = data["name_ar"];
    price.text = data["price"].toString();
    description.text = data["description"] ?? "";

    existingImages = List<String>.from(data["images"] ?? []);

    setState(() => loading = false);
  }

  Future<void> pickNewImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    setState(() {
      if (kIsWeb) {
        newImagesWeb.addAll(result.files.map((f) => f.bytes!).toList());
      } else {
        newImages.addAll(result.files.map((f) => File(f.path!)).toList());
      }
    });
  }

  Future<File> compress(File file) async {
    // Convert the File to ImageFile
    final input = ImageFile(
      rawBytes: await file.readAsBytes(),
      filePath: file.path,
    );

    // Compression configuration
    final config = const Configuration(
      quality: 40,
      outputType: ImageOutputType.jpg,
      useJpgPngNativeCompressor: true,
    );

    // Prepare compressor params
    final param = ImageFileConfiguration(input: input, config: config);

    // Compress
    final outputImage = await compressor.compress(param);

    // Save new file
    final outFile = File("${file.path}_compressed.jpg");
    await outFile.writeAsBytes(outputImage.rawBytes);

    return outFile;
  }

  Future<List<String>> uploadNewImages() async {
    List<String> urls = [];

    if (kIsWeb) {
      int index = 0;
      for (final img in newImagesWeb) {
        final ref = FirebaseStorage.instance
            .ref("products/${widget.productId}/new_$index.jpg");

        await ref.putData(img, SettableMetadata(contentType: "image/jpeg"));

        urls.add(await ref.getDownloadURL());
        index++;
      }
    } else {
      int index = 0;
      for (final file in newImages) {
        final ref = FirebaseStorage.instance
            .ref("products/${widget.productId}/new_$index.jpg");

        final compressed = await compress(file);

        await ref.putFile(compressed);
        urls.add(await ref.getDownloadURL());

        index++;
      }
    }

    return urls;
  }

  Future<void> deleteRemovedImages() async {
    for (final url in removedImages) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      } catch (_) {}
    }
  }

  Future<void> saveChanges() async {
    if (nameAr.text.isEmpty || price.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الاسم والسعر مطلوبان")),
      );
      return;
    }

    setState(() => loading = true);

    // DELETE REMOVED IMAGES
    await deleteRemovedImages();

    // UPLOAD NEW IMAGES
    final uploaded = await uploadNewImages();

    // FINAL LIST OF IMAGES
    final finalImages = [
      ...existingImages,
      ...uploaded,
    ];

    // UPDATE FIRESTORE
    await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .update({
      "name_ar": nameAr.text.trim(),
      "price": double.parse(price.text.trim()),
      "description": description.text.trim(),
      "images": finalImages,
      "updated_at": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم تحديث المنتج بنجاح ✔")),
    );

    Navigator.pop(context);
  }

  void removeExistingImage(String url) {
    setState(() {
      existingImages.remove(url);
      removedImages.add(url);
    });
  }

  void removeNewImage(int index) {
    setState(() {
      if (kIsWeb) {
        newImagesWeb.removeAt(index);
      } else {
        newImages.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("تعديل المنتج"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ----- EXISTING IMAGES -----
            const Text(
              "الصور الحالية",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: existingImages.map((url) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () => removeExistingImage(url),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    )
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// ----- NEW IMAGES PREVIEW -----
            const Text(
              "صور جديدة",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (kIsWeb)
                  ...List.generate(newImagesWeb.length, (i) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            newImagesWeb[i],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => removeNewImage(i),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        )
                      ],
                    );
                  })
                else
                  ...List.generate(newImages.length, (i) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            newImages[i],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => removeNewImage(i),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: pickNewImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text("إضافة صور جديدة"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            /// TEXT FIELDS
            TextField(
              controller: nameAr,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "اسم المنتج",
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "السعر",
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: description,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "الوصف",
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("حفظ التغييرات"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
