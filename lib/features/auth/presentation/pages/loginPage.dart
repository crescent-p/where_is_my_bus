import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/core/utils/dialog_box.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/pages/bus_list_page.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GoogleSignIn googleSignIn = GoogleSignIn(clientId: clientId);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFailure) {
        return showMessageDialog(context, state.message);
      }
      if (state is AuthSuccess) {
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
            home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/login_background.jpg"))),
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 8,
                    child: SvgPicture.asset("assets/icons/login.svg"),
                  ),
                  const Spacer(),
                ],
              ),
              const Spacer(
                flex: 2,
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  context.read<AuthBloc>().add(AuthSignInEvent());
                },
                shape: ShapeBorder.lerp(null, null, 0.5),
              ),
              const Spacer(
                flex: 1,
              )
            ],
          ),
        ));
      }
    });
  }
}
