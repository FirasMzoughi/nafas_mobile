class User {
  final String id;
  final String pseudonym;
  final String maskId; // Identifier for the selected avatar/mask
  final DateTime joinedAt;

  User({
    required this.id,
    required this.pseudonym,
    required this.maskId,
    required this.joinedAt,
  });
}
