import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class TermsBox extends StatelessWidget {
  const TermsBox({super.key});

  @override
  Widget build(BuildContext context) {
      bool isTablet = ScreenUtil().screenWidth >= 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Terms & Conditions",
        style: TextStyle(
          fontSize: isTablet? 6.sp: 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          """
By using this application, you agree to the following terms and conditions:

1. You must use this app responsibly and in compliance with all applicable laws.
2. The app developer is not responsible for any loss or damage caused by misuse.
3. App features and content are subject to change without prior notice.
4. Do not attempt to modify, redistribute, or reverse-engineer the app.
5. Your continued use of the app signifies acceptance of any updates to these terms.

Please read these terms carefully before proceeding.
          """,
          style: TextStyle(
            fontSize: isTablet? 4.sp : 10.sp,
            color: AppColors.textColor1(context),
            height: 1.5,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Close",
            style: TextStyle(color: Colors.red.shade500, fontSize: isTablet? 4.sp : 12.sp),
          ),
        ),
      ],
    );
  }
}
