// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class ProfileDetails extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final double? width;

  const ProfileDetails({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      bool isTablet = ScreenUtil().screenWidth >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet? 6.sp : 14.sp,
            color: AppColors.textColor1(context),
            fontWeight: FontWeight.w400,
          ),
        ),
         SizedBox(height: 15.h),

        // Info container
        Container(
          height: 55.h,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,size: 25.r,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
                 SizedBox(width: 30.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet? 5.sp : 12.sp,
                    color: AppColors.textColor1(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
