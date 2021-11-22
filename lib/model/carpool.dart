class Carpool {
  const Carpool({
    required this.id,
    required this.userUid,
    required this.carUid,
    required this.startLocation,
    required this.startLocationDetail,
    required this.endLocation,
    required this.endLocationDetail,
    required this.downtown,
    required this.maxNum,
    required this.currentNum,
    required this.fee,
    required this.regular,
    required this.departureTime,
    required this.memo,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String userUid;
  final String carUid;
  final String startLocation;
  final String startLocationDetail;
  final String endLocation;
  final String endLocationDetail;
  final bool downtown;
  final int maxNum;
  final int currentNum;
  final int fee;
  final bool regular;
  final DateTime departureTime;
  final String memo;
  final DateTime regDate;
  final DateTime modDate;

}