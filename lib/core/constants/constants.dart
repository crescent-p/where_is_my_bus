// ignore_for_file: constant_identifier_names
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/coordinates.dart';

const UPDATE_LOCATION_INTERVAL = 3;
const UPDATE_LIST_INTERVAL = 15;
//humans walk at a speed of avg 1.2m/s. and run at around 5m/s
const THRESHOLD_SPEED_TO_BE_CALLED_MOVING = 4;
const THRESHOLD_SPEED_ACCURACY = 1;
const QUERY_WINDOW = 1; //in hours
const NUMBER_OF_GROPUED_POINTS_TO_BE_CALLED_BUS = 1;
const NOTIFICATION_ID = 1989;
final Coordinates NITCcoordinate = Coordinates(x: 11.3218994, y: 75.934393);
const DISTANCE_BETWEEN_TWO_BUS_USERS = 40;
