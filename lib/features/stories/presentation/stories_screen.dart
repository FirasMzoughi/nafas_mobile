import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';
import 'package:nafas/features/stories/data/mock_story_repository.dart';
import 'package:nafas/features/stories/presentation/widgets/create_story_modal.dart';
import 'package:nafas/features/stories/presentation/widgets/story_card.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Container(
        decoration: isDarkMode 
            ? AppTheme.backgroundGradient 
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Wall',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share your story. You are not alone.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              storiesAsync.when(
                data: (stories) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final story = stories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: StoryCard(
                          story: story,
                          isDarkMode: isDarkMode,
                        )
                            .animate()
                            .fadeIn(delay: (100 * index).ms)
                            .slideY(begin: 0.1, end: 0),
                      );
                    },
                    childCount: stories.length,
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreateStoryModal(isDarkMode: isDarkMode),
          );
        },
        backgroundColor: AppTheme.sageGreen,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Write Story', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
