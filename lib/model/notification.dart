class Notifications {
  const Notifications({
    required this.id,
    required this.userUid,
    required this.message,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String userUid;
  final String message;
  final DateTime regDate;
  final DateTime modDate;
}