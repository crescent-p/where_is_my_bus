import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class GetMiniPostsUsecase
    implements UseCases<Map<String, List<MiniPost>>, MiniPostParams> {
  final SocialRepository repository;
  GetMiniPostsUsecase({required this.repository});
  @override
  Future<Either<Failure, Map<String, List<MiniPost>>>> call(
      MiniPostParams params) async {
    try {
      return repository.getMiniPosts(params.startindex, params.count);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

class MiniPostParams {
  final int startindex;
  final int count;

  MiniPostParams({required this.startindex, required this.count});
}
