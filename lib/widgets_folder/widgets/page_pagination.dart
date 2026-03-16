import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / itemsPerPage).ceil();

    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// PREVIOUS BUTTON
          IconButton(padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 8.sp,
            ),
            onPressed: currentPage == 0
                ? null
                : () => onPageChanged(currentPage - 1),
          ),
      
          /// PAGE INFO
          Text(
            "Page ${currentPage + 1} of $totalPages",
            style: TextStyle(
              fontSize: 4.sp,
              color: AppColors.lightgreen,
            ),
          ),
      
          /// NEXT BUTTON
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 8.sp,
            ),
            onPressed: currentPage >= totalPages - 1
                ? null
                : () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }
}