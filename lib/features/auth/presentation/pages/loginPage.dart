import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:where_is_my_bus/core/secrets/secrets.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/core/utils/login_error_dialog_box.dart';
import 'package:where_is_my_bus/core/utils/login_success_dialog_box.dart';
import 'package:where_is_my_bus/core/utils/snack_bar.dart';
import 'package:where_is_my_bus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:where_is_my_bus/features/auth/presentation/pages/signInWidget.dart';
import 'package:where_is_my_bus/features/main_page/presentation/pages/main_page.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  static route() => MaterialPageRoute(builder: (context) => const Loginpage());

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GoogleSignIn googleSignIn = GoogleSignIn(clientId: clientId);

  @override
  void initState() {
    super.initState();
    if (_handlePermission(context) == 1) {
      showErrorDialog(context,
          callFunction: true, message: "Please enable Location Notifications!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var permission = Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnack(
            context,
            "Location Permission Denied",
            "Please enable Locations Permission in settings",
            ContentType.failure,
            AppPallete.errorColor);
      }
    }
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFailure) {
        showErrorDialog(context);
      }
      if (state is AuthSuccess) {
        showSuccessDialog(context);
        Future.delayed(Durations.extralong4);
        // context.read<LocationsBloc>().add(GetBusLocationsEvent());
        Navigator.pushAndRemoveUntil(
          context,
          MainPage.route(state.user),
          (route) => false,
        );
      }
    }, builder: (BuildContext context, AuthState state) {
      if (state is AuthSuccess) {
        return MainPage(user: state.user);
      } else {
        return const LoginPageWidget();
      }
    });
  }
}

Future<int> _handlePermission(BuildContext context) async {
  // 1 success;
  // Step 1: Request foreground location permission
  PermissionStatus foregroundStatus =
      await Permission.locationWhenInUse.request();

  if (foregroundStatus == PermissionStatus.granted) {
    // Step 2: Request background location permission after foreground permission is granted
    // PermissionStatus backgroundStatus =
    //     await Permission.locationAlways.request();

    // if (backgroundStatus == PermissionStatus.granted) {
    //   return 1;
    // } else {
    //   return 0;
    // }
    return 1;
  } else {
    return 0;
  }
}
