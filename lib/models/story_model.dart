class StoryModel {
  final String id;
  final String childId;
  final String parentId;
  final String title;
  final String preview;
  final String content;
  final String language;
  final String storyType;
  final String mood;
  final bool isFavorite;
  final DateTime createdAt;

  const StoryModel({
    required this.id,
    required this.childId,
    required this.parentId,
    required this.title,
    required this.preview,
    required this.content,
    required this.language,
    required this.storyType,
    required this.mood,
    this.isFavorite = false,
    required this.createdAt,
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) => StoryModel(
        id: map['id'] ?? '',
        childId: map['childId'] ?? '',
        parentId: map['parentId'] ?? '',
        title: map['title'] ?? '',
        preview: map['preview'] ?? '',
        content: map['content'] ?? '',
        language: map['language'] ?? 'English',
        storyType: map['storyType'] ?? 'Adventure',
        mood: map['mood'] ?? 'calm',
        isFavorite: map['isFavorite'] ?? false,
        createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'childId': childId,
        'parentId': parentId,
        'title': title,
        'preview': preview,
        'content': content,
        'language': language,
        'storyType': storyType,
        'mood': mood,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
      };

  StoryModel copyWith({bool? isFavorite}) => StoryModel(
        id: id, childId: childId, parentId: parentId, title: title,
        preview: preview, content: content, language: language,
        storyType: storyType, mood: mood,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt,
      );
}
