import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/social/data/database/hive_object.dart';
import 'package:where_is_my_bus/features/social/data/database/hive_storage.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_list_view_post_usecase.dart';

abstract interface class SocialLocalDataSource {
  Future<Either<Failure, Map<String, List<MiniPost>>>> getMiniPosts(
      int startIndex, int count);
  Future<Either<Failure, void>> setPost(List<HivePost> post);
  Future<Either<Failure, List<Post>>> getSpecificPost(String uuid);
  Future<Either<Failure, List<MiniPost>>> getSpecificMiniPost(
      String heading, int startIndex, int count);
  Future<Either<Failure, void>> setMiniPost(List<HiveMiniPost> post);
  Future<Either<Failure, List<Comments>>> getComments(String postsId);
  // Future<Either<Failure, Syring>> setComments(
  //     String postId, Comments comments);
}

class SocialLocalDataSourceImple implements SocialLocalDataSource {
  final HiveStorage storage;
  SocialLocalDataSourceImple({required this.storage});
  @override
  Future<Either<Failure, Map<String, List<MiniPost>>>> getMiniPosts(
      int startIndex, int count) async {
    try {
      return Right(storage.retrieveMiniPosts(startIndex, count));
    } catch (e) {
      return Left(Failure(message: "failed to retrive posts from database"));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getSpecificPost(
      String uuid) async {
    try {
      final posts = storage.retrievePosts(uuid);
      final filteredPosts =
          posts.where((post) => post.uuid == uuid).toList();
      return Right(filteredPosts);
    } catch (e) {
      return Left(
          Failure(message: "failed to retrieve specific posts from database"));
    }
  }

  @override
  Future<Either<Failure, void>> setMiniPost(List<HiveMiniPost> post) async {
    try {
      storage.storeMiniPosts(post);
      return Right(null);
    } catch (e) {
      return Left(Failure(message: "failed to save mini post to database"));
    }
  }

  @override
  Future<Either<Failure, void>> setPost(List<HivePost> post) async {
    try {
      storage.storePosts(post);
      return Right(null);
    } catch (e) {
      return Left(Failure(message: "failed to save mini post to database"));
    }
  }

  @override
  Future<Either<Failure, List<MiniPost>>> getSpecificMiniPost(
      String heading, int startIndex, int count) {
    // TODO: implement getSpecificMiniPost
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Comments>>> getComments(String postsId) {
    // TODO: implement getComments
    throw UnimplementedError();
  }

}
