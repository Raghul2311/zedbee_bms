import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/app_themes.dart';

List<Color> getThemeGradient(AppTheme theme) {
  switch (theme) {
    case AppTheme.light:
      return [AppColors.darkgreen, AppColors.lightgreen.withOpacity(0.3)];
    // case AppTheme.light:
    //   return [Colors.green, AppColors.green.withOpacity(0.3)];
    case AppTheme.blue:
      return [AppColors.darkBlue, AppColors.lightBlue.withOpacity(0.3)];
    case AppTheme.dark:
      return [AppColors.green, AppColors.lightgreen.withOpacity(0.3)];
    case AppTheme.orange:
      return [AppColors.orange, Colors.deepOrange.withOpacity(0.3)];

    case AppTheme.green:
      return [const Color(0xff00A571), AppColors.lightgreen.withOpacity(0.10)];

    case AppTheme.violet:
      return [AppColors.violet, Colors.deepPurple];

    case AppTheme.yellow:
      return [AppColors.yellow, Colors.orangeAccent];
  }
}
