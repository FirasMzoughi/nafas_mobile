import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Container(
        decoration: isDarkMode 
            ? AppTheme.backgroundGradient 
            : AppTheme.lightBackgroundGradient,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.spa,
                color: isDarkMode ? Colors.white : AppTheme.sageGreen,
                size: 100,
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    duration: const Duration(seconds: 2),
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
              Text(
                'Nafas',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
