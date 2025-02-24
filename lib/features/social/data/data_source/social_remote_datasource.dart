import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:http/http.dart' as http;
import 'package:where_is_my_bus/init_dependencies.dart';

const String url = "68.233.101.85";

abstract interface class SocialRemoteDataSource {
  Future<Either<Failure, Map<String, List<MiniPost>>>> getMiniPosts(
      int curr, int limit);
  Future<Either<Failure, Post>> getSpecificPosts(String uuid);
  Future<Either<Failure, List<Post>>> getPostsByType(String type);
  Future<Either<Failure, List<Comments>>> getComments(String postId);
  Future<Either<Failure, void>> setComment(Comments comment);
  Future<Either<Failure, Post>> getSpecificPost(String uuid);
}

class SocialRemoteDataSourceImple implements SocialRemoteDataSource {
  Map<String, String> cursors = {};
  @override
  Future<Either<Failure, Map<String, List<MiniPost>>>> getMiniPosts(
      int curr, int limit) async {
    try {
      final res = await http.get(
        Uri.parse("http://$url/social/miniposts?limit=$limit"),
      );
      if (res.statusCode != 200) {
        return Left(Failure(message: "HTTP Error: ${res.statusCode}"));
      }
      Map<String, List<MiniPost>> posts;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      posts = body.map((key, value) {
        final list =
            (value as List).map((item) => MiniPost.fromJson(item)).toList();
        return MapEntry(key, list);
      });
      return Right(posts);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> getSpecificPosts(String uuid) async {
    final res = await http
        .get(Uri.parse("http://68.233.101.85/social/get_post?uuid=$uuid"));
    if (res.statusCode != 200) {
      return Left(Failure(message: "Couldn't Fetch posts!"));
    }
    final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
    final post = Post(
      highResImageUrl: jsonBody['high_res_image_url'],
      uuid: jsonBody['uuid'],
      type: jsonBody['type'],
      likes: jsonBody['likes'],
      userEmail: jsonBody['user_email'],
      description: jsonBody['description'],
      datetime: DateTime.parse(jsonBody['datetime']),
    );
    return Right(post);
  }

  @override
  Future<Either<Failure, List<Comments>>> getComments(String postId) async {
    try {
      final res;
      if (!cursors.containsKey(postId)) {
        res = await http.get(
          Uri.parse(
              "http://68.233.101.85/social/comment?post_id=$postId&limit=20"),
        );
      } else {
        res = await http.get(
          Uri.parse(
              "http://68.233.101.85/social/comment?post_id=$postId&limit=20&cursor=${cursors[postId]}"),
        );
      }
      if (res.statusCode != 200) {
        return Left(Failure(message: "Couldn't fetch comments"));
      } else {
        // cursors[postId] = res
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        cursors[postId] = body["cursor"] ?? 'None';
        if ((body["body"]).isEmpty) {
          return Right([]);
        }
        final commentsList = (body["body"] as List)
            .map((item) => Comments.fromJson(item))
            .toList();
        return Right(commentsList);
      }
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setComment(Comments comment) {
    // TODO: implement setComment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByType(String type) async {
    try {
      final res = await http.get(Uri.parse(
          "http://127.0.0.1:8000/social/posts_by_type?post_type=$type&limit=$PRELOAD_LIMIT"));
      if (res.statusCode != 200) {
        return Left(Failure(message: "Couldn't Fetch posts!"));
      }
      final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
      final posts = (jsonBody['posts'] as List).map((entry) {
        return Post(
          highResImageUrl: entry['high_res_image_url'],
          uuid: entry['uuid'],
          type: entry['type'],
          likes: entry['likes'],
          userEmail: entry['user_email'],
          description: entry['description'],
          datetime: DateTime.parse(entry['datetime']),
        );
      }).toList();

      return Right(posts);
    } on Exception catch (e) {
      return Left(Failure(message: "Couldn't Fetch posts!"));
    }
  }

  @override
  Future<Either<Failure, Post>> getSpecificPost(String uuid) async {
    try {
      final res = await http
          .get(Uri.parse("http://68.233.101.85/social/get_post?uuid=$uuid"));
      if (res.statusCode != 200) {
        return Left(
            Failure(message: "failed to fetch the post with given uuid"));
      }
      final jsonBody = jsonDecode(res.body) as Map<String, dynamic>;
      final post = Post(
        highResImageUrl: jsonBody['high_res_image_url'],
        uuid: jsonBody['uuid'],
        type: jsonBody['type'],
        likes: jsonBody['likes'],
        userEmail: jsonBody['user_email'],
        description: jsonBody['description'],
        datetime: DateTime.parse(jsonBody['datetime']),
      );
      return Right(post);
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
