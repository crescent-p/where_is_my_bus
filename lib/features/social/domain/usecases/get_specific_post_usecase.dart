import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/domain/repository/locations_repository.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class GetSpecificPostUseCase implements UseCases<Post, SpecificPostParams> {
  final SocialRepository repository;
  GetSpecificPostUseCase({required this.repository});
  @override
  Future<Either<Failure, Post>> call(SpecificPostParams params) async {
    try {
      return repository.getPostSpecific(params.uuid);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

class SpecificPostParams {
  String uuid;
  SpecificPostParams({required this.uuid});
}
