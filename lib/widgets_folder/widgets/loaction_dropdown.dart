import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double width;
  final double height;

  const LocationDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.width = 90,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    /// Remove duplicates safely
    final uniqueItems = items.toSet().toList();

    /// Ensure selected value exists in list
    final safeValue = uniqueItems.contains(value) ? value : null;

    return SizedBox(
      width: width.w,
      height: height.h,
      child: DropdownButtonFormField<String>(
        initialValue: safeValue,
        isExpanded: true,
        dropdownColor: Colors.white,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),

        decoration: _inputDecoration(),

        style: TextStyle(
          fontSize: 4.sp,
                                      color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.w700,
        ),

        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 4.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),

        items: uniqueItems
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),

        onChanged: onChanged,
      ),
    );
  }

  /// Input Decoration Method (Clean & Reusable)
  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),

      contentPadding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 8.h,
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
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
    );
  }
}