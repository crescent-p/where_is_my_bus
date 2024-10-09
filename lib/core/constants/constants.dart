// ignore_for_file: constant_identifier_names
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

const UPDATE_LOCATION_INTERVAL = 3;
const UPDATE_LIST_INTERVAL = 15;
//humans walk at a speed of avg 1.2m/s. and run at around 5m/s
const THRESHOLD_SPEED_TO_BE_CALLED_MOVING = 0;
const THRESHOLD_SPEED_ACCURACY = 1000.5;
const QUERY_WINDOW = 1; //in hours
const NUMBER_OF_GROPUED_POINTS_TO_BE_CALLED_BUS = 1;
const NOTIFICATION_ID = 1;
final Coordinates NITCcoordinate =
    Coordinates(x: 11.32189945605612, y: 75.93439333794181);
