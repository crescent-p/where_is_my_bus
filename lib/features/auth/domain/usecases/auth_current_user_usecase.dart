import 'package:fpdart/src/either.dart';
import 'package:where_is_my_bus/core/entities/user.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';

class AuthCurrentUserUsecase implements UseCases {
  final AuthRepository authRepository;

  AuthCurrentUserUsecase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(params) async {
    try {
      return authRepository.getCurrentUser();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
