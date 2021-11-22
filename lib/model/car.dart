class Car {
  const Car({
    required this.id,
    required this.userUid,
    required this.car,
    required this.desc,
    required this.regDate,
    required this.modDate,
  });
  final String id;
  final String userUid;
  final String car;
  final String desc;
  final DateTime regDate;
  final DateTime modDate;
}