class BusCoordinates {
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime lastUpdated;
  final DateTime createdAt;
  final int noOfContributors;
  final String name;
  final double confidence;
  final String location;
  BusCoordinates(
      {required this.latitude,
      required this.location,
      required this.longitude,
      required this.speed,
      required this.lastUpdated,
      required this.createdAt,
      required this.noOfContributors,
      required this.name,
      required this.confidence});
}
