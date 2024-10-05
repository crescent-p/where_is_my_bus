import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';

BorderSide a =
    const BorderSide(color: AppPallete.errorColor, width: 2.0); // Starting border
BorderSide b =
    const BorderSide(color: AppPallete.errorColor, width: 6.0); // Ending border
double t = 0.2; // Interpolation factor (0.0 to 1.0)

void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/animations/login_error.json',
              width: 250, // Set desired width
              height: 250, // Set desired height
              fit: BoxFit.cover,
              repeat: false,
            ),
            const Text(
              "Login Failed!",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.errorColor),
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppPallete.errorColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    top: BorderSide.lerp(a, b, t),
                    bottom: BorderSide.lerp(a, b, t),
                    left: BorderSide.lerp(a, b, t),
                    right: BorderSide.lerp(a, b, t), // Lerp the top border
                  ),
                ),
                child: const Text(
                  "Ok....Lemme try again :)",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.whiteColor),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
