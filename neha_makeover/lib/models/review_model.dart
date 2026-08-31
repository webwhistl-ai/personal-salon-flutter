import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String customerId;
  final String customerName;
  final double rating;
  final String text;
  final String? serviceId;
  final DateTime createdAt;
  final bool isFeatured;

  ReviewModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.rating,
    required this.text,
    this.serviceId,
    required this.createdAt,
    this.isFeatured = false,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      text: map['text'] ?? '',
      serviceId: map['serviceId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'rating': rating,
      'text': text,
      'serviceId': serviceId,
      'createdAt': Timestamp.fromDate(createdAt),
      'isFeatured': isFeatured,
    };
  }
}
