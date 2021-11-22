class User {
  const User({
    required this.userUid,
    required this.name,
    required this.nickname,
    required this.email,
    required this.regDate,
    required this.modDate,
  });
  final String userUid;
  final String name;
  final String nickname;
  final String email;
  final DateTime regDate;
  final DateTime modDate;
}