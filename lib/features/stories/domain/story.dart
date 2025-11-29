class Story {
  final String id;
  final String content;
  final String authorPseudonym;
  final String authorMask; // Icon name
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isTriggerWarning;
  final List<String> tags;

  Story({
    required this.id,
    required this.content,
    required this.authorPseudonym,
    required this.authorMask,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isTriggerWarning,
    required this.tags,
  });
}
