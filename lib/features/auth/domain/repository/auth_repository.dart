import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/entities/user.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/register_with_fastapi_usecase.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithGoogle();
  Future<Either<Failure, String>> signOut();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, String>> registerWithFastAPIUsecase();
}
