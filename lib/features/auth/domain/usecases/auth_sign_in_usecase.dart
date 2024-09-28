import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/entities/user.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';

class AuthSignUpWithGoogleUsecase implements UseCases {
  final AuthRepository repository;

  AuthSignUpWithGoogleUsecase({required this.repository});

  @override
  Future<Either<Failure, User>> call(params) async {
    try {
      return repository.signUpWithGoogle();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
