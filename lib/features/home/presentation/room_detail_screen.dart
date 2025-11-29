import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';
import 'package:nafas/features/home/domain/room.dart';

class RoomDetailScreen extends ConsumerStatefulWidget {
  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  ConsumerState<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends ConsumerState<RoomDetailScreen> {
  bool _isMuted = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkGreen : AppTheme.lightMint,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: isDarkMode ? Colors.white : AppTheme.darkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.room.title,
          style: TextStyle(color: isDarkMode ? Colors.white : AppTheme.darkGreen, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: isDarkMode ? Colors.white : AppTheme.darkGreen),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Speakers',
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: widget.room.speakersCount,
                    itemBuilder: (context, index) {
                      return _UserAvatar(
                        name: widget.room.speakerAvatars[index % widget.room.speakerAvatars.length],
                        isSpeaker: true,
                        isSpeaking: index == 0, // Mock speaking
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Listeners',
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: widget.room.listenersCount > 12 ? 12 : widget.room.listenersCount, // Limit for demo
                    itemBuilder: (context, index) {
                      return _UserAvatar(
                        name: 'Listener ${index + 1}',
                        isSpeaker: false,
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom Controls
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: isDarkMode ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                  onPressed: () => context.pop(),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                  },
                  backgroundColor: _isMuted 
                      ? (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2)) 
                      : AppTheme.sageGreen,
                  child: Icon(
                    _isMuted ? Icons.mic_off : Icons.mic,
                    color: _isMuted 
                        ? (isDarkMode ? Colors.white : Colors.black54) 
                        : Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.handshake_outlined, color: isDarkMode ? Colors.white : Colors.black54),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;
  final bool isSpeaker;
  final bool isSpeaking;
  final bool isDarkMode;

  const _UserAvatar({
    required this.name,
    required this.isSpeaker,
    this.isSpeaking = false,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
            border: isSpeaking
                ? Border.all(color: AppTheme.sageGreen, width: 3)
                : null,
            boxShadow: isDarkMode ? [] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isSpeaker ? Icons.person : Icons.headset,
            color: isDarkMode ? Colors.white : AppTheme.sageGreen,
            size: 30,
          ),
        ).animate(target: isSpeaking ? 1 : 0).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 500.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
