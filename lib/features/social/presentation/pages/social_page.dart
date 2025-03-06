import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
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
  final String user_name;
  const SocialPageWidget(
      {Key? key, required this.items, required this.user_name})
      : super(key: key);

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
        backgroundColor: Colors.white,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      foregroundImage: NetworkImage(
                        "https://scontent.fccj2-2.fna.fbcdn.net/v/t1.6435-9/32294281_226822181400639_4070971510129426432_n.png?_nc_cat=101&ccb=1-7&_nc_sid=127cfc&_nc_ohc=EfYA6wu9uVsQ7kNvgHoPMcr&_nc_oc=AdhQ4sBFKjBJBHQEu-FsYdlI0G3pHrzKRMa8jP-z6isEGVbFtUC-XcPMv04Nb3m3TkbyuecaOMqEKzVGINomZaex&_nc_zt=23&_nc_ht=scontent.fccj2-2.fna&_nc_gid=A5tkRPnUPd_0t95iIRjYhvS&oh=00_AYA4ITfXGO3hiPmnGObSkE03sWTEVYllVvV33A7S8rc8IQ&oe=67EA7F61",
                      ),
                      radius: 25,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(2.0, 0.0),
                                  blurRadius: 100.0,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            widget.user_name,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(2.0, 0.0),
                                  blurRadius: 100.0,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getGreeting(),
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          color: OGS_THEME.yellow,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                      width: 60,
                      child: Rive.RiveAnimation.asset(
                        "assets/animations/cloud_and_sun.riv",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          _buildNotificationButton(context),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: OGS_THEME.offWhite,
            boxShadow: [
              BoxShadow(
                color: OGS_THEME.yellow,
                blurRadius: 10,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.yellow.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            serviceLocator<NotificationBloc>().add(GetNotificationEvent());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          },
          child: Hero(
            tag: NOTIFICATIONTAG,
            child: SizedBox(
              height: 40,
              width: 40,
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
    );
  }

  Widget _buildSearchBar(BuildContext context, double screenWidth) {
    return Container(
      color: OGS_THEME.white,
      width: screenWidth,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
          SizedBox(width: screenWidth * 0.05),
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
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: OGS_THEME.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "View All",
                style: GoogleFonts.outfit(fontSize: 15, color: OGS_THEME.black),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          color: OGS_THEME.white,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            height: 177,
            width: 379,
            color: OGS_THEME.white,
            child: Image.asset(
              "assets/pngs/facilities_near_you.png",
              color: OGS_THEME.black,
              fit: BoxFit.fill,
            ),
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
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            title,
            style:
                GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                        blurRadius: 13,
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
                              child: CachedNetworkImage(
                                imageUrl: item.lowResImageUrl!,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
