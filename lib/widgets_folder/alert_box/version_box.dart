import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class VersionBox extends StatelessWidget {
  const VersionBox({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = ScreenUtil().screenWidth >= 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "App Version",
        style: TextStyle(
          fontSize: isTablet ? 5.sp : 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Version: 1.0.1",
            style: TextStyle(
              fontSize: isTablet ? 8.sp : 16.sp,
              color: AppColors.textColor1(context),
            ),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   "Build: 231",
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: AppColors.textColor1(context),
          //   ),
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Close",
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: isTablet ? 4.sp : 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
