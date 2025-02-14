import 'package:fpdart/fpdart.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';

abstract interface class LocationsRepository {
  // Future<Either<Failure, String>> updateCurrentLocation();
  Future<Either<Failure, List<BusCoordinates>>> getBusLocations();
}
