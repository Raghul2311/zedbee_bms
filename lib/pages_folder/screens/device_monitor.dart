// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_state.dart';
import 'package:zedbee_bms/bloc_folder/bloc/roomlist_bloc/roomlist_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/roomlist_bloc/roomlist_event.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/floor_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/helper_function/date_time.dart';
import 'package:zedbee_bms/utils/helper_function/equip_status.dart';
import 'package:zedbee_bms/utils/helper_function/format_dynamicvalue.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/equ_roomdropdown.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class DeviceMonitor extends StatefulWidget {
  final FloorModel floorModel;
  final BuildingModel buildingModel;
  final UserModel userModel;

  const DeviceMonitor({
    super.key,
    required this.floorModel,
    required this.buildingModel,
    required this.userModel,
  });

  @override
  State<DeviceMonitor> createState() => _DeviceMonitorState();
}

class _DeviceMonitorState extends State<DeviceMonitor> {
  String selectedMenu = "Device Monitor";

  // show equipment id for equipment name ..............
  String getEquipmentDisplayName(Map<String, dynamic> rawData) {
    final name = rawData['equi_nam']?.toString().trim();
    if (name != null && name.isNotEmpty) return name;
    return rawData['equipment_id']?.toString() ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              EquipmentBloc(AuthService())..add(LoadEquipmentEvent()),
        ),
        BlocProvider(
          create: (_) => RoomListBloc(AuthService())..add(LoadRoomListEvent()),
        ),
      ],
      child: Container(
        height: 1.sw,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: BlocBuilder<EquipmentBloc, EquipmentState>(
          builder: (context, state) {
            if (state is EquipmentLoading) {
              return const Center(child: AppLoader());
            }
            if (state is EquipmentError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }

            if (state is EquipmentLoaded) {
              final equipments = [...state.filteredEquipments]
                ..sort((a, b) {
                  final nameA =
                      (a.rawData['equi_nam'] ?? a.rawData['device_id'] ?? '')
                          .toString()
                          .toLowerCase();

                  final nameB =
                      (b.rawData['equi_nam'] ?? b.rawData['device_id'] ?? '')
                          .toString()
                          .toLowerCase();

                  return nameA.compareTo(nameB);
                });

              if (equipments.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        "No devices found",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: AppColors.textColor2(context),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                });
              }
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                    child: Column(
                      children: [
                        // equipment and room drop down ..............
                        EquRoomdropdown(),
                        SizedBox(height: 30.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 40.h,
                                childAspectRatio: 1.9,
                              ),
                          itemCount: equipments.length,
                          itemBuilder: (context, index) {
                            final device = equipments[index];
                            final displayName = getEquipmentDisplayName(
                              device.rawData,
                            );

                            final lastUpdatedStr =
                                device.rawData['last_updated_ts']?.toString() ??
                                '0';

                            final deviceStatus =
                                DeviceStatusHelper.getStatusFromLastReporting(
                                  lastReportingTs: lastUpdatedStr,
                                  threshold: const Duration(hours: 2),
                                );

                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.conatinerColor2(
                                  context,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.9),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            displayName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 5.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    DeviceStatusHelper.containerColor(
                                                      deviceStatus,
                                                    ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w,
                                                    vertical: 4.h,
                                                  ),
                                                  child: Text(
                                                    DeviceStatusHelper.statusText(
                                                      deviceStatus,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          DeviceStatusHelper.statusColor(
                                                            deviceStatus,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 3.w),
                                            Tooltip(
                                              message: formatToIST(
                                                lastUpdatedStr,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.textColor1(
                                                  context,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.timer_rounded,
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                size: 20.r,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      flex: 2,
                                      child: DynamicFieldGrid(
                                        jsonData: device.rawData,
                                        equipmentName: displayName,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ================= INNER GRID VIEW =================

class DynamicFieldGrid extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final String? equipmentName;
  const DynamicFieldGrid({
    super.key,
    required this.jsonData,
    this.equipmentName,
  });

  @override
  State<DynamicFieldGrid> createState() => _DynamicFieldGridState();
}

class _DynamicFieldGridState extends State<DynamicFieldGrid> {
  final _authService = AuthService();

  // Helper Function to detect empty values ........
  bool _isEmptyValue(dynamic rawValue, String fieldName) {
    if (rawValue == null) return true;
    final formatted = FormatDynamicvalue.format(fieldName, rawValue).trim();
    return formatted.isEmpty ||
        formatted.toLowerCase() == 'null' ||
        formatted.toLowerCase() == 'n/a' ||
        formatted == '--';
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fields = [];

    final params = widget.jsonData['params'];
    if (params is List) {
      for (final p in params) {
        if (p is Map<String, dynamic>) {
          final rawName = p['name']?.toString();
          if (rawName == null) continue;
          // Empty parms are not shown ..........
          final rawValue = widget.jsonData[rawName];
          if (_isEmptyValue(rawValue, rawName)) continue;
          fields.add({
            'title': p['description'] ?? rawName,
            'name': rawName,
            'unit': p['unit'] ?? '',
          });
        }
      }
    }
    if (fields.isEmpty) {
      return Center(
        child: Text(
          "No parameters available",
          style: TextStyle(fontSize: 4.sp, color: Colors.grey),
        ),
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fields.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 14,
        ),
        itemBuilder: (context, index) {
          final field = fields[index];
          final rawValue = widget.jsonData[field['name']];
          final value = FormatDynamicvalue.format(
            field['name'],
            rawValue,
            equipmentName: widget.equipmentName,
          );
          final valueColor = FormatDynamicvalue.color(
            context,
            field['name'],
            rawValue,
            equipmentName: widget.equipmentName,
          );

          // control ON/OFF status ................
          Widget valueWidget;

          final fieldName = field['name'].toString().toLowerCase();
          // VFS field will show toggle switch
          if (fieldName == 'vfs') {
            valueWidget = Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 5.sp,
                    fontWeight: FontWeight.bold,
                    color: value == 'ON' || value == '1'
                        ? Theme.of(context).primaryColor
                        : Colors.red,
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: value == 'ON',
                    activeThumbColor: Theme.of(context).primaryColor,
                    inactiveThumbColor: Colors.red,
                    onChanged: (bool newValue) async {
                      final command = newValue ? "1" : "0";
                      final deviceId =
                          widget.jsonData['device_id']?.toString() ?? '';
                      final equipmentId =
                          widget.jsonData['equipment_id']?.toString() ?? '';
                      final deviceType =
                          widget.jsonData['equipment_nam']?.toString() ?? '';

                      // optimistic ui update
                      widget.jsonData[field['name']] = command;
                      setState(() {});
                      final success = await _authService.sendCommand(
                        deviceId: deviceId,
                        equipmentId: equipmentId,
                        parameter: fieldName,
                        command: command,
                        deviceType: deviceType,
                      );

                      if (!success) {
                        // rollback UI if failed
                        widget.jsonData[field['name']] = !newValue ? "1" : "0";
                        setState(() {});
                      }

                      debugPrint("VFS toggled: $newValue");
                    },
                  ),
                ),
              ],
            );
          } else if (fieldName == 'was' ||
              fieldName == 'st1' ||
              fieldName == 'tfq') {
            valueWidget = Row(
              children: [
                IconButton(
                  onPressed: () {
                    final controller = TextEditingController(text: value);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Set ${field['title']}",
                            style: TextStyle(
                              fontSize: 4.sp,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Enter value",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 4.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final newValue = controller.text;

                                final deviceId =
                                    widget.jsonData['device_id'] ?? '';
                                final equipmentId =
                                    widget.jsonData['equipment_id'] ?? '';
                                final deviceType =
                                    widget.jsonData['equipment_nam'] ?? '';

                                // update UI
                                widget.jsonData[field['name']] = newValue;

                                Navigator.pop(context);
                                setState(() {});

                                final success = await _authService.sendCommand(
                                  deviceId: deviceId,
                                  equipmentId: equipmentId,
                                  parameter: fieldName,
                                  command: newValue,
                                  deviceType: deviceType,
                                );

                                if (!success) {
                                  debugPrint(
                                    "❌ Failed to update ${field['name']}",
                                  );
                                }
                              },
                              child: Text(
                                "SET",
                                style: TextStyle(fontSize: 4.sp),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 5.sp,
                    color: AppColors.textColor2(context),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 5.sp,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            );
          } else {
            valueWidget = Text(
              value,
              style: TextStyle(
                fontSize: 5.sp,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            );
          }
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  field['title'],
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: AppColors.textColor2(context).withOpacity(0.9),
                  ),
                ),
              ),
              SpacerWidget.size8w,
              valueWidget,
              if (field['unit'].toString().isNotEmpty) ...[
                SizedBox(width: 4.w),
                Text(
                  field['unit'],
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: AppColors.textColor2(context),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
