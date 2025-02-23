import 'dart:typed_data';

class MiniPost {
  final String? userEmail;
  final String type;
  final String uuid;
  String? lowResImageUrl;
  final String description;
  Uint8List? image;

  MiniPost({
    required this.uuid,
    required this.type,
    this.userEmail,
    required this.description,
    this.lowResImageUrl,
    this.image,
  }) : assert(
          (lowResImageUrl != null && image == null) ||
              (lowResImageUrl == null && image != null),
          'Either lowResImageUrl or image must be provided, not both.',
        );

  factory MiniPost.fromJson(Map<String, dynamic> json) {
    return MiniPost(
      uuid: json['uuid'],
      type: json['type'],
      description: json['heading'],
      lowResImageUrl: json['imageUrl'],
      image: json['image'] != null
          ? Uint8List.fromList(List<int>.from(json['image']))
          : null,
    );
  }
}
