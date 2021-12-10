class Parcitipate {
  const Parcitipate({
    required this.id,
    required this.userUid,
    required this.nickname,
    required this.carpoolUid,
    required this.send,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String userUid;
  final String nickname;
  final String carpoolUid;
  final bool send;
  final DateTime regDate;
  final DateTime modDate;
}