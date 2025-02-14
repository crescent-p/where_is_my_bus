import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/data/data_sources/locations_remote_datasource.dart';

import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';

import 'package:where_is_my_bus/features/bus_list_page/domain/repository/locations_repository.dart';

bool wasMoving = false;

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsRemoteDatasource repository;

  LocationsRepositoryImpl({required this.repository});

  @override
  Future<Either<Failure, List<BusCoordinates>>> getBusLocations() async {
    try {
      final res = await repository.getCoordinatesTable();
      return res.fold(
        (onLeft) => Left(onLeft),
        (onRight) {
          List<BusCoordinates> coordinates = onRight;
          return Right(coordinates);
        },
      );
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, String>> updateCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //           accuracy: LocationAccuracy.bestForNavigation),
  //     );

  //     double speed = position.speed;
  //     bool deviceIsMoving = false;

  //     //only update location if two subsequent speed values give true.
  //     if (speed >= THRESHOLD_SPEED_TO_BE_CALLED_MOVING) {
  //       deviceIsMoving = true;
  //     } else {
  //       deviceIsMoving = false;
  //     }
  //     if (deviceIsMoving ) {
  //       final res = await repository.updateCurrentLocation(position: position);
  //       return res.fold((l) => Left(l), (r) => Right(r));
  //     } else {
  //       return const Right("User is not in a Bus. (i think)");
  //     }
  //   } catch (e) {
  //     return Left(Failure(message: e.toString()));
  //   }
  // }
}
