class Comments {
  final String postId;
  final String userEmail;
  final String text;
  final DateTime timestamp;

  Comments({
    required this.postId,
    required this.userEmail,
    required this.text,
    required this.timestamp,
  });
  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      postId: json['post_uuid'].toString(),
      userEmail: json['user_email'],
      text: json['text'],
      timestamp: DateTime.parse(json['datetime']),
    );
  }
}
