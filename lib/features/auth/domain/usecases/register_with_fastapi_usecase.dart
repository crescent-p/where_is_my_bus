import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/auth/domain/repository/auth_repository.dart';

class RegisterWithFastAPIUsecase implements UseCases {
  final AuthRepository repository;

  RegisterWithFastAPIUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(params) async {
    try {
      return repository.registerWithFastAPIUsecase();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
