import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Total Anonymity',
      description: 'Express yourself freely without fear of judgment. Your identity is always protected.',
      icon: Icons.visibility_off_outlined,
    ),
    OnboardingData(
      title: 'Voice Recovery Rooms',
      description: 'Join safe spaces to listen or share. Healing happens when we speak and are heard.',
      icon: Icons.record_voice_over_outlined,
    ),
    OnboardingData(
      title: 'Community Stories',
      description: 'Read and share stories of resilience. You are not alone in your journey.',
      icon: Icons.auto_stories_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Container(
        decoration: isDarkMode 
            ? AppTheme.backgroundGradient 
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length + 1, // +1 for theme selection page
                  itemBuilder: (context, index) {
                    if (index < _pages.length) {
                      return OnboardingPage(
                        data: _pages[index],
                        isDarkMode: isDarkMode,
                      );
                    } else {
                      // Theme selection page
                      return ThemeSelectionPage(
                        onThemeSelected: (bool isDark) {
                          ref.read(themeModeProvider.notifier).setDarkMode(isDark);
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dot Indicators
                    Row(
                      children: List.generate(
                        _pages.length + 1,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.sageGreen
                                : (isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Next/Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/auth');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text(
                        _currentPage == _pages.length ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final bool isDarkMode;

  const OnboardingPage({
    super.key, 
    required this.data,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 80,
              color: isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.easeOutBack)
              .fadeIn(duration: 600.ms),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class ThemeSelectionPage extends ConsumerStatefulWidget {
  final Function(bool) onThemeSelected;

  const ThemeSelectionPage({
    super.key,
    required this.onThemeSelected,
  });

  @override
  ConsumerState<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends ConsumerState<ThemeSelectionPage> {
  bool? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeModeProvider);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose Your Theme',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: currentTheme ? Colors.white : AppTheme.darkGreen,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            'Select the theme that feels right for you',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: currentTheme ? Colors.white70 : Colors.black54,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  title: 'Dark Mode',
                  subtitle: 'Deep greens',
                  isDark: true,
                  isSelected: _selectedTheme == true,
                  onTap: () {
                    setState(() => _selectedTheme = true);
                    widget.onThemeSelected(true);
                  },
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ThemeOption(
                  title: 'Light Mode',
                  subtitle: 'Bright mint',
                  isDark: false,
                  isSelected: _selectedTheme == false,
                  onTap: () {
                    setState(() => _selectedTheme = false);
                    widget.onThemeSelected(false);
                  },
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppTheme.darkGreen, AppTheme.sageGreen.withOpacity(0.8)]
                : [AppTheme.lightMint, AppTheme.mintGreen.withOpacity(0.3)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppTheme.sageGreen : AppTheme.mintGreen)
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? AppTheme.sageGreen : AppTheme.mintGreen).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              size: 48,
              color: isDark ? Colors.white : AppTheme.darkGreen,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.darkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 12),
              Icon(
                Icons.check_circle,
                color: isDark ? AppTheme.sageGreen : AppTheme.mintGreen,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
