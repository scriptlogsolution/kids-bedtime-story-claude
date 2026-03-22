class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isPremium;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isPremium = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] ?? '',
        email: map['email'] ?? '',
        displayName: map['displayName'],
        photoUrl: map['photoUrl'],
        isPremium: map['isPremium'] ?? false,
        createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'isPremium': isPremium,
        'createdAt': createdAt.toIso8601String(),
      };
}
