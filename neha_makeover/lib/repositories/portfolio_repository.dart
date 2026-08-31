import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio_item.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PortfolioItem>> getPortfolioItems() {
    return _firestore
        .collection('portfolio')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PortfolioItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
