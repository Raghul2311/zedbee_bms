import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/helper_function/equip_status.dart';

class EquipmentDetailsDialog extends StatelessWidget {
  final EquipmentModel equipmentModel;

  const EquipmentDetailsDialog({super.key, required this.equipmentModel});

  @override
  Widget build(BuildContext context) {
    // get last_updated_ts as string from rawData
    final lastUpdatedStr =
        equipmentModel.rawData['last_updated_ts']?.toString() ?? '0';

    final deviceStatus = DeviceStatusHelper.getStatusFromLastReporting(
      lastReportingTs: lastUpdatedStr,
      threshold: const Duration(hours: 2),
    );

    return Dialog(
      backgroundColor: AppColors.textColor1(context).withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Equipment Details",
              style: TextStyle(
                fontSize: 5.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Dynamic fields from rawData
            _detailRow(
              context,
              "Name",
              equipmentModel.rawData['equipment_name']?.toString() ?? '-',
            ),
            _detailRow(
              context,
              "Type",
              equipmentModel.rawData['equipment_type']?.toString() ?? '-',
            ),
            _detailRow(
              context,
              "Building",
              equipmentModel.rawData['building_name']?.toString() ?? '-',
            ),
            _detailRow(
              context,
              "Floor",
              equipmentModel.rawData['floor_name']?.toString() ?? '-',
            ),
            _detailRow(
              context,
              "Room",
              equipmentModel.rawData['room_name']?.toString() ?? '-',
            ),

            _detailStatusRow(context, deviceStatus),
            const SizedBox(height: 20),

            // Close Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$title:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textColor2(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Status row widget
Widget _detailStatusRow(BuildContext context, dynamic status) {
  final label = DeviceStatusHelper.statusText(status);
  final color = DeviceStatusHelper.statusColor(status);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "Status:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textColor2(context),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
