import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
part 'hive_object.g.dart';

@HiveType(typeId: 0) // Unique typeId for the Post model
class HivePost extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final int likes;

  @HiveField(3)
  final Uint8List image; // Storing images as bytes

  @HiveField(4)
  final String userEmail;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final DateTime datetime;

  HivePost({
    required this.uuid,
    required this.type,
    required this.likes,
    required this.userEmail,
    required this.image,
    required this.description,
    required this.datetime,
  });
  Post toPost() {
    return Post(
      uuid: uuid,
      type: type,
      userEmail: userEmail,
      description: description,
      image: image,
      likes: likes,
      datetime: datetime,
    );
  }
}

@HiveType(typeId: 1)
class HiveMiniPost extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String userEmail;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final Uint8List image;

  HiveMiniPost({
    required this.uuid,
    required this.type,
    required this.userEmail,
    required this.description,
    required this.image,
  });
  MiniPost toMiniPost() {
    return MiniPost(
        venue: type,
        uuid: uuid,
        type: type,
        userEmail: userEmail,
        heading: description,
        image: image);
  }
}

@HiveType(typeId: 2)
class HiveComment extends HiveObject {
  @HiveField(0)
  final String postId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final DateTime timestamp;

  HiveComment({
    required this.postId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  Comments toComment() {
    return Comments(
      postId: postId,
      userEmail: userName,
      text: text,
      timestamp: timestamp,
    );
  }
}
