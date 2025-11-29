import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';
import 'package:nafas/features/tools/presentation/widgets/tool_card.dart';
import 'package:nafas/features/tools/presentation/screens/exercises/box_breathing_screen.dart';
import 'package:nafas/features/tools/presentation/screens/exercises/panic_sos_screen.dart';

class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    final tools = [
      {
        'title': 'Box Breathing',
        'description': 'Regulate your autonomic nervous system.',
        'icon': Icons.crop_square,
        'duration': '4 min',
      },
      {
        'title': '4-7-8 Breathing',
        'description': 'Reduce anxiety and get to sleep.',
        'icon': Icons.nightlight_round,
        'duration': '5 min',
      },
      {
        'title': 'Body Scan',
        'description': 'Release tension from head to toe.',
        'icon': Icons.accessibility_new,
        'duration': '10 min',
      },
      {
        'title': 'Sleep Sounds',
        'description': 'Drift off with calming nature sounds.',
        'icon': Icons.music_note,
        'duration': '∞',
      },
      {
        'title': 'Panic SOS',
        'description': 'Immediate relief for high stress.',
        'icon': Icons.warning_amber_rounded,
        'duration': '2 min',
      },
      {
        'title': 'Focus Timer',
        'description': 'Stay productive with intervals.',
        'icon': Icons.timer,
        'duration': '25 min',
      },
    ];

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
                        'Recovery Studio',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tools to restore your balance',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                      ),
                      const SizedBox(height: 24),
                      // Stats Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.darkGreen,
                              AppTheme.sageGreen.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.sageGreen.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Minutes Recovered',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '128',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '+12% this week',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 8,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.bar_chart,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 32),
                      Text(
                        'All Tools',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tool = tools[index];
                      return ToolCard(
                        title: tool['title'] as String,
                        description: tool['description'] as String,
                        icon: tool['icon'] as IconData,
                        duration: tool['duration'] as String,
                        onTap: () {
                          _navigateToTool(context, tool['title'] as String);
                        },
                        isDarkMode: isDarkMode,
                      ).animate().fadeIn(delay: (300 + index * 100).ms).scale();
                    },
                    childCount: tools.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTool(BuildContext context, String toolName) {
    Widget? screen;
    
    switch (toolName) {
      case 'Box Breathing':
        screen = const BoxBreathingScreen();
        break;
      case 'Panic SOS':
        screen = const PanicSOSScreen();
        break;
      default:
        // Show coming soon dialog for other tools
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Coming Soon'),
            content: Text('$toolName will be available soon!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen!),
    );
  }
}
