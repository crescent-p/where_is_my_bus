// import 'package:fpdart/src/either.dart';
// import 'package:where_is_my_bus/core/error/failure.dart';
// import 'package:where_is_my_bus/core/usecases/usecases.dart';
// import 'package:where_is_my_bus/features/bus_list_page/domain/repository/locations_repository.dart';

// class UpdateCurrentLocationUsecase implements UseCases<String, NoParams> {
//   final LocationsRepository repository;

//   UpdateCurrentLocationUsecase({required this.repository});
//   @override
//   Future<Either<Failure, String>> call(params)async {
//     try {
//       return repository.updateCurrentLocation();
//     } catch (e) {
//       return left(Failure(message: e.toString()));
//     }
//   }
// }
