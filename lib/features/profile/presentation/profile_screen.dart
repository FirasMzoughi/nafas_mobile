import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';
import 'package:nafas/features/auth/data/mock_auth_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  IconData _getIconData(String maskName) {
    switch (maskName) {
      case 'Calm': return Icons.spa;
      case 'Flow': return Icons.waves;
      case 'Hope': return Icons.wb_sunny;
      case 'Mystery': return Icons.nights_stay;
      case 'Spirit': return Icons.local_fire_department;
      default: return Icons.person;
    }
  }

  Color _getIconColor(String maskName) {
     switch (maskName) {
      case 'Calm': return AppTheme.sageGreen;
      case 'Flow': return Colors.blueAccent;
      case 'Hope': return Colors.amber;
      case 'Mystery': return Colors.deepPurpleAccent;
      case 'Spirit': return Colors.orangeAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    return Scaffold(
      body: Container(
        decoration: isDarkMode 
            ? AppTheme.backgroundGradient 
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Header
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _getIconColor(user.maskId).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getIconColor(user.maskId),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getIconColor(user.maskId).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Icon(
                        _getIconData(user.maskId),
                        size: 60,
                        color: _getIconColor(user.maskId),
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    Text(
                      user.pseudonym,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            // color: Colors.white, // Use theme color
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Mask: ${user.maskId}',
                        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _StatCard(
                      label: 'Days Joined',
                      value: '5',
                      icon: Icons.calendar_today,
                      color: Colors.blueAccent,
                      isDarkMode: isDarkMode,
                    ),
                    _StatCard(
                      label: 'Stories',
                      value: '12',
                      icon: Icons.edit_note,
                      color: AppTheme.sageGreen,
                      isDarkMode: isDarkMode,
                    ),
                    _StatCard(
                      label: 'Badges',
                      value: '3',
                      icon: Icons.military_tech,
                      color: Colors.amber,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 40),
                
                // Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _SettingSwitch(
                        title: 'Notifications',
                        value: _notificationsEnabled,
                        onChanged: (val) => setState(() => _notificationsEnabled = val),
                        icon: Icons.notifications_outlined,
                        isDarkMode: isDarkMode,
                      ),
                      const Divider(color: Colors.white10),
                      _SettingSwitch(
                        title: 'Dark Mode',
                        value: isDarkMode,
                        onChanged: (val) => ref.read(themeModeProvider.notifier).setDarkMode(val),
                        icon: Icons.dark_mode_outlined,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 24),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(authRepositoryProvider).logout();
                      ref.read(currentUserProvider.notifier).setUser(null);
                      context.go('/auth');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Leave Sanctuary'),
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white54 : Colors.black54,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final bool isDarkMode;

  const _SettingSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.icon,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 16),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.sageGreen,
          ),
        ],
      ),
    );
  }
}
