import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

// Circular Loader widget
class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CircularProgressIndicator(
      strokeWidth: size.width * 0.002,
      color: AppColors.textColor2(context),
    );
  }
}

