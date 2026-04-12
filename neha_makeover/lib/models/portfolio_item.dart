import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioItem {
  final String id;
  final String title;
  final String imageUrl;
  final String? beforeImageUrl; // For before/after slider
  final List<String> tags; // e.g., 'bridal', 'hair', 'makeup'
  final String? serviceId;
  final String description;
  final DateTime createdAt;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.beforeImageUrl,
    required this.tags,
    this.serviceId,
    required this.description,
    required this.createdAt,
  });

  factory PortfolioItem.fromMap(Map<String, dynamic> map, String id) {
    return PortfolioItem(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      beforeImageUrl: map['beforeImageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      serviceId: map['serviceId'],
      description: map['description'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'beforeImageUrl': beforeImageUrl,
      'tags': tags,
      'serviceId': serviceId,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
