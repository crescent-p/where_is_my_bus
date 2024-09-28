import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';

abstract interface class UseCases<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
