import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';

class AuthSignOutUsecase implements UseCases {
  final AuthRepository repository;

  AuthSignOutUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(params) async {
    try {
      return repository.signOut();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
