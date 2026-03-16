import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_state.dart';
import 'package:zedbee_bms/bloc_folder/bloc/devicelist_bloc/device_list_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/devicelist_bloc/device_list_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/devicelist_bloc/device_list_state.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/app_drawer.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/helper_function/equip_status.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/adddevice_box.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/deletedevice_box.dart';
import 'package:zedbee_bms/widgets_folder/widgets/appbar.dart';
import 'package:zedbee_bms/widgets_folder/widgets/device_textfield.dart';
import 'package:zedbee_bms/widgets_folder/widgets/highlight_text.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';
import 'package:zedbee_bms/widgets_folder/widgets/page_pagination.dart';

class DeviceManagement extends StatefulWidget {
  final UserModel userModel;
  final BuildingModel buildingModel;
  const DeviceManagement({
    super.key,
    required this.userModel,
    required this.buildingModel,
  });

  @override
  State<DeviceManagement> createState() => _DeviceManagementState();
}

class _DeviceManagementState extends State<DeviceManagement> {
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  String? storedAreaName;
  String? storedGroupName;
  // Table list items size ...
  final int flexDeviceId = 2;
  final int flexNormal = 1;

  // item limit for table ..
  int currentPage = 0;
  final int itemsPerPage = 10;

  // drawer requirements
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedMenu = "Device Management";

  @override
  void initState() {
    super.initState();
    _loadAreaAndGroup();
  }

  Future<void> _loadAreaAndGroup() async {
    final area = await LocalStorage.getAreaName();
    final group = await LocalStorage.getGroupName();

    setState(() {
      storedAreaName = area;
      storedGroupName = group;
    });

    debugPrint("Area: $storedAreaName");
    debugPrint("Group: $storedGroupName");
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DeviceBloc(authService: AuthService())),
        BlocProvider(
          create: (_) =>
              DeviceListBloc(authService: AuthService())
                ..add(FetchDeviceListEvent()),
        ),
      ],
      // Listerner for Add and Device Devices ......
      child: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceSuccess) {
            context.read<DeviceListBloc>().add(FetchDeviceListEvent());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.result.message ?? "Success")),
            );
          }
          if (state is DeviceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(fontSize: 4.sp, color: Colors.white),
                ),
              ),
            );
          }
        },

        child: Scaffold(
          key: _scaffoldKey,
          // Drawer Menu
          drawer: AppDrawer(
            selectedMenu: selectedMenu,
            onMenuTap: (title, screen) {
              setState(() {
                selectedMenu = title; // update highlight
              });
              Navigator.pop(context); // close drawer

              if (screen != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                );
              }
            },
            userModel: widget.userModel,
            buildingModel: widget.buildingModel,
          ),

          appBar: DynamicAppbar(
            title: "Device Management",
            userModel: widget.userModel,
            scaffoldKey: _scaffoldKey,
            showLoginButton: false,
          ),
          backgroundColor: AppColors.darkgreen,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (storedGroupName ?? "").toUpperCase(),
                          style: TextStyle(
                            fontSize: 5.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SpacerWidget.size64w,
                        // Device search text field
                        SizedBox(
                          width: 120.w,
                          child: DeviceTextfield(
                            hint: "Search Device Id",
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                                currentPage = 0;
                              });
                            },
                          ),
                        ),
                        SpacerWidget.size16w,
                        // Add Device Button
                        SizedBox(
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(
                                  15.r,
                                ),
                              ),
                              backgroundColor: AppColors.lightgreen,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AddDeviceDialog(
                                  userModel: widget.userModel,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 20.r,
                                  weight: 5,
                                  color: AppColors.textColor2(context),
                                ),
                                SpacerWidget.size8w,
                                Text(
                                  "Add Device",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    color: AppColors.textColor2(context),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                          vertical: 8.h,
                          horizontal: 5.w,
                        ),
                        child: Row(
                          children: [
                            _headerCell("Device ID", flexDeviceId),
                            _headerCell("Model", flexNormal),
                            _headerCell("Version", flexNormal),
                            _headerCell("Building", flexNormal),
                            _headerCell("Floor", flexNormal),
                            _headerCell("Status", flexNormal),
                            _headerCell("Building ID", flexNormal),
                            _headerCell("Actions", flexNormal),
                          ],
                        ),
                      ),
                    ),

                    // List view builder stats here .........
                    SpacerWidget.medium,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: BlocBuilder<DeviceListBloc, DeviceListState>(
                        builder: (context, state) {
                          // LOADING
                          if (state is DeviceListLoading) {
                            return const Center(child: AppLoader());
                          }

                          // ERROR
                          if (state is DeviceListError) {
                            return Center(
                              child: Text(
                                "Error: ${state.message}",
                                style: TextStyle(
                                  fontSize: 4.sp,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          // SUCCESS
                          if (state is DeviceListLoaded) {
                            final devices = state.devices.where((device) {
                              return device.areaName == storedAreaName &&
                                  device.groupName == storedGroupName;
                            }).toList();

                            final filteredDevices = devices.where((device) {
                              return device.deviceId.toLowerCase().contains(
                                searchText.toLowerCase(),
                              );
                            }).toList();

                            // PAGINATION CALCULATION
                            final startIndex = currentPage * itemsPerPage;
                            final endIndex =
                                (startIndex + itemsPerPage) >
                                    filteredDevices.length
                                ? filteredDevices.length
                                : startIndex + itemsPerPage;

                            final pageItems = filteredDevices.sublist(
                              startIndex,
                              endIndex,
                            );
                            if (filteredDevices.isEmpty) {
                              return Center(
                                child: Text(
                                  "No Devices Found",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: pageItems.length,
                                    itemBuilder: (context, index) {
                                      final device = pageItems[index];
                                      final status =
                                          DeviceStatusHelper.getStatusFromLastReporting(
                                            lastReportingTs:
                                                device.lastUpdatedTs ?? '',
                                            threshold: const Duration(hours: 2),
                                          );
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff111D21),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.lightgreen
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                          ),
                                          child: Row(
                                            children: [
                                              /// DEVICE ID + COPY INLINE
                                              Expanded(
                                                flex: flexDeviceId,
                                                child: RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        alignment:
                                                            PlaceholderAlignment
                                                                .middle,
                                                        child: HighlightText(
                                                          fullText:
                                                              device.deviceId,
                                                          query: searchText,
                                                          normalColor:
                                                              AppColors.textColor2(
                                                                context,
                                                              ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 6,
                                                        ),
                                                      ),
                                                      WidgetSpan(
                                                        alignment:
                                                            PlaceholderAlignment
                                                                .middle,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await Clipboard.setData(
                                                              ClipboardData(
                                                                text: device
                                                                    .deviceId,
                                                              ),
                                                            );

                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  "Device ID copied",
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          1,
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.copy,
                                                            size: 5.sp,
                                                            color: AppColors
                                                                .lightgreen,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              _cell(device.model, flexNormal),
                                              _cell(device.version, flexNormal),
                                              _cell(
                                                device.buildingName,
                                                flexNormal,
                                              ),
                                              _cell(
                                                device.floorName,
                                                flexNormal,
                                              ),

                                              /// STATUS
                                              Expanded(
                                                flex: flexNormal,
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

                                              _cell(
                                                device.buildingId,
                                                flexNormal,
                                              ),

                                              // ACTION
                                              Expanded(
                                                flex: flexNormal,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 3.w,
                                                        ),
                                                    constraints:
                                                        const BoxConstraints(),
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 6.sp,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            BlocProvider.value(
                                                              value: context
                                                                  .read<
                                                                    DeviceBloc
                                                                  >(),
                                                              child: DeleteDeviceDialog(
                                                                device: device,
                                                                userModel: widget
                                                                    .userModel,
                                                              ),
                                                            ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                PaginationWidget(
                                  currentPage: currentPage,
                                  totalItems: filteredDevices.length,
                                  itemsPerPage: itemsPerPage,
                                  onPageChanged: (page) {
                                    setState(() {
                                      currentPage = page;
                                    });
                                  },
                                ),
                              ],
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: HighlightText(
        fullText: text,
        query: searchText,
        normalColor: AppColors.textColor1(context),
        textStyle: TextStyle(
          fontSize: 4.sp,
          color: AppColors.textColor2(context),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _headerCell(String text, int flex) {
    return Expanded(
      flex: flex,
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
