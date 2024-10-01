import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

abstract interface class LocationsRepository {

  Future<Either<Failure, String>> updateCurrentLocation({required Coordinates coordinates});
  Future<Either<Failure, List<Bus>>> getBusLocations();
}
