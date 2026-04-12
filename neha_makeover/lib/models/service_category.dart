class ServiceCategory {
  final String id;
  final String name;
  final String imageUrl;
  final int sortOrder;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.sortOrder = 0,
  });

  factory ServiceCategory.fromMap(Map<String, dynamic> map, String id) {
    return ServiceCategory(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sortOrder: map['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'sortOrder': sortOrder,
    };
  }
}
