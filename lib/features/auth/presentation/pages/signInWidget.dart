import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lottie/lottie.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/frostedGlassBox.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color:
            AppPallete.backgroundColor, // This is the overall app theme color
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/login_background.png"),
              fit: BoxFit.fitHeight,
            )),
            alignment: Alignment.center,
            child: FrostedGlassBox(
              theWidth: MediaQuery.of(context).size.width / 1.1,
              theHeight: MediaQuery.of(context).size.height / 1.2,
              theChild: Column(
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
          ),
        ));
  }
}

// Column(
//           children: [
//             const Spacer(flex: 1),
//             Row(
//               children: [
//                 const Spacer(flex: 1),
//                 Expanded(
//                   flex: 8,
//                   child: Lottie.asset("assets/animations/hi.json"),
//                 ),
//                 const Spacer(),
//               ],
//             ),
//             const Spacer(flex: 3),
//             SignInButton(
//               padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//               Buttons.Google,
//               onPressed: () {
//                 context.read<AuthBloc>().add(AuthSignInEvent());
//               },
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             const Spacer(flex: 1),
//           ],
//         ),
