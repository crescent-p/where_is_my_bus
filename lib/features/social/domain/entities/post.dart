import 'dart:typed_data';

class Post {
  final String userEmail;
  final String? heading;
  final String? venue;
  final String? eventTiming;
  final String type;
  final String uuid;
  String? highResImageUrl;
  Uint8List? image;
  final String description;
  final int likes;
  DateTime datetime;

  Post({
    this.venue,
    this.eventTiming,
    this.heading,
    required this.uuid,
    required this.type,
    required this.likes,
    required this.userEmail,
    required this.description,
    required this.datetime,
    this.highResImageUrl,
    this.image,
  }) : assert(
          (highResImageUrl != null && image == null) ||
              (image == null && image != null),
          'Either lowResImageUrl or image must be provided, not both.',
        );
}
