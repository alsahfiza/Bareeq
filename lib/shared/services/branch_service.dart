import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/branch_model.dart';

class BranchService {
  final _ref = FirebaseFirestore.instance.collection('branches');

  Stream<List<BranchModel>> getBranches({bool activeOnly = true}) {
    Query q = _ref;
    if (activeOnly) {
      q = q.where('isActive', isEqualTo: true);
    }

    return q.snapshots().map((s) =>
        s.docs.map((d) => BranchModel.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> addBranch(BranchModel branch) async {
    await _ref.add(branch.toMap());
  }
}
