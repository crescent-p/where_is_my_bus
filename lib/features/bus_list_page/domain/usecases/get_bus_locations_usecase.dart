import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/repository/locations_repository.dart';

class GetBusLocationsUsecase
    implements UseCases<List<BusCoordinates>, NoParams> {
  final LocationsRepository repository;
  GetBusLocationsUsecase({required this.repository});
  @override
  Future<Either<Failure, List<BusCoordinates>>> call(NoParams params) async {
    try {
      return await repository.getBusLocations();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
