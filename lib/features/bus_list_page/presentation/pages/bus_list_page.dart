import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:where_is_my_bus/core/common/widgets/loading_screen.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as my_user;
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/snack_bar.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:where_is_my_bus/features/bus_list_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/request_permission.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/widgets/bus_list.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

const notificationChannelId = 'my_foreground';
bool backgroundStarted = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if ((DateTime.now().millisecondsSinceEpoch / 1000) %
            UPDATE_LOCATION_INTERVAL ==
        0) {
      service.invoke("set_location", {'value': 'myvalue'});
    }
  });
}

class BusListPage extends StatefulWidget {
  final my_user.User user;
  List<BusCoordinates> busStreamCache = [];
  BusListPage({super.key, required this.user});

  static Route<dynamic> route(my_user.User user) =>
      MaterialPageRoute(builder: (context) => BusListPage(user: user));

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late final FlutterBackgroundService flutterBackgroundService;

  @override
  void initState() {
    super.initState();
    // initBackground();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> initBackground() async {
  //   final service = FlutterBackgroundService();

  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     notificationChannelId,
  //     'Background services for where is my bus app!',
  //     description: 'This notification is used for finding buses near you.',
  //     importance: Importance.low,
  //   );

  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);

  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       onStart: onStart,
  //       autoStart: true, // Auto-start service upon initialization
  //       isForegroundMode: false,
  //       notificationChannelId: notificationChannelId,
  //       initialNotificationTitle: 'Background service for where is my bus?',
  //       initialNotificationContent: 'Finding buses near you!',
  //       foregroundServiceNotificationId: NOTIFICATION_ID,
  //     ),
  //     iosConfiguration: IosConfiguration(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 238, 241),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSignOutSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    Loginpage.route(),
                    (route) => false,
                  );
                }
              },
            ),
            BlocListener<LocationsBloc, LocationsState>(
              listener: (context, state) async {
                if (state is LocationEventFailed) {
                  showSnack(
                    context,
                    "Location Event Failed",
                    "Failed to update Location! Please check internet",
                    ContentType.failure,
                    AppPallete.errorColor,
                  );
                } else if (state is UpdateLocationSuccess) {
                  // showSnack(
                  //   context,
                  //   "Update Location Success",
                  //   "Cool!",
                  //   ContentType.failure,
                  //   AppPallete.success,
                  // );
                } else if (state is AuthSignOutEvent) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    Loginpage.route(),
                    (route) => false,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
              if (state is LocationsInitial || state is LocationLoading) {
                serviceLocator<LocationsBloc>().add(GetBusLocationsEvent());
                return const LoadingScreen();
              } else if (state is GetCurrentBusLocationsSuccess) {
                widget.busStreamCache = state.buses;
                return BusList(
                  busStream: state.buses,
                  permission: true,
                );
              } else if (state is GetCurrentBusLocationsFailed) {
                return BusList(
                  busStream: widget.busStreamCache,
                  permission: true,
                );
              } else if (state is LocationPermissionDenied) {
                return RequestPermissionPopup(context: context);
              } else {
                return BusList(
                  busStream: widget.busStreamCache,
                  permission: true,
                ); // Default state handling
              }
            },
          ),
        ),
      ),
    );
  }
}
