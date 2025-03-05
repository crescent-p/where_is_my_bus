class MyNotification {
  final int id;
  final String message;
  final DateTime createdAt;

  MyNotification({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
