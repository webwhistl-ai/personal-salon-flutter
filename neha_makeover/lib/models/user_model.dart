class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String photoUrl;
  final String role; // 'customer', 'owner', 'manager', 'receptionist', 'artist'
  final String? phoneNumber;
  final List<String> favoriteServices;
  final List<String> savedPortfolioItems;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl = '',
    this.role = 'customer',
    this.phoneNumber,
    this.favoriteServices = const [],
    this.savedPortfolioItems = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      role: map['role'] ?? 'customer',
      phoneNumber: map['phoneNumber'],
      favoriteServices: List<String>.from(map['favoriteServices'] ?? []),
      savedPortfolioItems: List<String>.from(map['savedPortfolioItems'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'phoneNumber': phoneNumber,
      'favoriteServices': favoriteServices,
      'savedPortfolioItems': savedPortfolioItems,
    };
  }
}
