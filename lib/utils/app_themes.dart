import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

enum AppTheme { system, light, dark, orange, green, violet, yellow }

final appThemeData = {
  AppTheme.system: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.lightgreen,
    primaryColorDark: AppColors.green,
    fontFamily: "Poppins",
    cardColor: AppColors.green,
    // cardColor: Color(0xff648995),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black, // text/icons
    ),
  ),
  AppTheme.light: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.darkBlue,
    primaryColorLight: AppColors.bgcolor,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black, // text/icons
    ),
  ),

  AppTheme.dark: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBlue,
    primaryColorLight: AppColors.darkBlue,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white, // appbar icons/title
    ),
  ),

  AppTheme.yellow: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.yellow,
    primaryColorLight: Colors.yellow,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(foregroundColor: Colors.black),
  ),

  AppTheme.orange: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.orange,
    primaryColorLight: Colors.deepOrange,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(foregroundColor: Colors.black),
  ),

  AppTheme.green: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.green,
    primaryColorLight: AppColors.green,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(foregroundColor: Colors.black),
  ),

  AppTheme.violet: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.violet,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(foregroundColor: Colors.black),
  ),
};
Color themePreviewColor(AppTheme theme) {
  switch (theme) {
    case AppTheme.system:
      return AppColors.lightgreen;
    case AppTheme.light:
      return AppColors.darkBlue;
    case AppTheme.dark:
      return AppColors.bgcolor;
    case AppTheme.orange:
      return AppColors.orange;
    case AppTheme.green:
      return AppColors.green;
    case AppTheme.violet:
      return AppColors.violet;
    case AppTheme.yellow:
      return AppColors.yellow;
  }
}
