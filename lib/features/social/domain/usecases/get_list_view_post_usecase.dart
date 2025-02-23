import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/domain/repository/locations_repository.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class GetListViewPostUsecase implements UseCases<List<Post>, Params> {
  final SocialRepository repository;
  final String type;
  GetListViewPostUsecase({required this.type, required this.repository});
  @override
  Future<Either<Failure, List<Post>>> call(Params params) async {
    try {
      return repository.getPostsByType(params.uuid);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

class Params {
  String uuid;
  Params({required this.uuid});
}
