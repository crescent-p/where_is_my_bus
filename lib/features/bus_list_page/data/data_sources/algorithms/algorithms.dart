import 'dart:math';

import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

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

/* function assumes the list of coordinates are in clockwise order.
  What does it do?
    - given the outline of a polygon. Returns whether a passed point is inside or outside.
    - Uses ray casting algorithm to find it.
*/
bool checkIfInsideListOfCoordinates(
    List<Coordinates> coordinates, Coordinates coordinate) {
  int currCount = 0; // if even point outside. else odd.

  for (int i = 0; i < coordinates.length - 1; i++) {
    double x1 = coordinates[i].x;
    double x2 = coordinates[i + 1].x;
    double y1 = coordinates[i].y;
    double y2 = coordinates[i + 1].y;
    //point
    double x = coordinate.x;
    double y = coordinate.y;

    if (x >= x1 && x >= x2) continue;
    if (y <= min(y1, y2) || y >= max(y1, y2)) continue;

    double intersectionPoint = x1 + ((x2 - x1) / (y2 - y1)) * (y - y1);
    if (x < intersectionPoint) currCount++;
  }

  return currCount % 2 == 1;
}

List<Bus> processCoordinates(List<BusCoordinates> coordinates) {
  List<BusCoordinates> busLocations = [];
  Set<int> selectedIndex = {};
  for (int i = 0; i < coordinates.length; i++) {
    List<BusCoordinates> currCoordinates = [];
    Set<int> currSelecion = {};
    DateTime lowest = DateTime(1960);
    for (int j = 0; j < coordinates.length; j++) {
      if (selectedIndex.contains(j)) continue;
      if (calculateDistance(coordinates[i], coordinates[j]) < 10) {
        currSelecion.add(j);
        currCoordinates.add(coordinates[j]);
        lowest = (coordinates[j].lastSeen.difference(lowest).inSeconds > 0)
            ? coordinates[j].lastSeen
            : lowest;
      }
    }
    if (currSelecion.length >= NUMBER_OF_GROPUED_POINTS_TO_BE_CALLED_BUS) {
      selectedIndex.addAll(currSelecion);
      BusCoordinates temp = BusCoordinates(
          coordinates: coordinates[i].coordinates, lastSeen: lowest);
      busLocations.add(temp);
    }
  }

  return mapCoordinatesToAddress(busLocations);
}

List<Bus> mapCoordinatesToAddress(List<BusCoordinates> coordinates) {
  // TODO::
  List<Bus> buses = [];
  buses.addAll(coordinates.map((e) => Bus(
      location:
          "Somewhere in Campus\nx-Coordinate: ${e.coordinates.x}\ny-Coordinate: ${e.coordinates.y}\n",
      lastUpdated: e.lastSeen)));
  buses.sort((a, b) => -(a.lastUpdated.difference(b.lastUpdated).inSeconds));
  return buses;
}
