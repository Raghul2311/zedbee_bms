import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HighlightText extends StatelessWidget {
  final String fullText;
  final String query;
  final Color normalColor;
  final TextStyle? textStyle;
  final int maxLines;
  final TextOverflow overflow;

  const HighlightText({
    super.key,
    required this.fullText,
    required this.query,
    this.normalColor = Colors.black,
    this.textStyle,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = ScreenUtil().screenWidth >= 600;

    final baseStyle =
        textStyle ??
        TextStyle(color: normalColor, fontSize: isTablet ? 4.sp : 10.sp);

    if (query.isEmpty ||
        !fullText.toLowerCase().contains(query.toLowerCase())) {
      return Text(
        fullText,
        style: baseStyle,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: false,
      );
    }

    final lowerText = fullText.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);
    final endIndex = startIndex + query.length;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: fullText.substring(0, startIndex), style: baseStyle),
          TextSpan(
            text: fullText.substring(startIndex, endIndex),
            style: baseStyle.copyWith(
              backgroundColor: Colors.yellow,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(text: fullText.substring(endIndex), style: baseStyle),
        ],
      ),
      maxLines: maxLines,
      overflow: overflow,
      softWrap: false,
    );
  }
}
