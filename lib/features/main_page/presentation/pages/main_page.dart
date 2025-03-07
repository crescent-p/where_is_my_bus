import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as Rive;
import 'package:where_is_my_bus/core/entities/user.dart' as my_user;
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/rave_utils.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/loginPage.dart';
import 'package:where_is_my_bus/features/main_page/domain/entities/bus_user_coordinates.dart';
import 'package:where_is_my_bus/features/main_page/presentation/cubit/bottom_nav_cubit.dart';
import 'package:where_is_my_bus/features/locations/pages/bus_list_page.dart';
import 'package:where_is_my_bus/features/locations/pages/map_view.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/profile.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/social_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

const notificationChannelId = 'my_foreground';
bool backgroundStarted = false;

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
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      SocialPageWidget(
        items: {},
        user_name: widget.user.name,
      ),
      BusListPage(),
      ProfilePage(),
      MapScreen(),
    ];
    // initBackground();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late Rive.SMIBool homeClick;
  late Rive.SMIBool profileClick;
  late Rive.SMIBool locationClick;
  late Rive.SMIBool busClick;

  final PageController _pageController =
      PageController(); // Controller for PageView

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
                    // _pageController.jumpToPage(state); //No need to jump, animate instead
                    return PageView(
                      controller: _pageController,
                      children: pages,
                      onPageChanged: (index) {
                        context.read<BottomNavCubit>().changeTab(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
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
                  // context.read<BottomNavCubit>().changeTab(0); //No need to change cubit directly
                  _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease); //Animate page transition
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
                  // context.read<BottomNavCubit>().changeTab(1); //No need to change cubit directly
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease); //Animate page transition
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
                    profileClick.change(false);
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
                // context.read<BottomNavCubit>().changeTab(1); //No need to change cubit directly
                _pageController.animateToPage(2,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease); //Animate page transition
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

                // context.read<BottomNavCubit>().changeTab(1); //No need to change cubit directly
                _pageController.animateToPage(3,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease); //Animate page transition
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
