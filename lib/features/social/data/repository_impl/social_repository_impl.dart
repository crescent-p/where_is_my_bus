import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/src/either.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/social/data/data_source/social_local_datasource.dart';
import 'package:where_is_my_bus/features/social/data/data_source/social_remote_datasource.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  final Connectivity connectivity;
  final SocialLocalDataSource socialLocalDataSource;
  final SocialRemoteDataSource socialRemoteDataSource;
  SocialRepositoryImpl({
    required this.socialLocalDataSource,
    required this.socialRemoteDataSource,
    required this.connectivity,
  });

  Future<bool> isConnected() async {
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  //shoudl be miniPost
  @override
  Future<Either<Failure, Map<String, List<MiniPost>>>> getMiniPosts(
      int startIndex, int count) async {
    if (await isConnected()) {
      return socialRemoteDataSource.getMiniPosts(startIndex, count);
    } else {
      return socialLocalDataSource.getMiniPosts(startIndex, count);
    }
  }

  @override
  Future<Either<Failure, Post>> getPostSpecific(String uuid) async {
    if (await isConnected()) {
      return socialRemoteDataSource.getSpecificPosts(uuid);
    } else {
      throw UnimplementedError();
      // return socialLocalDataSource.getSpecificPost(uuid);
    }
  }

  @override
  Future<Either<Failure, List<Comments>>> getComments(String postID) async {
    if (await isConnected()) {
      return socialRemoteDataSource.getComments(postID);
    } else {
      return socialLocalDataSource.getComments(postID);
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByType(String type) {
    // TODO: implement getPostsByType
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> postComments(Comments comment) async {
    if (await isConnected()) {
      return socialRemoteDataSource.setComment(comment);
    } else {
      return Left(Failure(message: "No internet connection bruh!"));
    }
  }
}
