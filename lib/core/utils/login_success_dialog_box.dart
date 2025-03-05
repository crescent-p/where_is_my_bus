import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';

BorderSide a =
    const BorderSide(color: Colors.red, width: 2.0); // Starting border
BorderSide b =
    const BorderSide(color: Colors.blue, width: 6.0); // Ending border
double t = 0.5; // Interpolation factor (0.0 to 1.0)

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/animations/success.json',
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
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide.lerp(a, b, t), // Lerp the top border
                  ),
                ),
                child: const Text(
                  "Ok....Lemme try again :)",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.textColor),
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
