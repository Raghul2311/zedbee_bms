// lib/utils/internet_checker.dart
// ignore_for_file: use_build_context_synchronously
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class InternetChecker {
  static Future<bool> checkInternet(BuildContext context) async {
    final results = await Connectivity().checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

    if (result == ConnectivityResult.none) {
      bool isChecking = false;
      // Show Dialog if offline
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "No Internet Connection",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textColor1(context),
                  ),
                ),
                content: Text(
                  "Please connect to the internet to continue.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      setState(() => isChecking = true);
                      await Future.delayed(const Duration(seconds: 1));
                      final newResults = await Connectivity()
                          .checkConnectivity();
                      final newResult = newResults.isNotEmpty
                          ? newResults.first
                          : ConnectivityResult.none;

                      // Close ONLY when internet is restored
                      if (newResult != ConnectivityResult.none) {
                        Navigator.pop(context);
                      } else {
                        setState(() => isChecking = false);
                      }
                    },
                    child: isChecking
                        ? AppLoader()
                        : Text(
                            "Retry",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                  ),
                ],
              );
            },
          );
        },
      );
      return false;
    }

    return true; // Connected
  }
}
