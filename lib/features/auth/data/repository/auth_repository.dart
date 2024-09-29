import 'package:fpdart/src/either.dart';
import 'package:where_is_my_bus/core/entities/user.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSouce authRemoteDataSouce;
  AuthRepositoryImpl({required this.authRemoteDataSouce});
  @override
  Future<Either<Failure, User>> getCurrentUser() {
    return authRemoteDataSouce.getCurrentUser();
  }

  @override
  Future<Either<Failure, String>> signOut() {
    return authRemoteDataSouce.signOut();
  }

  @override
  Future<Either<Failure, User>> signUpWithGoogle() {
    return authRemoteDataSouce.signInWithGoogle();
  }
}
