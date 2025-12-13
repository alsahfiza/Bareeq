import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  static final _picker = ImagePicker();

  /// Pick image from device
  static Future<Uint8List?> pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    return await file.readAsBytes();
  }

  /// Upload image to Firebase Storage
  static Future<String> uploadImage(Uint8List bytes) async {
    String fileName = "prod_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance.ref().child("products/$fileName");

    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

  /// Delete old image
  static Future<void> deleteImageByUrl(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // ignore errors
    }
  }
}
