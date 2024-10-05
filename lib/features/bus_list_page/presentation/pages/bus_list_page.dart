import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as my_user;
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/widgets/bus_list.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (DateTime.now().second % 5 == 0) {
      service.invoke("set_location", {'value': 'myvalue'});
    }
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });
}

class BusListPage extends StatefulWidget {
  final my_user.User user;
  const BusListPage({super.key, required this.user});
  static route(my_user.User user) =>
      MaterialPageRoute(builder: (context) => BusListPage(user: user));
  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late final FlutterBackgroundService service;
  @override
  void initState() {
    super.initState();
    _handlePermission(context);
    initBackground();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget previousWidget = Container();
  @override
  Widget build(BuildContext context) {
    service = FlutterBackgroundService();
    service.startService();
    service.on("set_location").listen((data) {
      if (data != null) {
        serviceLocator<LocationsBloc>().add(UpdateCurrentLocationEvent());
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 238, 241),
      body: BlocListener<LocationsBloc, LocationsState>(
        listener: (context, state) {
          if (state is LocationEventFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is UpdateLocationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            return;
          }
        },
        child: BlocBuilder<LocationsBloc, LocationsState>(
          builder: (context, state) {
            if (state is LocationsInitial || state is LocationLoading) {
              previousWidget = const LoadingIndicator(
                  indicatorType: Indicator.cubeTransition);
              return previousWidget;
            } else if (state is GetCurrentBusLocationsSuccess) {
              previousWidget = BusList(busStream: state.buses);
              return previousWidget;
            } else if (state is GetCurrentBusLocationsFailed) {
              previousWidget = Center(child: Text("Failed to fetch data"));
              return previousWidget;
            } else {
              return previousWidget;
            }
          },
        ),
      ),
    );
  }
}

Future<void> _handlePermission(BuildContext context) async {
  // Step 1: Request foreground location permission
  PermissionStatus foregroundStatus =
      await Permission.locationWhenInUse.request();

  if (foregroundStatus == PermissionStatus.granted) {
    // Step 2: Request background location permission after foreground permission is granted
    PermissionStatus backgroundStatus =
        await Permission.locationAlways.request();

    if (backgroundStatus == PermissionStatus.granted) {
      print("Background location permission granted.");
    } else {
      print("Background location permission denied.");
    }
  } else {
    print("Foreground location permission denied.");
  }
}

Future<void> initBackground() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,

      notificationChannelId:
          notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(),
  );
}
