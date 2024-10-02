import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

class BusCoordinates {
  Coordinates coordinates;
  final DateTime lastSeen;
  BusCoordinates({required this.coordinates, required this.lastSeen});
}
