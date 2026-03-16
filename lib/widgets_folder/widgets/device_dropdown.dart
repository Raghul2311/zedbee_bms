// import 'package:bms/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class DeviceTypeDropdown extends StatelessWidget {
//   final String? selectedValue;
//   final ValueChanged<String?> onChanged;

//   const DeviceTypeDropdown({
//     super.key,
//     required this.selectedValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final List<String> deviceTypes = [
//       'All Device',
//       'AHU Device',
//       'VAV Device',
//       'Chiller',
//     ];

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Theme.of(context).primaryColor.withOpacity(0.5),
//           width: 1.5,
//         ),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedValue,
//           hint: Text(
//             "Select Device",
//             style: TextStyle(
//               fontSize: 16,
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//           isExpanded: true,
//           icon: Icon(
//             Icons.arrow_drop_down_rounded,
//             color: Theme.of(context).primaryColor,
//           ),
//           dropdownColor: Theme.of(context).scaffoldBackgroundColor,
//           style: TextStyle(
//             fontSize: 16,
//             color: AppColors.textColor1(context),
//           ),
//           onChanged: onChanged,
//           items: deviceTypes.map((type) {
//             return DropdownMenuItem<String>(
//               value: type,
//               child: Text(type),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
