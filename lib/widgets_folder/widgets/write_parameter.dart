import 'package:flutter/material.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class WriteParameter extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController? controller;
  final VoidCallback? onPressed;

  const WriteParameter({
    super.key,
    required this.label,
    required this.unit,
    this.controller,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textColor1(context),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppColors.textColor1(context)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          unit,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor1(context),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Set"),
        ),
      ],
    );
  }
}
