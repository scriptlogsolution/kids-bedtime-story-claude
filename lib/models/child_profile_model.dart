class ChildProfileModel {
  final String id;
  final String parentId;
  final String name;
  final int age;
  final String language;
  final List<String> interests;

  const ChildProfileModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    required this.language,
    required this.interests,
  });

  factory ChildProfileModel.fromMap(Map<String, dynamic> map) => ChildProfileModel(
        id: map['id'] ?? '',
        parentId: map['parentId'] ?? '',
        name: map['name'] ?? '',
        age: map['age'] ?? 5,
        language: map['language'] ?? 'English',
        interests: List<String>.from(map['interests'] ?? []),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'parentId': parentId,
        'name': name,
        'age': age,
        'language': language,
        'interests': interests,
      };

  ChildProfileModel copyWith({String? name, int? age, String? language, List<String>? interests}) =>
      ChildProfileModel(
        id: id,
        parentId: parentId,
        name: name ?? this.name,
        age: age ?? this.age,
        language: language ?? this.language,
        interests: interests ?? this.interests,
      );
}
