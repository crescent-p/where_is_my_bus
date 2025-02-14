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
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/main_page/presentation/cubit/bottom_nav_cubit.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/bus_list_page.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/profile.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/request_permission.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/social_page.dart';
import 'package:where_is_my_bus/features/main_page/presentation/widgets/bus_list.dart';
import 'package:where_is_my_bus/init_dependencies.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

const notificationChannelId = 'my_foreground';
bool backgroundStarted = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Future<void> onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if ((DateTime.now().millisecondsSinceEpoch / 1000) %
//             UPDATE_LOCATION_INTERVAL ==
//         0) {
//       service.invoke("set_location", {'value': 'myvalue'});
//     }
//   });
// }

class MainPage extends StatefulWidget {
  final my_user.User user;
  List<BusCoordinates> busStreamCache = [];
  MainPage({super.key, required this.user});

  static Route<dynamic> route(my_user.User user) =>
      MaterialPageRoute(builder: (context) => MainPage(user: user));

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // late final FlutterBackgroundService flutterBackgroundService;
  final List<Widget> pages = [
    SocialPage(),
    ProfilePage(),
    BusListPage(),
  ];
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                serviceLocator<AuthBloc>().add(AuthSignOutEvent());
              },
              icon: const Icon(
                Icons.logout,
                color: AppPallete.whiteColor,
              ))
        ],
        backgroundColor: AppPallete.gradient2,
        title: Text(
          _getGreeting(),
          style: TextStyle(
            color: AppPallete.whiteColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
        ],
        child: BlocBuilder<BottomNavCubit, int>(
          builder: (context, state) {
            return pages[state];
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state,
            onTap: (index) => context.read<BottomNavCubit>().changeTab(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Bus'),
            ],
          );
        },
      ),
    );
  }
}

String _getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}
