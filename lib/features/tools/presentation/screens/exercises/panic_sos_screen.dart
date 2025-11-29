import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';

class PanicSOSScreen extends ConsumerWidget {
  const PanicSOSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panic SOS'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: isDarkMode
            ? AppTheme.backgroundGradient
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You\'re Safe',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This feeling will pass. Let\'s ground you right now.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                ),
                const SizedBox(height: 40),
                _buildTechnique(
                  context,
                  isDarkMode,
                  '5-4-3-2-1 Grounding',
                  'Name 5 things you see, 4 you can touch, 3 you hear, 2 you smell, 1 you taste',
                  Icons.visibility,
                ),
                const SizedBox(height: 16),
                _buildTechnique(
                  context,
                  isDarkMode,
                  'Deep Breathing',
                  'Breathe in for 4, hold for 4, out for 6. Repeat 5 times.',
                  Icons.air,
                ),
                const SizedBox(height: 16),
                _buildTechnique(
                  context,
                  isDarkMode,
                  'Cold Water',
                  'Splash cold water on your face or hold ice cubes',
                  Icons.water_drop,
                ),
                const SizedBox(height: 16),
                _buildTechnique(
                  context,
                  isDarkMode,
                  'Move Your Body',
                  'Do 10 jumping jacks or shake out your limbs',
                  Icons.directions_run,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'If you\'re in crisis, please call emergency services or a crisis hotline',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechnique(
    BuildContext context,
    bool isDarkMode,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen)
                  .withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
