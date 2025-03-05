import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/my_notification.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';

abstract interface class SocialRepository {
  // Future<Either<Failure, String>> updateCurrentLocation();
  Future<Either<Failure, Map<String, List<MiniPost>>>> getMiniPosts(
      int startIndex, int count);
  Future<Either<Failure, Post>> getPostSpecific(String uuid);
  Future<Either<Failure, List<Post>>> getPostsByType(String type);
  Future<Either<Failure, List<Comments>>> getComments(String postID);
  Future<Either<Failure, String>> postComments(Comments comment);
  Future<Either<Failure, List<MyNotification>>> getNotification();
}
