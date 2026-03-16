
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/local_storage.dart';

class MessageAlert extends StatelessWidget {
  final String title; // Alert box title
  final String message; // Alert box content
  final String confirmText; // Text for confirm button
  final String cancelText; // Text for cancel button
  final VoidCallback onConfirm; // Action when confirm pressed
  final VoidCallback? onCancel; // Optional custom cancel action

  const MessageAlert({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = "Yes",
    this.cancelText = "No",
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = ScreenUtil().screenWidth >= 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          fontSize: isTablet ? 6.sp : 17.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: isTablet ? 4.sp : 12.sp,
          color: AppColors.textColor1(context),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          child: Text(
            cancelText,
            style: TextStyle(
              color: AppColors.textColor1(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            onConfirm();
            // clear function ......
            await LocalStorage.clearDomainKey();
            await LocalStorage.clearFloorId();
            await LocalStorage.clearRoomId();
            await LocalStorage.clearLocationData();
            await LocalStorage.clearLocationFilters();

            debugPrint("data cleared");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmText,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
