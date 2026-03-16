import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class DeviceTextfield extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSearchPressed;

  const DeviceTextfield({
    super.key,
    required this.hint,
    required this.onChanged,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextFormField(
        style: TextStyle(fontSize: 5.sp, color: AppColors.textColor2(context)),
        cursorColor: AppColors.textColor2(context),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 4.sp,
            color: AppColors.textColor2(context),
          ),
          filled: true,
          fillColor: const Color(0xff8FD9C8).withOpacity(0.3),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),

          // SEARCH BUTTON INSIDE FIELD
          suffixIcon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  AppColors.lightgreen,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12.r),
                  ),
                ),
              ),
              onPressed: onSearchPressed,
              child: Text(
                "Search",
                style: TextStyle(
                  fontSize: 3.5.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          suffixIconConstraints: BoxConstraints(
            minHeight: 40.h,
            minWidth: 30.w,
          ),
        ),
        onChanged: (value) => onChanged(value.trim().toLowerCase()),
      ),
    );
  }
}
