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
      child: Scaffold(
        backgroundColor: AppColors.darkgreen,
        body: BlocBuilder<EquipmentBloc, EquipmentState>(
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
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.darkgreen),
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
                                  device.rawData['last_updated_ts']
                                      ?.toString() ??
                                  '0';

                              final deviceStatus =
                                  DeviceStatusHelper.getStatusFromLastReporting(
                                    lastReportingTs: lastUpdatedStr,
                                    threshold: const Duration(hours: 2),
                                  );

                              return Container(
                                decoration: BoxDecoration(
                                 color: AppColors.conatinerColor(context).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Theme.of(context).primaryColorDark
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                  color: Theme.of(context).primaryColorDark,
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

class DynamicFieldGrid extends StatelessWidget {
  final Map<String, dynamic> jsonData;
  final String? equipmentName;

  // Helper Function to detect empty values ........
  bool _isEmptyValue(dynamic rawValue, String fieldName) {
    if (rawValue == null) return true;
    final formatted = FormatDynamicvalue.format(fieldName, rawValue).trim();
    return formatted.isEmpty ||
        formatted.toLowerCase() == 'null' ||
        formatted.toLowerCase() == 'n/a' ||
        formatted == '--';
  }

  const DynamicFieldGrid({
    super.key,
    required this.jsonData,
    this.equipmentName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fields = [];
    bool isTablet = ScreenUtil().screenWidth >= 600;

    final params = jsonData['params'];
    if (params is List) {
      for (final p in params) {
        if (p is Map<String, dynamic>) {
          final rawName = p['name']?.toString();
          if (rawName == null) continue;
          // Empty parms are not shown ..........
          final rawValue = jsonData[rawName];
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
          style: TextStyle(
            fontSize: isTablet ? 4.sp : 9.sp,
            color: Colors.grey,
          ),
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
          childAspectRatio: isTablet ? 14 : 11,
        ),
        itemBuilder: (context, index) {
          final field = fields[index];
          final rawValue = jsonData[field['name']];
          final value = FormatDynamicvalue.format(
            field['name'],
            rawValue,
            equipmentName: equipmentName,
          );
          final valueColor = FormatDynamicvalue.color(
            context,
            field['name'],
            rawValue,
            equipmentName: equipmentName,
          );
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  field['title'],
                  style: TextStyle(
                    fontSize: isTablet ? 4.sp : 12.sp,
                    color: AppColors.textColor2(context).withOpacity(0.9),
                  ),
                ),
              ),
              SpacerWidget.size8w,
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 5.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              if (field['unit'].toString().isNotEmpty) ...[
                SizedBox(width: 4.w),
                Text(
                  field['unit'],
                  style: TextStyle(
                    fontSize: isTablet ? 4.sp : 11.sp,
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
