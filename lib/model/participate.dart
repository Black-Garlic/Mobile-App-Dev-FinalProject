class Parcitipate {
  const Parcitipate({
    required this.id,
    required this.userUid,
    required this.carUid,
    required this.send,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String userUid;
  final String carUid;
  final bool send;
  final DateTime regDate;
  final DateTime modDate;
}