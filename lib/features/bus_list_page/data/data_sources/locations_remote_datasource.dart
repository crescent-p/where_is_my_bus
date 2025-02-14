import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:http/http.dart' as http;

abstract interface class LocationsRemoteDatasource {
  Future<Either<Failure, List<BusCoordinates>>> getCoordinatesTable();
  // Future<Either<Failure, String>> updateCurrentLocation(
  //     {required Position position});
}

class LocationsRemoteDatasourceImpl implements LocationsRemoteDatasource {
  final SharedPreferences prefs;
  LocationsRemoteDatasourceImpl({required this.prefs});
  @override
  Future<Either<Failure, List<BusCoordinates>>> getCoordinatesTable() async {
    try {
      final idToken = prefs.getString("idToken");
      if (idToken == null) {
        return Left(Failure(message: "Missing authentication token"));
      }

      final headers = {"Authorization": "Bearer $idToken"};
      final res = await http.get(
        Uri.parse("http://68.233.101.85:8000/locations/"),
        headers: headers,
      );

      // Check if the response is successful
      if (res.statusCode != 200) {
        return Left(Failure(message: "HTTP Error: ${res.statusCode}"));
      }

      final json = jsonDecode(res.body); // Ensure JSON parsing
      if (json != null && json["buses"] != null) {
        final List<BusCoordinates> coordinatesList = (json["buses"] as List)
            .map((item) {
              try {
                return BusCoordinates(
                  location: item["location"],
                  latitude: item["latitude"] ?? 0.0,
                  longitude: item["longitude"] ?? 0.0,
                  speed: item["speed"] ?? 0.0,
                  lastUpdated: DateTime.parse(
                    item["last_updated"] ?? DateTime.now().toIso8601String(),
                  ).toLocal(),
                  createdAt: DateTime.parse(
                    item["created_at"] ?? DateTime.now().toIso8601String(),
                  ).toLocal(),
                  noOfContributors: item["no_of_contributors"] ?? 0,
                  name: item["name"] ?? "Unknown",
                  confidence: item["confidence"] ?? 0.0,
                );
              } catch (_) {
                return null; // Skip invalid items
              }
            })
            .whereType<BusCoordinates>()
            .toList();

        return Right(coordinatesList);
      }

      return Left(Failure(message: "Couldn't parse JSON Data"));
    } catch (e) {
      return Left(Failure(message: "Error: ${e.toString()}"));
    }
  }

  // @override
  // Future<Either<Failure, String>> updateCurrentLocation(
  //     {required Position position}) async {
  //   try {
  //     final idToken = prefs.getString("idToken"); // Safely access idToken
  //     final headers = {
  //       "Content-Type": "application/json",
  //       "Authorization":
  //           "Bearer $idToken", // Pass idToken in the Authorization header
  //     };
  //     final requestBody = {
  //       "token": idToken, // If required in the body as well
  //       "uuid": "UUUGHWhy did i put this here",
  //       "latitude": position.latitude.toString(),
  //       "longitude": position.longitude.toString(),
  //       "speed": position.speed.toString(), // Handle null speeds
  //       "location_accuracy":
  //           position.accuracy.toString(), // Correct accuracy field
  //       "satelite_count": "0"
  //     };

  //     try {
  //       final res = await http.post(
  //         Uri.parse("http://68.233.101.85:8000/locations/"),
  //         headers: headers,
  //         body: jsonEncode(requestBody), // Properly encode the body
  //       );

  //       if (res.statusCode == 200) {
  //         return const Right("Coordinates updated successfully");
  //       } else {
  //         return Left(Failure(message: "Server Error!"));
  //       }
  //     } catch (e) {
  //       return Left(Failure(message: e.toString()));
  //     }

  //     // final response = await client.from("coordinates").upsert({
  //     //   'x-coordinate': pos.x,
  //     //   'y-coordinate': coordinates.y,
  //     //   'time-added': DateTime.now().toIso8601String(),
  //     // }, onConflict: 'id');
  //     // if (response == null) {
  //     //   return Left(Failure(message: "Failed to insert coordinates"));
  //     // }
  //   } catch (e) {
  //     return Left(Failure(message: e.toString()));
  //   }
  // }
}
