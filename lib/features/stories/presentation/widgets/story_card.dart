import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/features/stories/domain/story.dart';
import 'package:intl/intl.dart';

class StoryCard extends StatefulWidget {
  final Story story;
  final bool isDarkMode;

  const StoryCard({
    super.key, 
    required this.story,
    required this.isDarkMode,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _isBlurred = true;

  @override
  void initState() {
    super.initState();
    _isBlurred = widget.story.isTriggerWarning;
  }

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
    final timeAgo = DateTime.now().difference(widget.story.createdAt);
    String timeString = '';
    if (timeAgo.inMinutes < 60) {
      timeString = '${timeAgo.inMinutes}m ago';
    } else if (timeAgo.inHours < 24) {
      timeString = '${timeAgo.inHours}h ago';
    } else {
      timeString = '${timeAgo.inDays}d ago';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDarkMode ? Colors.white.withOpacity(0.1) : AppTheme.sageGreen.withOpacity(0.2),
        ),
        boxShadow: widget.isDarkMode ? [] : [
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getIconColor(widget.story.authorMask).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconData(widget.story.authorMask),
                  color: _getIconColor(widget.story.authorMask),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.story.authorPseudonym,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : AppTheme.darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    timeString,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.story.isTriggerWarning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'TRIGGER WARNING',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Content
          GestureDetector(
            onTap: () {
              if (_isBlurred) {
                setState(() {
                  _isBlurred = false;
                });
              }
            },
            child: Stack(
              children: [
                Text(
                  widget.story.content,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                if (_isBlurred)
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: widget.isDarkMode ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Tap to view',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Footer
          Row(
            children: [
              _ReactionButton(
                icon: Icons.favorite_border,
                count: widget.story.likesCount,
                color: Colors.pinkAccent,
                isDarkMode: widget.isDarkMode,
              ),
              const SizedBox(width: 24),
              _ReactionButton(
                icon: Icons.chat_bubble_outline,
                count: widget.story.commentsCount,
                color: Colors.blueAccent,
                isDarkMode: widget.isDarkMode,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.share_outlined, color: widget.isDarkMode ? Colors.white54 : Colors.black54, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final bool isDarkMode;

  const _ReactionButton({
    required this.icon,
    required this.count,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: isDarkMode ? Colors.white54 : Colors.black54, size: 20),
        const SizedBox(width: 6),
        Text(
          '$count',
          style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
