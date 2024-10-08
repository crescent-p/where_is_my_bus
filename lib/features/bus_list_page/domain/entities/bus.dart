import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

class Bus {
  String location;
  //double speed;
  DateTime lastUpdated;
  Coordinates coordinates;
  Bus(
      {required this.location,
      required this.lastUpdated,
      required this.coordinates});
}
