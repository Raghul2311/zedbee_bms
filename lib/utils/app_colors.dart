import 'package:flutter/material.dart';

class AppColors {
  // blue color
  static const Color darkBlue = Color(0xff377DFF);
  static const Color lightBlue = Color(0xff5590ff);
  static const Color yellow = Colors.yellow;
  static const Color orange = Color(0XffFF8D21);
  static const Color green = Color(0xff00DC97);
  static const Color violet = Color(0xffA569BD);
  static const Color darkgreen = Color(0xff002D1F);
  static const Color lightgreen = Color(0xff009163);
  static const Color darkbacground = Color(0xff001F0C);
  // Text color
  static const Color lightText = Color(0xFF187bcd);

  // background color
  static const Color bgcolor = Color(0xFF1167b1);
  // black and while color
  static Color textColor1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color textColor2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
  }

  static Color conatinerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff161719)
        : Color(0xffF2F6F8);
  }

  static Color conatinerColor2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xffF2F6F8)
        : Color(0xff161719);
  }

  static Color textColor3(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xffF2F6F8)
        : Color(0xff2F2F2F);
  }
}
