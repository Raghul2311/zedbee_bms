import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

enum AppTheme { light, dark, blue, orange, green, violet, yellow }

final appThemeData = {
  AppTheme.light: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.green,
    primaryColorLight: AppColors.green,
    fontFamily: "Poppins",
    cardColor: Colors.white.withOpacity(0.3),
    // cardColor: Color(0xff648995),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black, // text/icons
    ),
  ),

  AppTheme.dark: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.green,
    cardColor: Color(0xff001F0C),
    primaryColorDark: AppColors.darkbacground,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: AppColors.darkgreen,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white, // appbar icons/title
    ),
  ),

  // AppTheme.light: ThemeData(
  //   useMaterial3: true,
  //   brightness: Brightness.light,
  //   primaryColor: AppColors.darkgreen,
  //   primaryColorLight: AppColors.darkgreen,
  //   fontFamily: "Poppins",
  //   scaffoldBackgroundColor: Colors.white,
  //   appBarTheme: const AppBarTheme(
  //     foregroundColor: Colors.black, // text/icons
  //   ),
  // ),
  AppTheme.blue: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.darkBlue,
    primaryColorLight: AppColors.lightBlue,
    cardColor: Colors.white.withOpacity(0.3),
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black, // text/icons
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
    case AppTheme.light:
      return AppColors.lightgreen;
    // case AppTheme.light:
    //   return AppColors.darkBlue;
    case AppTheme.dark:
      return AppColors.darkgreen;
    case AppTheme.blue:
      return AppColors.darkBlue;
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
