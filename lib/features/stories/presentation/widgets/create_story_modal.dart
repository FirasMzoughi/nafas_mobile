import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/features/auth/data/mock_auth_repository.dart';
import 'package:nafas/features/stories/data/mock_story_repository.dart';

class CreateStoryModal extends ConsumerStatefulWidget {
  final bool isDarkMode;

  const CreateStoryModal({super.key, required this.isDarkMode});

  @override
  ConsumerState<CreateStoryModal> createState() => _CreateStoryModalState();
}

class _CreateStoryModalState extends ConsumerState<CreateStoryModal> {
  final TextEditingController _contentController = TextEditingController();
  bool _isTriggerWarning = false;
  bool _isPosting = false;

  Future<void> _postStory() async {
    if (_contentController.text.isEmpty) return;

    setState(() {
      _isPosting = true;
    });

    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await ref.read(storyRepositoryProvider).addStory(
          _contentController.text,
          user.pseudonym,
          user.maskId,
          _isTriggerWarning,
        );
        
        // Refresh stories
        ref.invalidate(storiesProvider);
        
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Story posted successfully')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppTheme.darkGreen : AppTheme.lightMint,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share Your Story',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : AppTheme.darkGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: widget.isDarkMode ? Colors.white54 : Colors.black54),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _contentController,
            style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black87),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind? (Anonymous)',
              hintStyle: TextStyle(color: widget.isDarkMode ? Colors.white38 : Colors.black38),
              filled: true,
              fillColor: widget.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Switch(
                value: _isTriggerWarning,
                onChanged: (value) {
                  setState(() {
                    _isTriggerWarning = value;
                  });
                },
                activeColor: Colors.redAccent,
              ),
              Text(
                'Trigger Warning',
                style: TextStyle(color: widget.isDarkMode ? Colors.white70 : Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isPosting ? null : _postStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sageGreen,
                foregroundColor: Colors.white,
              ),
              child: _isPosting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Post Story'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
