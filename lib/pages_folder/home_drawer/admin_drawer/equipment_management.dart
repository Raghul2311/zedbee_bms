
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_state.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/app_drawer.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/helper_function/date_time.dart';
import 'package:zedbee_bms/utils/helper_function/equip_status.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/appbar.dart';
import 'package:zedbee_bms/widgets_folder/widgets/device_textfield.dart';
import 'package:zedbee_bms/widgets_folder/widgets/highlight_text.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';
import 'package:zedbee_bms/widgets_folder/widgets/page_pagination.dart';

// Safe getter for dynamic fields
extension EquipmentRaw on EquipmentModel {
  String getVal(String key) => rawData[key]?.toString() ?? '';
}

class EquipmentScreen extends StatefulWidget {
  final UserModel userModel;
  final BuildingModel buildingModel;

  const EquipmentScreen({
    super.key,
    required this.userModel,
    required this.buildingModel,
  });

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedMenu = "Equipment Management";
  String searchText = "";
  // Table list items size ...
  final int flexEquipmentId = 2;
  final int flexNormal = 1;

  // item limit for table ..
  int currentPage = 0;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    // bool isTablet = ScreenUtil().screenWidth >= 600;

    return BlocProvider(
      create: (_) => EquipmentBloc(AuthService())..add(LoadEquipmentEvent()),
      child: Scaffold(
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

        // ================= APP BAR =================
        appBar: DynamicAppbar(
          title: "Equipment Management",
          userModel: widget.userModel,
          scaffoldKey: _scaffoldKey,
          showLoginButton: false,
        ),
        backgroundColor: AppColors.darkgreen,
        // ================= BODY =================
        body: BlocBuilder<EquipmentBloc, EquipmentState>(
          builder: (context, state) {
            if (state is EquipmentLoading) {
              return const Center(child: AppLoader());
            }

            if (state is EquipmentError) {
              return Center(child: Text(state.message));
            }

            if (state is! EquipmentLoaded || state.filteredEquipments.isEmpty) {
              return Center(
                child: Text(
                  "No Equipment Found",
                  style: TextStyle(fontSize: 4.sp, color: Colors.white),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ================= HEADER =================
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120.w,
                            child: DeviceTextfield(
                              hint: "Search Any Equipment...",
                              onChanged: (v) => setState(() => searchText = v),
                            ),
                          ),
                          SpacerWidget.size16w,

                          // COUNTS IN SAME ROW (TABLET)
                          _buildCounts(context, state),
                        ],
                      ),
                    ),

                    SpacerWidget.size16,

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff111D21),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.lightgreen.withOpacity(0.3),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 4.w,
                        ),
                        child: Row(
                          children: [
                            _headerCell("Equipment Id", 48.w),
                            _headerCell("EquipmentName", 50.w),
                            _headerCell("Equipment Type", 50.w),
                            _headerCell("DeviceId", 45.w),
                            _headerCell("Building", 38.w),
                            _headerCell("Floors", 45.w),
                            _headerCell("Status", 35.w),
                            _headerCell("Last Updated Time", 40.w),
                          ],
                        ),
                      ),
                    ),

                    // ================= TABLE =================
                    SpacerWidget.medium,

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: state.equipments.isEmpty
                          ? Center(
                              child: Text(
                                "No Equipment Found",
                                style: TextStyle(
                                  fontSize: 4.sp,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Builder(
                              builder: (context) {
                                /// FILTER BY SEARCH TEXT
                                final filteredList = state.equipments.where((
                                  eq,
                                ) {
                                  return eq
                                      .getVal('equipment_id')
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase());
                                }).toList();

                                /// PAGINATION CALCULATION
                                final totalItems = filteredList.length;
                                final startIndex = currentPage * itemsPerPage;

                                /// If page exceeds available data, reset page
                                if (startIndex >= totalItems &&
                                    totalItems > 0) {
                                  currentPage =
                                      (totalItems - 1) ~/ itemsPerPage;
                                }

                                final safeStartIndex =
                                    currentPage * itemsPerPage;
                                final endIndex =
                                    (safeStartIndex + itemsPerPage) > totalItems
                                    ? totalItems
                                    : safeStartIndex + itemsPerPage;

                                final pageItems = filteredList.sublist(
                                  safeStartIndex,
                                  endIndex,
                                );

                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: pageItems.length,
                                        itemBuilder: (context, index) {
                                          final eq = pageItems[index];

                                          final lastUpdatedTs = eq.getVal(
                                            'last_updated_ts',
                                          );

                                          final status =
                                              DeviceStatusHelper.getStatusFromLastReporting(
                                                lastReportingTs: lastUpdatedTs,
                                                threshold: const Duration(
                                                  hours: 2,
                                                ),
                                              );

                                          final deviceId = eq.getVal(
                                            'device_id',
                                          );

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3.h,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff111D21),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                  color: AppColors.lightgreen
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10.h,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    /// EQUIPMENT ID
                                                    SizedBox(
                                                      width: 25.w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Navigator.push(...)
                                                        },
                                                        child: HighlightText(
                                                          fullText: eq.getVal(
                                                            'equipment_id',
                                                          ),
                                                          query: searchText,
                                                          normalColor:
                                                              AppColors.textColor2(
                                                                context,
                                                              ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),

                                                    _cell(
                                                      eq.getVal('equi_nam'),
                                                      30.w,
                                                    ),
                                                    _cell(
                                                      eq.getVal(
                                                        'equipment_nam',
                                                      ),
                                                      30.w,
                                                    ),

                                                    _cell(
                                                      (deviceId
                                                              .toString()
                                                              .trim()
                                                              .isEmpty)
                                                          ? "N/A"
                                                          : deviceId.toString(),
                                                      30.w,
                                                    ),
                                                    _cell(
                                                      eq.getVal(
                                                        'building_name',
                                                      ),
                                                      20.w,
                                                    ),
                                                    _cell(
                                                      eq.getVal('floor_name'),
                                                      20.w,
                                                    ),

                                                    // STATUS
                                                    SizedBox(
                                                      width: 20.w,
                                                      child: HighlightText(
                                                        fullText:
                                                            DeviceStatusHelper.statusText(
                                                              status,
                                                            ),
                                                        query: searchText,
                                                        normalColor:
                                                            DeviceStatusHelper.statusColor(
                                                              status,
                                                            ),
                                                        maxLines: 1,
                                                      ),
                                                    ),

                                                    // LAST UPDATED
                                                    SizedBox(
                                                      width: 40.w,
                                                      child: HighlightText(
                                                        fullText: formatToIST(
                                                          lastUpdatedTs,
                                                        ),
                                                        query: searchText,
                                                        normalColor:
                                                            AppColors.textColor2(
                                                              context,
                                                            ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    // PAGINATION WIDGET
                                    PaginationWidget(
                                      currentPage: currentPage,
                                      totalItems: filteredList.length,
                                      itemsPerPage: itemsPerPage,
                                      onPageChanged: (page) {
                                        setState(() {
                                          currentPage = page;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cell(String text, double width) {
    return SizedBox(
      width: width,
      child: HighlightText(
        fullText: text,
        query: searchText,
        normalColor: AppColors.textColor2(context),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _headerCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 4.sp,
          color: AppColors.lightgreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

Widget _buildCounts(BuildContext context, dynamic state) {
  return Wrap(
    spacing: 15.w,
    runSpacing: 8.h,
    children: [
      _countText(context, "Total : ${state.totalDevices} (Devices)"),
      _countText(context, "Reporting : ${state.reportingDevices}"),
      _countText(context, "Not Reporting : ${state.notReportingDevices}"),
    ],
  );
}

Widget _countText(BuildContext context, String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 5.sp,
      color: AppColors.textColor2(context),
      fontWeight: FontWeight.w500,
    ),
  );
}
