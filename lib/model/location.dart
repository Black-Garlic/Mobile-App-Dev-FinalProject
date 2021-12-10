class Location {
  const Location({
    required this.id,
    required this.name,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String name;
  final DateTime regDate;
  final DateTime modDate;
}