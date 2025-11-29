class Room {
  final String id;
  final String title;
  final int listenersCount;
  final int speakersCount;
  final List<String> tags;
  final List<String> speakerAvatars; // Using mask names or icon data references
  final List<String> listenerAvatars;

  Room({
    required this.id,
    required this.title,
    required this.listenersCount,
    required this.speakersCount,
    required this.tags,
    required this.speakerAvatars,
    required this.listenerAvatars,
  });
}
