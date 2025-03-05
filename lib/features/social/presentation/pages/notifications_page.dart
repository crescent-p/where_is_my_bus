import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/notification_bloc/notification_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: OGS_THEME.white,
      body: SafeArea(
        child: Hero(
          tag: NOTIFICATIONTAG,
          child: Material(
            child: Container(
              margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
              height: screenHeight,
              width: screenWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "For me",
                        style: GoogleFonts.outfit(fontSize: 20),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 20, // Example height
                        child: VerticalDivider(
                          thickness: 1.0,
                          color: OGS_THEME.black,
                        ),
                      ),
                      Text(
                        "All",
                        style: GoogleFonts.outfit(fontSize: 20),
                      )
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationInitial) {
                          return SizedBox(
                            height: screenHeight,
                            width: screenWidth,
                            child: Lottie.asset(
                              'assets/animations/list_loading_animation.json',
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        } else if (state is NotificationFetchedState) {
                          return ListView.builder(
                            itemCount: state.notifications
                                .length, // Replace with the actual number of notifications
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.email),
                                subtitle: Text(
                                  "Message received on ${DateFormat('EEE, hh:mm a').format(state.notifications[index].createdAt)}",
                                  style: GoogleFonts.outfit(fontSize: 14),
                                ),
                                title: Text(
                                    style: GoogleFonts.outfit(fontSize: 14),
                                    state.notifications[index].message),
                                // trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  // Handle notification tap
                                },
                              );
                            },
                          );
                        } else {
                          return SizedBox(
                            height: screenHeight,
                            width: screenWidth,
                            child: Lottie.asset(
                              'assets/animations/list_loading_animation.json',
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
