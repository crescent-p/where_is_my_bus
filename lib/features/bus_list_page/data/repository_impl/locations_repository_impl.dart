import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/locations_remote_datasource.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/repository/locations_repository.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsRemoteDatasource repository;

  LocationsRepositoryImpl({required this.repository});

  @override
  Future<Either<Failure, List<BusCoordinates>>> getBusLocations() async {
    try {
      print("getBusLocation called\n");
      final res = await repository.getCoordinatesTable();
      return res.fold(
        (onLeft) => Left(onLeft),
        (onRight) {
          List<BusCoordinates> coordinates = onRight;
          List<BusCoordinates> busLocations = processCoordinates(coordinates);
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
      if (deviceIsMoving) {
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

  
double calculateDistance(
    BusCoordinates coordinate1, BusCoordinates coordinate2) {
  const R = 6371; // Radius of the Earth in kilometers
  final lat1Rad = coordinate1.coordinates.x *
      pi /
      180; // Convert latitude from degrees to radians
  final lon1Rad = coordinate1.coordinates.y *
      pi /
      180; // Convert longitude from degrees to radians
  final lat2Rad = coordinate2.coordinates.x * pi / 180;
  final lon2Rad = coordinate2.coordinates.y * pi / 180;

  final deltaLat = lat2Rad - lat1Rad; // Difference in latitude
  final deltaLon = lon2Rad - lon1Rad; // Difference in longitude

  final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final distance = R * c; // Distance in kilometers

  return distance * 1000;
}



  List<Bus> processCoordinates(List<BusCoordinates> coordinates) {
     List<BusCoordinates> busLocations = [];
  Set<int> selectedIndex = {};
  for (int i = 0; i < coordinates.length; i++) {
    List<BusCoordinates> currCoordinates = [];
    Set<int> currSelecion = {};
    for (int j = 0; j < coordinates.length; j++) {
      if(selectedIndex.contains(j)) continue;
      if (calculateDistance(coordinates[i], coordinates[j]) < 10) {
        currSelecion.add(j);
        currCoordinates.add(coordinates[j]);
      }
    }
    if (currSelecion.length >= 3) {
      selectedIndex.addAll(currSelecion);
      busLocations.add(coordinates[i]);
    }
  }

  return mapCoordinatesToAddress(busLocations);
  }

  List<Bus> mapCoordinatesToAddress(List<BusCoordinates> coordinates) {
    List<Bus> buses = [];
    
    return buses;
  }
}
