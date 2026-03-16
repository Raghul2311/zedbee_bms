// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class SettingSection extends StatelessWidget {
  final String title;
  final Widget dialog;

  const SettingSection({Key? key, required this.title, required this.dialog})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tappable container
        InkWell(
          onTap: () {
            showDialog(context: context, builder: (context) => dialog);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 65,
            width: 150,
            decoration: BoxDecoration(
              color: AppColors.textColor1(context).withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.textColor1(context).withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label text
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
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
