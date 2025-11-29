import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';
import 'package:nafas/features/auth/data/mock_auth_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _pseudonymController = TextEditingController();
  int _selectedMaskIndex = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _masks = [
    {'icon': Icons.spa, 'color': AppTheme.sageGreen, 'name': 'Calm'},
    {'icon': Icons.waves, 'color': Colors.blueAccent, 'name': 'Flow'},
    {'icon': Icons.wb_sunny, 'color': Colors.amber, 'name': 'Hope'},
    {'icon': Icons.nights_stay, 'color': Colors.deepPurpleAccent, 'name': 'Mystery'},
    {'icon': Icons.local_fire_department, 'color': Colors.orangeAccent, 'name': 'Spirit'},
  ];

  Future<void> _enterSanctuary() async {
    if (_pseudonymController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a pseudonym')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.login(
        _pseudonymController.text,
        _masks[_selectedMaskIndex]['name'] as String,
      );
      
      ref.read(currentUserProvider.notifier).setUser(user);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Container(
        decoration: isDarkMode 
            ? AppTheme.backgroundGradient 
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Choose Your Mask',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 8),
                  Text(
                    'This is how you will appear to others. Your real identity remains hidden.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                  ).animate().fadeIn(delay: 200.ms).slideX(),
                  const SizedBox(height: 40),
                  
                  // Mask Carousel
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.5),
                      onPageChanged: (index) {
                        setState(() {
                          _selectedMaskIndex = index;
                        });
                      },
                      itemCount: _masks.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedMaskIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (_masks[index]['color'] as Color).withOpacity(0.2)
                                : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? (_masks[index]['color'] as Color)
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (_masks[index]['color'] as Color).withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _masks[index]['icon'] as IconData,
                            size: isSelected ? 80 : 50,
                            color: isSelected
                                ? (_masks[index]['color'] as Color)
                                : (isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.3)),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(),
                  
                  Center(
                    child: Text(
                      _masks[_selectedMaskIndex]['name'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _masks[_selectedMaskIndex]['color'] as Color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Pseudonym Input
                  TextField(
                    controller: _pseudonymController,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Enter Pseudonym',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                      filled: true,
                      fillColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.person_outline, color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 40),
                  
                  // Enter Sanctuary Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _enterSanctuary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.sageGreen,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: AppTheme.sageGreen.withOpacity(0.5),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Enter Sanctuary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
