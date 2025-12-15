import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';

class BannerService {
  final _ref = FirebaseFirestore.instance.collection('banners');

  Stream<List<BannerModel>> getActiveBanners() {
    return _ref
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((s) => s.docs
            .map((d) => BannerModel.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<List<BannerModel>> getAllBanners() {
    return _ref.orderBy('order').snapshots().map((s) =>
        s.docs.map((d) => BannerModel.fromMap(d.id, d.data())).toList());
  }

  Future<void> addBanner(BannerModel banner) async {
    await _ref.add(banner.toMap());
  }

  Future<void> deleteBanner(String id) async {
    await _ref.doc(id).delete();
  }
}
