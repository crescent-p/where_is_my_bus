import 'package:fpdart/src/either.dart';
import 'package:where_is_my_bus/core/entities/user.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  @override
  Future<Either<Failure, User>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUpWithGoogle() {
    // TODO: implement signUpWithGoogle
    throw UnimplementedError();
  }

}