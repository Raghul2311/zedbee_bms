
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equiphistory_bloc/equipmenthistory_state.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/app_drawer.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/equipdetails_box.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/message_alert.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class EquipmentHistory extends StatefulWidget {
  final UserModel userModel;
  final BuildingModel buildingModel;
  final EquipmentModel equipmentModel;

  const EquipmentHistory({
    super.key,
    required this.buildingModel,
    required this.userModel,
    required this.equipmentModel,
  });

  @override
  State<EquipmentHistory> createState() => _EquipmentHistoryState();
}

class _EquipmentHistoryState extends State<EquipmentHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedMenu = "Equipment Management";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        selectedMenu: selectedMenu,
        userModel: widget.userModel,
        buildingModel: widget.buildingModel,
        onMenuTap: (title, screen) {
          setState(() => selectedMenu = title);
          Navigator.pop(context);
          if (screen != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          "Equipment History",
          style: TextStyle(
            fontSize: 5.sp,
            color: AppColors.textColor1(context),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu_sharp,
            color: AppColors.textColor1(context),
            size: 25.r,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              size: 20.r,
              color: AppColors.textColor1(context),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 20.r,
              color: AppColors.textColor1(context),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => MessageAlert(
                  title: "Sign Out",
                  message: "Do you want to sign out?",
                  onConfirm: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder(
        builder: (context, state) {
          if (state is EquipmentHistoryLoading) {
            return const Center(child: AppLoader());
          }

          if (state is EquipmentHistoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is EquipmentHistoryLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER + DETAILS BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.equipmentModel.rawData['device_id']?.toString() ?? '-',
                          style: TextStyle(
                            fontSize: 4.sp,
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 55.w,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.shade700,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => EquipmentDetailsDialog(
                                  equipmentModel: widget.equipmentModel,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Equipment Details",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor1(context),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Icon(
                                  Icons.on_device_training_sharp,
                                  size: 18.r,
                                  color: AppColors.textColor1(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PAGINATED DATA TABLE
                  SizedBox(
                    width: double.infinity,
                    child: PaginatedDataTable(
                      header: Text(
                        "Equipment History",
                        style: TextStyle(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor1(context),
                        ),
                      ),
                      rowsPerPage: 5,
                      columnSpacing: 25,
                      horizontalMargin: 16,
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text("Device ID")),
                        DataColumn(label: Text("Building")),
                        DataColumn(label: Text("Floor")),
                        DataColumn(label: Text("Last Updated")),
                      ],
                      source: EquipmentHistoryDataSource(
                        historyList: state.historyList,
                        context: context,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class EquipmentHistoryDataSource extends DataTableSource {
  final List<EquipmentModel> historyList;
  final BuildContext context;

  EquipmentHistoryDataSource({
    required this.historyList,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= historyList.length) return null;

    final item = historyList[index];

    final deviceId = item.rawData['device_id']?.toString() ?? '-';
    final building = item.rawData['building_name']?.toString() ?? '-';
    final floor = item.rawData['floor_name']?.toString() ?? '-';
    final lastUpdated = item.rawData['last_updated_ts']?.toString() ?? '0';

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(deviceId)),
        DataCell(Text(building)),
        DataCell(Text(floor)),
        DataCell(Text(_formatDate(lastUpdated))),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateMillis = int.tryParse(dateString) ?? 0;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(dateMillis).toLocal();
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (_) {
      return dateString;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => historyList.length;

  @override
  int get selectedRowCount => 0;
}
