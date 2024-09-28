import 'package:flutter/material.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';

class AppTheme {
  //creates a function that returns OutlineInputBorder
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: color,
        ),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
      chipTheme: ChipThemeData(
        backgroundColor: AppPallete.backgroundColor,
        disabledColor: AppPallete.backgroundColor,
        selectedColor: AppPallete.gradient1,
        secondarySelectedColor: AppPallete.backgroundColor,
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(
          color: AppPallete.greyColor,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppPallete.greyColor,
        ),
        brightness: Brightness.dark,
      ),
      appBarTheme:
          const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(30),
        border: _border(),
        focusedBorder: _border(AppPallete.gradient1),
        hintStyle: const TextStyle(
          color: AppPallete.greyColor,
        ),
      ));
}
