import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

abstract interface class LocationsRemoteDatasource {
  Future<Either<Failure, List<Coordinates>>> getCoordinatesTable();
  Future<Either<Failure, String>> updateCurrentLocation(
      {required Coordinates coordinates});
}

class LocationsRemoteDatasourceImpl implements LocationsRemoteDatasource {
  final SupabaseClient client;

  LocationsRemoteDatasourceImpl({required this.client});

  @override
  Future<Either<Failure, List<Coordinates>>> getCoordinatesTable() async {
    try {
      final DateTime timePeriod = DateTime.now().subtract(Duration(days: 900)); // Example: last 7 days
      final String formattedTime = timePeriod.toIso8601String();
      
      final response = await client
          .from("coordinates")
          .select('x-coordinate, y-coordinate')
          .gte('time-added', formattedTime);
      
      if (response == null) {
        return Left(Failure(message: "empty response"));
      }

      final List<Coordinates> coordinatesList = (response as List)
          .map((item) => Coordinates(
            x: item['x-coordinate'],
            y: item['y-coordinate'],
          ))
          .toList();

      return Right(coordinatesList);
      // final coordintesTable = await client
      //     .from("coordinates")
      //     .select('x-coordinate, y-coordinate')
      //     .filter(
      //       'time-added',
      //       'ge',
      //     );
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateCurrentLocation(
      {required Coordinates coordinates}) {
    // TODO: implement updateCurrentLocation
    throw UnimplementedError();
  }
}
