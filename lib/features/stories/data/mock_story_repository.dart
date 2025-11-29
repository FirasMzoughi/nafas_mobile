import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/features/stories/domain/story.dart';
import 'package:uuid/uuid.dart';

class MockStoryRepository {
  final List<Story> _stories = [
    Story(
      id: '1',
      content: 'Today I finally managed to leave the house without feeling overwhelmed. It\'s a small step, but it means everything to me.',
      authorPseudonym: 'SilentWalker',
      authorMask: 'Calm',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      likesCount: 24,
      commentsCount: 5,
      isTriggerWarning: false,
      tags: ['Anxiety', 'SmallWins'],
    ),
    Story(
      id: '2',
      content: 'The nights are the hardest. I keep thinking about what I could have done differently. But I know I need to forgive myself.',
      authorPseudonym: 'NightOwl',
      authorMask: 'Mystery',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 156,
      commentsCount: 32,
      isTriggerWarning: true,
      tags: ['Regret', 'Forgiveness'],
    ),
    Story(
      id: '3',
      content: 'Just wanted to say thank you to everyone in the "Anxiety Support" room yesterday. Your words really helped me ground myself.',
      authorPseudonym: 'HopefulHeart',
      authorMask: 'Hope',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 89,
      commentsCount: 12,
      isTriggerWarning: false,
      tags: ['Gratitude', 'Community'],
    ),
    Story(
      id: '4',
      content: 'Recovery isn\'t linear. I relapsed today, but I\'m not giving up. Tomorrow is day 1 again.',
      authorPseudonym: 'Phoenix',
      authorMask: 'Spirit',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 342,
      commentsCount: 85,
      isTriggerWarning: true,
      tags: ['Relapse', 'Resilience'],
    ),
  ];

  Future<List<Story>> getStories() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _stories;
  }

  Future<void> addStory(String content, String pseudonym, String mask, bool isTriggerWarning) async {
    await Future.delayed(const Duration(seconds: 1));
    final newStory = Story(
      id: const Uuid().v4(),
      content: content,
      authorPseudonym: pseudonym,
      authorMask: mask,
      createdAt: DateTime.now(),
      likesCount: 0,
      commentsCount: 0,
      isTriggerWarning: isTriggerWarning,
      tags: ['New'],
    );
    _stories.insert(0, newStory);
  }
}

final storyRepositoryProvider = Provider<MockStoryRepository>((ref) {
  return MockStoryRepository();
});

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  final repo = ref.read(storyRepositoryProvider);
  return repo.getStories();
});
