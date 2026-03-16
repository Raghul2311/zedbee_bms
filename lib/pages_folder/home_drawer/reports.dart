import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String? selectedDevice;
  String? selectedDate;
  String? selectedEquipment;
  String? selectedParameter;

  // Sample device list
  List<String> deviceList = ["Device A", "Device B", "Device C", "Device D"];
  List<String> equipmentList = ["AHU", "VAV", "Chiller", "Actuator"];
  List<String> parameterList = [
    "Auto/Manual",
    "AHU Command",
    "AHU Status",
    "BTU",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Report Analysis",
          style: TextStyle(
            fontSize: 7.sp,
            color: AppColors.textColor1(context),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.amber, size: 8.w),
                SizedBox(width: 3.w),
                Text(
                  "Reporting Data",
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor1(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // DROPDOWNS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // device drop down
                _dropdown(
                  label: "Select Device",
                  value: selectedDevice,
                  items: deviceList,
                  onChanged: (v) => setState(() => selectedDevice = v),
                  context: context,
                ),

                _calendarDropdown(
                  label: "Select Date",
                  value: selectedDate,
                  onChanged: (v) {
                    setState(() => selectedDate = v);
                  },
                  context: context,
                ),
                // euipment drop down
                _dropdown(
                  label: "Select Equipment",
                  value: selectedEquipment,
                  items: equipmentList,
                  onChanged: (v) {
                    setState(() {
                      selectedEquipment = v;
                    });
                  },
                  context: context,
                ),
                // parameter drop down
                _dropdown(
                  label: "Select Parameter",
                  value: selectedParameter,
                  items: parameterList,
                  onChanged: (v) {
                    setState(() {
                      selectedParameter = v;
                    });
                  },
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // drop down widget......
  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 60.h,
      width: 80.w,
      child: DropdownButtonFormField<String?>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 5.sp, color: Colors.amber),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        initialValue: value,
        style: TextStyle(fontSize: 4.sp),
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(
              " Select All",
              style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
            ),
          ),
          ...items.map(
            (v) => DropdownMenuItem(
              value: v,
              child: Text(
                v,
                style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _calendarDropdown({
    required String label,
    required String? value,
    required Function(String?) onChanged,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 60.h,
      width: 80.w,
      child: GestureDetector(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDate: DateTime.now(),
          );

          if (picked != null) {
            String formatted = picked.toIso8601String().split("T")[0];
            onChanged(formatted);
          }
        },
        child: AbsorbPointer(
          child: DropdownButtonFormField<String?>(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: 5.sp, color: Colors.amber),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            initialValue: value,
            style: TextStyle(fontSize: 4.sp),
            items: [
              DropdownMenuItem(
                value: value,
                child: Text(
                  value ?? "Select Date",
                  style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
