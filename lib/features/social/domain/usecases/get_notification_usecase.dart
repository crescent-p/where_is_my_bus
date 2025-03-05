import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/my_notification.dart';
import 'package:where_is_my_bus/features/social/domain/repository/social_repository.dart';

class GetNotificationUsecase
    implements UseCases<List<MyNotification>, NoParams> {
  final SocialRepository repository;
  GetNotificationUsecase({required this.repository});
  @override
  Future<Either<Failure, List<MyNotification>>> call(NoParams params) async {
    try {
      return repository.getNotification();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
