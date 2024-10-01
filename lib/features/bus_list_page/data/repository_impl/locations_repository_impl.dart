import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/locations_remote_datasource.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/repository/locations_repository.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsRemoteDatasource repository;

  LocationsRepositoryImpl({required this.repository});

  @override
  Future<Either<Failure, List<Bus>>> getBusLocations() async {
    try {
      print("getBusLocation called\n");
      final res = await repository.getCoordinatesTable();
      return res.fold(
        (onLeft) => Left(onLeft),
        (onRight) {
          List<Coordinates> coordinates = onRight;
          List<Bus> busLocations = processCoordinates(coordinates);
          return Right(busLocations);
        },
      );
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation),
      );
      final Coordinates coordinates = Coordinates(
        x: position.latitude,
        y: position.longitude,
      );
      final res =
          await repository.updateCurrentLocation(coordinates: coordinates);
      return res.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  List<Bus> processCoordinates(List<Coordinates> coordinates) {
    List<Bus> busLocations = [Bus(coordinates: Coordinates(x: 12, y: 34))];
    //TODO:: juicy juicy
    busLocations = coordinates
        .map((e) => Bus(coordinates: Coordinates(x: e.x, y: e.y)))
        .toList();
    return busLocations;
  }
}
