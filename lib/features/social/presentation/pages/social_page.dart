import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frosted_glass_effect/frosted_glass_effect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as Rive;
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/rave_utils.dart';
import 'package:where_is_my_bus/features/social/data/data_source/social_remote_datasource.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/comments_bloc/comments_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/mini_posts_bloc/mini_posts_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/post_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class SocailPageWidget extends StatefulWidget {
  final Map<String, List<MiniPost>> items;
  const SocailPageWidget({Key? key, required this.items}) : super(key: key);

  static String routeName = 'socail_page';
  static String routePath = '/socailPage';

  @override
  State<SocailPageWidget> createState() => _SocailPageWidgetState();
}

late Rive.SMIBool notificationIcon;

class _SocailPageWidgetState extends State<SocailPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    context.read<MiniPostsBloc>().add(GetMiniPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BlocListener<MiniPostsBloc, MiniPostsState>(
                listener: (context, state) {
                  // if (state is SocialStateInitial) {
                  //   const CircularProgressIndicator();
                  // } else if (state is SocialStateLoaded) {
                  //   Map<String, List<MiniPost>> posts = state.posts;
                  //   Column(
                  //     children: posts.entries.map((entry) {
                  //       return _buildSection(
                  //         context,
                  //         title: entry.key,
                  //         items: entry.value,
                  //       );
                  //     }).toList(),
                  //   );
                  // }
                },
                child: BlocBuilder<MiniPostsBloc, MiniPostsState>(
                    builder: (context, state) {
                  if (state is MiniPostsLoadedState) {
                    Map<String, List<MiniPost>> posts = state.posts;
                    List<Widget> widgets = posts.entries.map((entry) {
                      return SafeArea(
                        child: Column(
                          children: [
                            //profile -> Hello, name , notification
                            //Goodmorning
                            //search bar
                            //facilities near you
                            // Profile section

                            const SizedBox(
                              height: 10,
                            ),
                            _buildSection(
                              context,
                              title: entry.key,
                              items: entry.value,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }).toList();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: const NetworkImage(
                                          "https://scontent.fccj2-2.fna.fbcdn.net/v/t1.6435-9/32294281_226822181400639_4070971510129426432_n.png?_nc_cat=101&ccb=1-7&_nc_sid=127cfc&_nc_ohc=EfYA6wu9uVsQ7kNvgHoPMcr&_nc_oc=AdhQ4sBFKjBJBHQEu-FsYdlI0G3pHrzKRMa8jP-z6isEGVbFtUC-XcPMv04Nb3m3TkbyuecaOMqEKzVGINomZaex&_nc_zt=23&_nc_ht=scontent.fccj2-2.fna&_nc_gid=A5tkRPnUPd_0t95iIRjYhvS&oh=00_AYA4ITfXGO3hiPmnGObSkE03sWTEVYllVvV33A7S8rc8IQ&oe=67EA7F61",
                                        ),
                                        radius: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Hello, John!',
                                        style: GoogleFonts.roboto(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(5.0, 0.0),
                                                blurRadius: 100.0,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                        width: 100,
                                      ),
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
                                                  color: Colors.yellow
                                                      .withOpacity(
                                                          0.4), // Glow color
                                                  blurRadius:
                                                      100, // How much it glows
                                                  spreadRadius:
                                                      30, // Spread of the glow
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 5,
                                            top: 5,
                                            height: 40,
                                            width: 40,
                                            child: Rive.RiveAnimation.asset(
                                              "assets/bottom_nav_icons/animated_icon_set_-_1_color.riv",
                                              artboard: "BELL",
                                              onInit: (artboard) {
                                                Rive.StateMachineController
                                                    controller = RiveUtils
                                                        .getStateMachineController(
                                                  artboard,
                                                  stateMachineName:
                                                      "BELL_Interactivity",
                                                );
                                                notificationIcon =
                                                    controller.findSMI("active")
                                                        as Rive.SMIBool;
                                                notificationIcon.change(true);
                                                // context.read<BottomNavCubit>().changeTab(1);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _getGreeting(),
                                        style: GoogleFonts.outfit(
                                            fontSize: 32,
                                            color: OGS_THEME.yellow),
                                      ),
                                      const SizedBox(
                                        height: 80,
                                        width: 150,
                                        child: Rive.RiveAnimation.asset(
                                          "assets/animations/cloud_and_sun.riv",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // const SizedBox(height: 5),
                          // Search bar
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 1.35,
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  decoration: BoxDecoration(
                                      color: OGS_THEME.offWhite,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: TextField(
                                    scrollPadding: EdgeInsets.all(10),
                                    decoration: InputDecoration(
                                      hintText: 'Explore Events and more...',
                                      hintStyle: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                      suffixIcon: Icon(Icons.search),
                                      contentPadding:
                                          EdgeInsets.only(right: 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.yellowAccent,
                                          OGS_THEME.yellow
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                      color: OGS_THEME.yellow,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              OGS_THEME.yellow.withOpacity(0.6),
                                          spreadRadius: 5,
                                          blurRadius: 20,
                                          offset: Offset(0, 0),
                                        ),
                                      ]),
                                  child: Icon(Icons.tune_sharp),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Facilities near you
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
                                  child: Text(
                                    "View All",
                                    style: GoogleFonts.outfit(
                                        fontSize: 12, color: OGS_THEME.white),
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                          OGS_THEME.blue))),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: OGS_THEME.blue,
                            margin: EdgeInsets.all(5),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              height: 100,
                              width: 500,
                              child: Image.asset(
                                  "assets/pngs/facilities_near_you.png"),
                            ),
                          ),
                          ...widgets
                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<MiniPost> items}) {
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
            physics: ClampingScrollPhysics(),
            // shrinkWrap: true,
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
                    width: 299.62,
                    height: 254.04,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      shadows: [
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
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.lowResImageUrl!,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "NIT Calicut",
                              style: GoogleFonts.outfit(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          ),
        )
      ],
    );
  }
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
