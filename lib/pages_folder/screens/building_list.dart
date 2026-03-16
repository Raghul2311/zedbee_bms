
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/building_bloc/building_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/building_bloc/building_state.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_state.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/app_drawer.dart';
import 'package:zedbee_bms/pages_folder/screens/floor_list.dart';
import 'package:zedbee_bms/pages_folder/screens/location_list.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/appbar.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class BuildingList extends StatefulWidget {
  final BuildingModel buildingModel;
  final UserModel userModel;
  const BuildingList({
    super.key,
    required this.buildingModel,
    required this.userModel,
  });

  @override
  State<BuildingList> createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  String selectedMenu = "Building List";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedSort = "Sort"; // sort drop down button

  @override
  void initState() {
    super.initState();
    _loadGroupName();
    //  Load floors
    context.read<FloorBloc>().add(LoadFloors());
  }

  Future<void> _loadGroupName() async {
    final group = await LocalStorage.getGroupName();
    final area = await LocalStorage.getAreaName();

    debugPrint("Group: $group");
    debugPrint("Area: $area");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        selectedMenu: selectedMenu,
        userModel: widget.userModel,
        buildingModel: widget.buildingModel,
        onMenuTap: (title, screen) {
          setState(() {
            selectedMenu = title;
          });
          Navigator.pop(context); // close drawer
          if (screen != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          }
        },
      ),
      appBar: DynamicAppbar(
        title: "Building Summary",
        userModel: widget.userModel,
        // scaffoldKey: _scaffoldKey,
        showLoginButton: true,
        showHomeIcon: false,
        backButton: true,
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationList(userModel: widget.userModel),
            ),
          );
        },
      ),
      backgroundColor: AppColors.darkgreen,
      body: BlocBuilder<BuildingBloc, BuildingState>(
        builder: (context, buildingState) {
          if (buildingState is BuildingLoading) {
            return const Center(child: AppLoader());
          }
          if (buildingState is BuildingFailure) {
            return Center(
              child: Text(
                buildingState.error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 4.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          if (buildingState is! BuildingLoaded) {
            return const SizedBox.shrink();
          }
          // filtered buildings based location .........
          final buildings = buildingState.allBuildings.where((b) {
            return b.groupName == widget.buildingModel.groupName &&
                b.country == widget.buildingModel.country &&
                b.state == widget.buildingModel.state &&
                b.city == widget.buildingModel.city;
          }).toList();

          if (buildings.isEmpty) {
            return Center(
              child: Text(
                "No buildings found",
                style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w500),
              ),
            );
          }
          final first = buildings.first;
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;
          return Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              color: AppColors.darkgreen,
              backgroundBlendMode: BlendMode.colorDodge,
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                opacity: 0.2,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: -500.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 600.w,
                      height: 997.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white10.withOpacity(0.09),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 10.w,
                  ),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOutBack,
                    tween: Tween(begin: 0.8, end: 1),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------------- HEADER ----------------
                        Text(
                          first.groupName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            decorationStyle: TextDecorationStyle.solid,
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SpacerWidget.small,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${first.areaName.toUpperCase()}  •  Buildings - ${buildingState.buildingCountByGroup[first.groupName] ?? 0}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: AppColors.darkgreen.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppColors.lightgreen),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSort,
                                  icon: ImageIcon(
                                    const AssetImage("assets/sort.png"),
                                    color: AppColors.textColor2(context),
                                    size: 15,
                                  ),
                                  dropdownColor: AppColors.darkgreen,
                                  style: TextStyle(
                                    fontSize: 5.sp,
                                    color: AppColors.textColor2(context),
                                    fontWeight: FontWeight.w400,
                                  ),

                                  items: const [
                                    DropdownMenuItem(
                                      value: "Sort",
                                      child: Text("Sort"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Name",
                                      child: Text("Name"),
                                    ),
                                  ],

                                  onChanged: (value) {
                                    setState(() {
                                      selectedSort = value!;
                                    });

                                    //  Handle sorting logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SpacerWidget.small,

                        // ---------------- GRID ----------------
                        Expanded(
                          child: BlocBuilder<FloorBloc, FloorState>(
                            builder: (context, floorState) {
                              final Map<String, List> floorsByBuilding =
                                  floorState is FloorLoaded
                                  ? floorState.floorsByBuilding
                                  : {};

                              return ListView.builder(
                                padding: EdgeInsets.all(18.w),
                                scrollDirection: Axis.horizontal,
                                itemCount: buildings.length,
                                itemBuilder: (context, index) {
                                  final building = buildings[index];

                                  final buildingFloors =
                                      floorsByBuilding[building.buildingId] ??
                                      [];

                                  final floorCount = buildingFloors.length;

                                  return Container(
                                    width: 70.w,
                                    margin: EdgeInsets.only(right: 15.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.textColor2(context),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: AppColors.lightgreen,
                                        width: 3,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: screenHeight / 3,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                              colors: [
                                                Color(0xff009163),
                                                Colors.teal,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(100.r),
                                              top: Radius.circular(15.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(100.r),
                                              top: Radius.circular(15.r),
                                            ),
                                            child: Image.asset(
                                              "assets/building.jpg",
                                              height: 80.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SpacerWidget.size16,
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              building.buildingName
                                                  .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 5.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.green,
                                              ),
                                            ),

                                            SpacerWidget.small,
                                            Text(
                                              floorState is FloorLoaded
                                                  ? "$floorCount Floor"
                                                  : "Loading floors...",
                                              style: TextStyle(
                                                fontSize: 5.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff6B6B6B),
                                              ),
                                            ),
                                            SpacerWidget.medium,
                                            SizedBox(
                                              width: 35.w,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.r,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => FloorList(
                                                        buildingModel: building,
                                                        userModel:
                                                            widget.userModel,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "View",
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      color:
                                                          AppColors.textColor2(
                                                            context,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
