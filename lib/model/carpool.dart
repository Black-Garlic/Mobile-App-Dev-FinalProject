class Carpool {
  const Carpool({
    required this.id,
    required this.userUid,
    required this.nickname,
    required this.carUid,
    required this.carNum,
    required this.carDesc,
    required this.startLocation,
    required this.startLocationDetail,
    required this.endLocation,
    required this.endLocationDetail,
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
  final String nickname;
  final String carUid;
  final String carNum;
  final String carDesc;
  final String startLocation;
  final String startLocationDetail;
  final String endLocation;
  final String endLocationDetail;
  final int maxNum;
  final int currentNum;
  final int fee;
  final bool regular;
  final DateTime departureTime;
  final String memo;
  final DateTime regDate;
  final DateTime modDate;

}