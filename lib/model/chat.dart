class Chat {
  const Chat({
    required this.id,
    required this.userUid,
    required this.nickname,
    required this.carpoolUid,
    required this.message,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String userUid;
  final String nickname;
  final String carpoolUid;
  final String message;
  final DateTime regDate;
  final DateTime modDate;
}