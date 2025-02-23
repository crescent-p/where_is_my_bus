import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class GetCommentsUsecase implements UseCases<List<Comments>, Params> {
  final SocialRepository repository;
  GetCommentsUsecase({required this.repository});
  @override
  Future<Either<Failure, List<Comments>>> call(Params params) async {
    try {
      return repository.getComments(params.postID);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

class Params {
  final String postID;

  Params({required this.postID});
}
