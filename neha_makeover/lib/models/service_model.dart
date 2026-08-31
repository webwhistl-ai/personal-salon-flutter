class ServiceModel {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final int durationMinutes;
  final String shortDescription;
  final String detailedDescription;
  final String suitabilityTag;
  final String imageUrl;
  final bool isPopular;
  final bool isVisible;

  ServiceModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.durationMinutes,
    required this.shortDescription,
    required this.detailedDescription,
    required this.suitabilityTag,
    required this.imageUrl,
    this.isPopular = false,
    this.isVisible = true,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      name: map['name'] ?? '',
      categoryId: map['categoryId'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      durationMinutes: map['durationMinutes'] ?? 0,
      shortDescription: map['shortDescription'] ?? '',
      detailedDescription: map['detailedDescription'] ?? '',
      suitabilityTag: map['suitabilityTag'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isPopular: map['isPopular'] ?? false,
      isVisible: map['isVisible'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'durationMinutes': durationMinutes,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'suitabilityTag': suitabilityTag,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'isVisible': isVisible,
    };
  }
}
