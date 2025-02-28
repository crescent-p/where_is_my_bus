import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class AddCommentUsecase implements UseCases<String, PostCommentParams> {
  final SocialRepository repository;
  AddCommentUsecase({required this.repository});
  @override
  Future<Either<Failure, String>> call(PostCommentParams params) async {
    try {
      return repository.postComments(Comments(
          postId: params.postID,
          userEmail: params.userEmail,
          text: params.text,
          timestamp: DateTime.now()));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

class PostCommentParams {
  final String postID;
  final String userEmail;
  final String text;
  PostCommentParams(
      {required this.userEmail, required this.text, required this.postID});
}
