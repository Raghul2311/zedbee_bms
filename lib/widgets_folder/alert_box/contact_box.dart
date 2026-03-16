import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class ContactBox extends StatelessWidget {
  const ContactBox({super.key});
  @override
  Widget build(BuildContext context) {
    bool isTablet = ScreenUtil().screenWidth >= 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Contact",
        style: TextStyle(
          fontSize: isTablet ? 6.sp : 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Theme.of(context).primaryColor,
              size: 25.r,
            ),
            title: Text(
              "+1 234 567 890",
              style: TextStyle(
                fontSize: isTablet ? 4.sp : 13.sp,
                color: AppColors.textColor1(context),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
            title: Text(
              "contact@example.com",
              style: TextStyle(
                fontSize: isTablet ? 4.sp : 13.sp,
                color: AppColors.textColor1(context),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Close",
            style: TextStyle(
              color: Colors.red.shade500,
              fontSize: isTablet ? 4.sp : 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}
