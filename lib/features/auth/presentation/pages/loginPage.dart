import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/login_error_dialog_box.dart';
import 'package:where_is_my_bus/core/utils/login_success_dialog_box.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/bus_list_page.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  static route() => MaterialPageRoute(builder: (context) => Loginpage());

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GoogleSignIn googleSignIn = GoogleSignIn(clientId: clientId);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFailure) {
        showErrorDialog(context);
      }
      if (state is AuthSuccess) {
        showSuccessDialog(context);
        Future.delayed(Durations.extralong4);
        context.read<LocationsBloc>().add(GetBusLocationsEvent());
        Navigator.pushAndRemoveUntil(
          context,
          BusListPage.route(state.user),
          (route) => false,
        );
      }
    }, builder: (BuildContext context, AuthState state) {
      if (state is AuthSuccess) {
        return BusListPage(user: state.user);
      } else {
        return MaterialApp(
          color:
              AppPallete.backgroundColor, // This is the overall app theme color
          debugShowCheckedModeBanner: false,
          home: Container(
            color: AppPallete
                .backgroundColor, // Set the background color of the Container
            child: Column(
              children: [
                const Spacer(flex: 1),
                Row(
                  children: [
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 8,
                      child: Lottie.asset("assets/animations/hi.json"),
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(flex: 2),
                SignInButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  Buttons.Google,
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthSignInEvent());
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        );
      }
    });
  }
}
