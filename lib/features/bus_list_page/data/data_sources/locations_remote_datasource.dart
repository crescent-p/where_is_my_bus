import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

abstract interface class LocationsRemoteDatasource {
  Future<Either<Failure, List<BusCoordinates>>> getCoordinatesTable();
  Future<Either<Failure, String>> updateCurrentLocation(
      {required Coordinates coordinates});
}

class LocationsRemoteDatasourceImpl implements LocationsRemoteDatasource {
  final SupabaseClient client;

  LocationsRemoteDatasourceImpl({required this.client});

  @override
  Future<Either<Failure, List<BusCoordinates>>> getCoordinatesTable() async {
    try {
      final DateTime timePeriod =
          DateTime.now().subtract(Duration(days: 1)); // Example: last 7 days
      final String formattedTime = timePeriod.toIso8601String();

      final response = await client
          .from("coordinates")
          .select('x-coordinate, y-coordinate, time-added')
          .gte('time-added', formattedTime);

      final List<BusCoordinates> coordinatesList = (response as List)
          .map((item) => BusCoordinates(
              coordinates: Coordinates(
                x: item['x-coordinate'] is double
                    ? item['x-coordinate']
                    : (item['x-coordinate'] as num).toDouble(),
                y: item['y-coordinate'] is double
                    ? item['y-coordinate']
                    : (item['y-coordinate'] as num).toDouble(),
              ),
              lastSeen: DateTime.parse(item['time-added'] as String)))
          .toList();

      return Right(coordinatesList);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateCurrentLocation(
      {required Coordinates coordinates}) async {
    try {
      final response = await client.from("coordinates").upsert({
        'x-coordinate': coordinates.x,
        'y-coordinate': coordinates.y,
        'time-added': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
      if (response == null) {
        return Left(Failure(message: "Failed to insert coordinates"));
      }

      return const Right("Coordinates updated successfully");
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
