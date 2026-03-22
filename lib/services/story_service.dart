import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/child_profile_model.dart';
import '../models/story_model.dart';

final storyServiceProvider = Provider<StoryService>((ref) => StoryService());

class StoryService {
  final _uuid = const Uuid();

  Future<List<StoryModel>> generateStoryOptions({
    required ChildProfileModel child,
    required String storyType,
    required String mood,
    required List<String> previousTitles,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return _getMockStories(child.name, storyType, mood, child.language)
        .map((t) => StoryModel(
              id: _uuid.v4(),
              childId: child.id,
              parentId: uid,
              title: t['title']!,
              preview: t['preview']!,
              content: t['content']!,
              language: child.language,
              storyType: storyType,
              mood: mood,
              createdAt: DateTime.now(),
            ))
        .toList();
  }

  List<Map<String, String>> _getMockStories(String name, String type, String mood, String lang) {
    if (lang == 'Hindi') {
      return [
        {'title': '$name और जादुई तारा', 'preview': 'एक रात $name को आसमान में एक चमकता हुआ तारा दिखा...', 'content': 'एक रात $name को आसमान में एक चमकता हुआ तारा दिखा। वो तारा धीरे-धीरे नीचे आया और बोला, "$name, क्या तुम मेरे दोस्त बनोगे?" $name ने खुशी से हाँ कहा। उस रात दोनों ने साथ मिलकर आसमान में उड़ान भरी। सुबह $name के हाथ में एक छोटा चमकता पत्थर था। शुभ रात्रि! 🌟'},
        {'title': '$name का साहसी सफर', 'preview': '$name एक छोटे से गाँव में रहता था...', 'content': '$name एक छोटे से गाँव में रहता था जहाँ एक रहस्यमय जंगल था। एक दिन दादी की किताब में एक नक्शा मिला। $name ने हिम्मत करके जंगल में कदम रखा। रास्ते में दोस्तों ने मदद की और एक अद्भुत फलों का पेड़ मिला। असली खजाना था दूसरों की मदद करना। शुभ रात्रि! 🌙'},
        {'title': '$name और बोलने वाली मछली', 'preview': 'नदी के किनारे $name को एक सुनहरी मछली मिली...', 'content': 'नदी के किनारे $name को एक सुनहरी मछली मिली जो बोल सकती थी। दोनों ने मिलकर एक पहेली सुलझाई और नदी फिर साफ हो गई। मछली ने $name को वरदान दिया — हर रात सुंदर सपने। शुभ रात्रि! 🐟'},
      ];
    }
    return [
      {'title': 'The Magical Star and $name', 'preview': 'One night, $name spotted a glowing star falling from the sky...', 'content': 'One quiet night, $name looked up and saw a tiny star falling. It landed softly in the garden. "Hello $name," the star whispered. "I got lost. Will you help me?" Together they climbed the tallest hill and the star leapt back into the sky. "Thank you $name!" That night, $name fell asleep smiling. Goodnight! 🌟'},
      {'title': '$name and the Brave Little Turtle', 'preview': 'Deep in the forest lived a tiny turtle who was afraid of everything...', 'content': 'Deep in the forest lived a tiny turtle named Timmy who was afraid of everything. One day $name visited and they went on a small adventure together. By the end, Timmy had crossed a stream, climbed a rock and made three friends. Courage grows when you walk beside a friend. Goodnight! 🐢'},
      {'title': "$name's Dream Garden", 'preview': '$name discovered a magical seed that could grow anything...', 'content': 'One morning $name found a tiny golden seed. The wise owl said "This seed grows whatever is in your heart." $name planted it with love and overnight a beautiful garden bloomed. All the children came to play. The most beautiful things come from a kind heart. Goodnight! 🌸'},
    ];
  }
}
