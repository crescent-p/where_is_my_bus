import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frosted_glass_effect/frosted_glass_effect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as Rive;
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/rave_utils.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/mini_posts_bloc/mini_posts_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/notification_bloc/notification_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/coming_soon.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/notifications_page.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/post_page.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/search_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class SocialPageWidget extends StatefulWidget {
  final Map<String, List<MiniPost>> items;
  const SocialPageWidget({Key? key, required this.items}) : super(key: key);

  static String routeName = 'socail_page';
  static String routePath = '/socailPage';

  @override
  State<SocialPageWidget> createState() => _SocialPageWidgetState();
}

class _SocialPageWidgetState extends State<SocialPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Rive.SMIBool notificationIcon;

  @override
  void initState() {
    super.initState();
    context.read<MiniPostsBloc>().add(GetMiniPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: BlocBuilder<MiniPostsBloc, MiniPostsState>(
                  builder: (context, state) {
                    if (state is MiniPostsLoadedState) {
                      Map<String, List<MiniPost>> posts = state.posts;
                      List<Widget> widgets = posts.entries.map((entry) {
                        return SafeArea(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              _buildSection(
                                context,
                                title: entry.key,
                                items: entry.value,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      }).toList();

                      return SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ComingSoon(),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildProfileHeader(context, screenWidth),
                              SizedBox(height: screenHeight * 0.01),
                              _buildSearchBar(context, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildFacilitiesNearYou(context),
                              const SizedBox(
                                height: 10,
                              ),
                              ...widgets,
                            ],
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: screenHeight,
                      width: screenWidth,
                      child: Lottie.asset(
                        'assets/animations/list_loading_animation.json',
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                  foregroundImage: NetworkImage(
                    "https://scontent.fccj2-2.fna.fbcdn.net/v/t1.6435-9/32294281_226822181400639_4070971510129426432_n.png?_nc_cat=101&ccb=1-7&_nc_sid=127cfc&_nc_ohc=EfYA6wu9uVsQ7kNvgHoPMcr&_nc_oc=AdhQ4sBFKjBJBHQEu-FsYdlI0G3pHrzKRMa8jP-z6isEGVbFtUC-XcPMv04Nb3m3TkbyuecaOMqEKzVGINomZaex&_nc_zt=23&_nc_ht=scontent.fccj2-2.fna&_nc_gid=A5tkRPnUPd_0t95iIRjYhvS&oh=00_AYA4ITfXGO3hiPmnGObSkE03sWTEVYllVvV33A7S8rc8IQ&oe=67EA7F61",
                  ),
                  radius: 30,
                ),
                SizedBox(width: screenWidth * 0.03),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hello,',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(5.0, 0.0),
                            blurRadius: 100.0,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      ' John!',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(5.0, 0.0),
                            blurRadius: 100.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: screenWidth * 0.3),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: OGS_THEME.yellow,
                            blurRadius: 10,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.4),
                            blurRadius: 100,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      height: 40,
                      width: 40,
                      child: GestureDetector(
                        onTap: () {
                          serviceLocator<NotificationBloc>()
                              .add(GetNotificationEvent());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsPage(),
                            ),
                          );
                        },
                        child: Hero(
                          tag: NOTIFICATIONTAG,
                          child: Rive.RiveAnimation.asset(
                            "assets/bottom_nav_icons/animated_icon_set_-_1_color.riv",
                            artboard: "BELL",
                            onInit: (artboard) {
                              Rive.StateMachineController controller =
                                  RiveUtils.getStateMachineController(
                                artboard,
                                stateMachineName: "BELL_Interactivity",
                              );
                              notificationIcon =
                                  controller.findSMI("active") as Rive.SMIBool;
                              notificationIcon.change(true);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    _getGreeting(),
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      color: OGS_THEME.yellow,
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 20,
                // ),
                const SizedBox(
                  height: 70,
                  width: 70,
                  child: Rive.RiveAnimation.asset(
                    "assets/animations/cloud_and_sun.riv",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, double screenWidth) {
    return SizedBox(
      width: screenWidth,
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: screenWidth / 1.35,
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            decoration: BoxDecoration(
              color: OGS_THEME.offWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  Hero(
                    tag: SEARCHPAGETAG,
                    child: Container(
                      height: 50,
                      width: screenWidth / 1.5,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: OGS_THEME.offWhite,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Explore Events and more...',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Icon(Icons.search),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.yellowAccent, OGS_THEME.yellow],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              color: OGS_THEME.yellow,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: OGS_THEME.yellow.withOpacity(0.6),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: const Icon(Icons.tune_sharp),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesNearYou(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Facilities near you',
              textAlign: TextAlign.start,
              style: GoogleFonts.outfit(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide.none,
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(OGS_THEME.white),
              ),
              child: Text(
                "View All",
                style: GoogleFonts.outfit(fontSize: 12, color: OGS_THEME.black),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          color: OGS_THEME.blue,
          margin: const EdgeInsets.all(5),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            height: 100,
            width: 500,
            child: Image.asset("assets/pngs/facilities_near_you.png"),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<MiniPost> items,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Events",
          style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPageWidget(postID: item.uuid),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.7,
                  height: 254.04,
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(255, 240, 234, 234),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 26,
                        offset: Offset(12, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: item.uuid,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.lowResImageUrl!,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.heading!,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.venue,
                            style: GoogleFonts.outfit(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }
}
