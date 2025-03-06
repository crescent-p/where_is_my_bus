import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OGS_THEME.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Image.asset(
                      "assets/pngs/profile_icon.png",
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Niara",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(5.0, 0.0),
                                blurRadius: 100.0,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Since 5 January 2003",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                offset: Offset(5.0, 0.0),
                                blurRadius: 100.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [OGS_THEME.blue, OGS_THEME.black],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Student NIT Calicut",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: OGS_THEME.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(5.0, 0.0),
                                    blurRadius: 100.0,
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Icon(
                          Icons.settings,
                          size: 40,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset("assets/pngs/profile_assets.png"),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "About me",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: OGS_THEME.black,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(5.0, 0.0),
                        blurRadius: 100.0,
                      ),
                    ]),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "I'm a highly motivated and results-oriented professional with a strong background in flutter, passionate about coding.",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: OGS_THEME.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Help & Support",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: OGS_THEME.black,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(5.0, 0.0),
                        blurRadius: 100.0,
                      ),
                    ]),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "If you have any questions or need assistance, please feel free to reach out to our support team at support@whereismybus.com.",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: OGS_THEME.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: 200,
                  margin: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [OGS_THEME.red, OGS_THEME.black],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            serviceLocator<AuthBloc>().add(AuthSignOutEvent()),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            "Sign Out",
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: OGS_THEME.white,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 50,
                        color: OGS_THEME.white,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
