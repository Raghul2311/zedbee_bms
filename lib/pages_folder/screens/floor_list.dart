
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_state.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/floor_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/app_drawer.dart';
import 'package:zedbee_bms/pages_folder/screens/building_list.dart';
import 'package:zedbee_bms/pages_folder/screens/device_monitor.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/appbar.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class FloorList extends StatefulWidget {
  final BuildingModel buildingModel;
  final UserModel userModel;

  const FloorList({
    super.key,
    required this.buildingModel,
    required this.userModel,
  });

  @override
  State<FloorList> createState() => _FloorListState();
}

class _FloorListState extends State<FloorList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FloorModel? selectedFloor;
  String selectedMenu = "Floor Management";
  String? saveFloorId;

  @override
  void initState() {
    super.initState();
    _loadSavedFloor();
  }

  Future<void> _loadSavedFloor() async {
    final id = await LocalStorage.getFloorId();
    setState(() {
      saveFloorId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FloorBloc(AuthService())..add(LoadFloors()),
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
        backgroundColor: AppColors.darkgreen,
        appBar: DynamicAppbar(
          title: "Floors - ${widget.buildingModel.buildingName}",
          scaffoldKey: _scaffoldKey,
          userModel: widget.userModel,
          showLoginButton: false,
          backButton: true,
          onBackPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildingList(
                  buildingModel: widget.buildingModel,
                  userModel: widget.userModel,
                ),
              ),
            );
          },
        ),

        body: BlocBuilder<FloorBloc, FloorState>(
          builder: (context, floorState) {
            if (floorState is FloorLoading) {
              return const Center(child: AppLoader());
            }

            if (floorState is FloorError) {
              return Center(child: Text(floorState.message));
            }

            if (floorState is FloorLoaded) {
              final rawFloors =
                  floorState.floorsByBuilding[widget
                      .buildingModel
                      .buildingId] ??
                  [];
              // floor sorting .....
              final floors = [...rawFloors]
                ..sort((a, b) {
                  final typeA = a.floorType.toLowerCase();
                  final typeB = b.floorType.toLowerCase();

                  if (typeA == 'basement' && typeB != 'basement') return 1;
                  if (typeA != 'basement' && typeB == 'basement') return -1;

                  return b.floorPosition.compareTo(a.floorPosition);
                });

              // selected floor retain function .............
              if (selectedFloor == null && saveFloorId != null) {
                try {
                  selectedFloor = floors.firstWhere(
                    (f) => f.floorId == saveFloorId,
                  );
                } catch (_) {
                  selectedFloor = null;
                }
              }
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(color: AppColors.darkgreen),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Container(
                          width: 0.13.sw,
                          height: 0.75.sh,
                          decoration: BoxDecoration(
                            color: AppColors.darkgreen,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                
                          child: floors.isEmpty
                              ? const Center(child: Text("No floors found"))
                              : Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: floors.length,
                                        itemBuilder: (context, index) {
                                          final floor = floors[index];
                                          final isSelected =
                                              selectedFloor?.floorId ==
                                              floor.floorId;
                
                                          return InkWell(
                                            onTap: () async {
                                              await LocalStorage.saveFloorId(
                                                floor.floorId,
                                              );
                                              await LocalStorage.clearRoomId();
                                              setState(
                                                () => selectedFloor = floor,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? AppColors.lightgreen
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(2.w),
                                              ),
                
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6.w,
                                                  vertical: 15.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      isSelected
                                                          ? Icons
                                                                .radio_button_checked
                                                          : Icons
                                                                .radio_button_off,
                                                      size: 4.5.sp,
                                                      color: isSelected
                                                          ? AppColors.darkgreen
                                                          : Colors.grey,
                                                    ),
                                                    SpacerWidget.size8w,
                
                                                    Expanded(
                                                      child: Text(
                                                        floor.floorName,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 4.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColors.textColor2(
                                                                context,
                                                              ),
                                                        ),
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
                                  ],
                                ),
                        ),
                
                        // DEVICE MONITOR
                        Expanded(
                          child: selectedFloor == null
                              ? Center(
                                  child: Text(
                                    "Select a floor",
                                    style: TextStyle(
                                      fontSize: 5.sp,
                                      color: AppColors.textColor2(context),
                                    ),
                                  ),
                                )
                              : DeviceMonitor(
                                  key: ValueKey(selectedFloor!.floorId),
                                  floorModel: selectedFloor!,
                                  buildingModel: widget.buildingModel,
                                  userModel: widget.userModel,
                                ),
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

class BuildingHighlightView extends StatelessWidget {
  final List<FloorModel> floors;
  final FloorModel? selectedFloor;

  const BuildingHighlightView({
    super.key,
    required this.floors,
    required this.selectedFloor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: floors.map((floor) {
          final isSelected = selectedFloor?.floorId == floor.floorId;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 3.h),
            height: 20.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.lightgreen
                  : Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }).toList(),
      ),
    );
  }
}
