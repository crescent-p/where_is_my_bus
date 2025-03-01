import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rive/rive.dart' as Rive;
import 'package:where_is_my_bus/core/entities/user.dart' as my_user;
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/rave_utils.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/presentation/cubit/bottom_nav_cubit.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/bus_list_page.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/social_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

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
    SocailPageWidget(items: {}),
    // ProfilePage(),
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

  late Rive.SMIBool homeClick;
  late Rive.SMIBool profileClick;
  late Rive.SMIBool locationClick;
  late Rive.SMIBool busClick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              // Rotating 90 degrees
              MultiBlocListener(
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: OGS_THEME.black,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                {
                  locationClick.change(false);
                  profileClick.change(false);
                  busClick.change(false);
                  homeClick.change(true);
                  context.read<BottomNavCubit>().changeTab(0);
                }
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Rive.RiveAnimation.asset(
                  "assets/bottom_nav_icons/animated_icon_set_-_1_color.riv",
                  artboard: "HOME",
                  onInit: (artboard) {
                    Rive.StateMachineController controller =
                        RiveUtils.getStateMachineController(
                      artboard,
                      stateMachineName: "HOME_interactivity",
                    );
                    homeClick = controller.findSMI("active") as Rive.SMIBool;
                    homeClick.change(true);
                    // context.read<BottomNavCubit>().changeTab(1);
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                {
                  homeClick.change(false);
                  busClick.change(false);
                  locationClick.change(false);
                  profileClick.change(true);
                  context.read<BottomNavCubit>().changeTab(1);
                }
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Rive.RiveAnimation.asset(
                  "assets/bottom_nav_icons/animated_icon_set_-_1_color.riv",
                  artboard: "SEARCH",
                  onInit: (artboard) {
                    Rive.StateMachineController controller =
                        RiveUtils.getStateMachineController(artboard,
                            stateMachineName: "SEARCH_Interactivity");
                    // defaul = controller.findSMI("homeDefault");
                    profileClick = controller.findSMI("active") as Rive.SMIBool;
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                profileClick.change(false);
                homeClick.change(false);
                locationClick.change(false);
                busClick.change(true);

                context.read<BottomNavCubit>().changeTab(1);
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Rive.RiveAnimation.asset(
                  artboard: "USER",
                  "assets/bottom_nav_icons/animated_icon_set_-_1_color.riv",
                  onInit: (artboard) {
                    Rive.StateMachineController controller =
                        RiveUtils.getStateMachineController(artboard,
                            stateMachineName: "USER_Interactivity");
                    busClick = controller.findSMI("active") as Rive.SMIBool;
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                busClick.change(false);
                profileClick.change(false);
                homeClick.change(false);
                locationClick.change(true);

                context.read<BottomNavCubit>().changeTab(1);
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Rive.RiveAnimation.asset(
                  "assets/bottom_nav_icons/animated_icon_set_-_1_color.riv",
                  artboard: "LIKE/STAR",
                  onInit: (artboard) {
                    Rive.StateMachineController controller =
                        RiveUtils.getStateMachineController(artboard,
                            stateMachineName: "STAR_Interactivity");
                    locationClick =
                        controller.findSMI("active") as Rive.SMIBool;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




      // BlocBuilder<BottomNavCubit, int>(builder: (context, state) {
      //     return Container(
      //       height: 100,
      //       width: 300,
      //       padding: EdgeInsets.all(2),
      //       margin: EdgeInsets.symmetric(horizontal: 24),
      //       decoration: BoxDecoration(
      //         // color: const Color.fromARGB(0, 27, 12, 237),
      //         borderRadius: BorderRadius.all(Radius.circular(24)),
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           GestureDetector(
      //             onTap: () => context.read<BottomNavCubit>().changeTab(0),
      //             child: SizedBox(
      //               height: 100,
      //               width: 100,
      //               child: Rive.RiveAnimation.asset(
      //                 "assets/bottom_nav_icons/home_animated_icon.riv",
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //           GestureDetector(
      //             onTap: () => context.read<BottomNavCubit>().changeTab(1),
      //             child: SizedBox(
      //               height: 100,
      //               width: 100,
      //               child: Rive.RiveAnimation.asset(
      //                 "assets/bottom_nav_icons/profile_animated_icon.riv",
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //           // Uncomment and add more icons as needed
      //           // GestureDetector(
      //           //   onTap: () => context.read<BottomNavCubit>().changeTab(2),
      //           //   child: Rive.RiveAnimation.asset(
      //           //     "assets/bottom_nav_icons/location_animated_icon.riv",
      //           //     fit: BoxFit.cover,
      //           //   ),
      //           // ),
      //           // GestureDetector(
      //           //   onTap: () => context.read<BottomNavCubit>().changeTab(3),
      //           //   child: Rive.RiveAnimation.asset(
      //           //     "assets/bottom_nav_icons/profile_animated_icon.riv",
      //           //     fit: BoxFit.cover,
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //     );
      //   }));