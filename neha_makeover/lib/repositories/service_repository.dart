import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';
import '../models/service_category.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ServiceCategory>> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceCategory.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<ServiceModel>> getServices() {
    return _firestore
        .collection('services')
        .where('isVisible', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
