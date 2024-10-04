import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/algorithms/algorithms.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/locations_remote_datasource.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
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
          List<BusCoordinates> coordinates = onRight;
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
      double speed = position.speed;
      bool deviceIsMoving = false;
      if (speed >= THRESHOLD_SPEED_TO_BE_CALLED_MOVING) {
        deviceIsMoving = true;
      }
      if (deviceIsMoving && true) {
        final res =
            await repository.updateCurrentLocation(coordinates: coordinates);
        return res.fold((l) => Left(l), (r) => Right(r));
      } else {
        return const Right("User is not in a Bus. (i think)");
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
