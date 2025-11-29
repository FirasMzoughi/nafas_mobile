import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';
import 'package:nafas/features/home/data/mock_room_repository.dart';
import 'package:nafas/features/home/domain/room.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(activeRoomsProvider);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sanctuary',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : AppTheme.darkGreen),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Notifications'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildNotificationItem(
                                        'Welcome to Nafas!',
                                        'Start your recovery journey today',
                                        Icons.celebration,
                                      ),
                                      const Divider(),
                                      _buildNotificationItem(
                                        'New Room Available',
                                        'Join "Evening Reflection" now',
                                        Icons.group,
                                      ),
                                      const Divider(),
                                      _buildNotificationItem(
                                        'Daily Reminder',
                                        'Take a moment to breathe',
                                        Icons.self_improvement,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Streak Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.sageGreen.withOpacity(0.8),
                              AppTheme.sageGreen.withOpacity(0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.local_fire_department, color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5 Days Clean',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Keep the flame alive',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white70,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(),
                      const SizedBox(height: 30),
                      Text(
                        'Active Rooms',
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
              roomsAsync.when(
                data: (rooms) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final room = rooms[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: _RoomCard(room: room, isDarkMode: isDarkMode),
                      ).animate().fadeIn(delay: (200 + index * 100).ms).slideY(begin: 0.2, end: 0);
                    },
                    childCount: rooms.length,
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)), // Space for FAB/Nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.sageGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  final bool isDarkMode;

  const _RoomCard({
    required this.room,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/home/room/${room.id}', extra: room);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.white.withOpacity(0.1) : AppTheme.sageGreen.withOpacity(0.2),
          ),
          boxShadow: isDarkMode ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    room.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ...room.tags.take(3).map((tag) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.1) : AppTheme.sageGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : AppTheme.sageGreen,
                          fontSize: 12,
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.headset, color: AppTheme.sageGreen, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${room.listenersCount}',
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.mic, color: isDarkMode ? Colors.white70 : Colors.black54, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${room.speakersCount}',
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  width: 60,
                  height: 30,
                  child: Stack(
                    children: List.generate(
                      room.speakerAvatars.take(3).length,
                      (index) => Positioned(
                        left: index * 15.0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDarkMode ? AppTheme.darkGreen : AppTheme.lightMint,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.sageGreen, width: 1),
                          ),
                          child: Icon(Icons.person, size: 16, color: isDarkMode ? Colors.white : AppTheme.sageGreen),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
