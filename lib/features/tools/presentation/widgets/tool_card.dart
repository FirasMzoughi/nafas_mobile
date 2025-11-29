import 'package:flutter/material.dart';
import 'package:nafas/core/theme/app_theme.dart';

class ToolCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String duration;
  final VoidCallback onTap;
  final bool isDarkMode;

  const ToolCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppTheme.sageGreen.withOpacity(0.2),
          ),
          boxShadow: isDarkMode
              ? []
              : [
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.sageGreen.withOpacity(0.2)
                    : AppTheme.lightMint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDarkMode ? AppTheme.sageGreen : AppTheme.darkGreen,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: isDarkMode ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDarkMode ? Colors.white54 : Colors.black45,
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
