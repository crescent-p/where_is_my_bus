// ignore_for_file: constant_identifier_names
import 'package:where_is_my_bus/features/main_page/domain/entities/coordinates.dart';

const UPDATE_LOCATION_INTERVAL = 2;
const UPDATE_LIST_INTERVAL = 6;
//humans walk at a speed of avg 1.2m/s. and run at around 5m/s
const THRESHOLD_SPEED_TO_BE_CALLED_MOVING = 0;
const THRESHOLD_SPEED_ACCURACY = 1;
const QUERY_WINDOW = 1; //in hours
const NUMBER_OF_GROPUED_POINTS_TO_BE_CALLED_BUS = 1;
const NOTIFICATION_ID = 1989;
final Coordinates nitcCooridnates = Coordinates(x: 11.3218994, y: 75.934393);
const DISTANCE_BETWEEN_TWO_BUS_USERS = 75;

const POST = "POST";
const MINIPOST = "MINIPOST";
const POSTCOUNT = "POSTCOUNT";
const POSTS_SET = "POSTSET";
const MINI_POSTS_SET = "MINIPOSTSET";
const SECTIONS = ["EVENTS", "LOST AND FOUND", "MARKETPLACE", "CULTURAL"];
const MINI_SECTIONS = [
  "MINI EVENTS",
  "MINI LOST AND FOUND",
  "MINI MARKETPLACE",
  "MINI CULTURAL"
];
const SECTION_MAP = {
  "EVENTS": 0,
  "LOST AND FOUND": 1,
  "MARKETPLACE": 2,
  "CULTURAL": 3,
};
const TOTAL_POST_COUNT = 1000000;
const PRELOAD_LIMIT = 10;
const IDTOKEN = "idToken";
const USEREMAIL = "userEmail";
const SEARCHPAGETAG = "searchpagetag";
const NOTIFICATIONTAG = "notificationtag";
