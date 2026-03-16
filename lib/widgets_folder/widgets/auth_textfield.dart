import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class AuthTextfield extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? hintText;
  final String? Function(String?)? validator;

  const AuthTextfield({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.hintText,
    this.validator,
  });

  @override
  State<AuthTextfield> createState() => _AuthTextfieldState();
}

class _AuthTextfieldState extends State<AuthTextfield> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 5.sp,
            color: AppColors.lightgreen,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          height: 60.h,
          child: TextFormField(
            controller: widget.controller,
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscure : false,
            validator: widget.validator,
            style: TextStyle(
              color: AppColors.darkgreen,
              fontSize: 5.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffE5E5E5),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppColors.darkgreen,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.white38 : Colors.black38,
                  width: 0.8.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(
                  color: AppColors.darkgreen,
                  width: 0.5.w,
                ),
              ),

              contentPadding: EdgeInsets.symmetric(
                vertical: 3.h,
                horizontal: 5.w,
              ),

              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 4.sp),

              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        size: 25.r,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
