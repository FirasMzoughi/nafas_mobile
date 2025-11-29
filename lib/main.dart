import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/core/router/app_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: NafasApp()));
}

class NafasApp extends ConsumerWidget {
  const NafasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'Nafas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}

