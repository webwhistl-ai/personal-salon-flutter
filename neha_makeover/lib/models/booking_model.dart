import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String customerId;
  final List<String> serviceIds;
  final DateTime dateTime;
  final int totalDurationMinutes;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? notes;
  final String? inspirationPhotoUrl;
  final String? artistId;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.serviceIds,
    required this.dateTime,
    required this.totalDurationMinutes,
    required this.totalPrice,
    this.status = 'pending',
    this.notes,
    this.inspirationPhotoUrl,
    this.artistId,
    required this.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      customerId: map['customerId'] ?? '',
      serviceIds: List<String>.from(map['serviceIds'] ?? []),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      totalDurationMinutes: map['totalDurationMinutes'] ?? 0,
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      inspirationPhotoUrl: map['inspirationPhotoUrl'],
      artistId: map['artistId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'serviceIds': serviceIds,
      'dateTime': Timestamp.fromDate(dateTime),
      'totalDurationMinutes': totalDurationMinutes,
      'totalPrice': totalPrice,
      'status': status,
      'notes': notes,
      'inspirationPhotoUrl': inspirationPhotoUrl,
      'artistId': artistId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
