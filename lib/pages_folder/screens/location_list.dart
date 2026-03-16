
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/building_bloc/building_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/building_bloc/building_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/building_bloc/building_state.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/app_routes.dart';
import 'package:zedbee_bms/utils/helper_function/image_url.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/appbar.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loaction_dropdown.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class LocationList extends StatefulWidget {
  final UserModel userModel;
  const LocationList({super.key, required this.userModel});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<BuildingBloc>();
    bloc.add(LoadBuildings(widget.userModel));
    bloc.add(LoadSavedFilters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppbar(
        title: "Location",
        userModel: widget.userModel,
        showHomeIcon: false,
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),

      body: BlocListener<BuildingBloc, BuildingState>(
        listener: (context, state) async {
          if (state is BuildingLoaded) {
            final buildings = state.filteredBuildings;

            // AUTO NAVIGATION LOGIC
            if (buildings.length == 1) {
              final building = buildings.first;

              await LocalStorage.saveLocationData(
                groupName: building.groupName,
                areaName: building.areaName,
              );

              await LocalStorage.clearLocationFilters();

              if (!context.mounted) return;

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.floorlist,
                arguments: {'building': building, 'user': widget.userModel},
              );
            }
          }
        },

        child: BlocBuilder<BuildingBloc, BuildingState>(
          builder: (context, state) {
            if (state is BuildingLoading) {
              return const Center(child: AppLoader());
            }
            if (state is BuildingFailure) {
              return const Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is! BuildingLoaded) return const SizedBox.shrink();

            final buildings = [...state.filteredBuildings]
              ..sort(
                (a, b) => a.areaName.toLowerCase().compareTo(
                  b.areaName.toLowerCase(),
                ),
              );

            // --- SAFETY LOGIC ---
            final bool hasData = buildings.isNotEmpty;
            // Logic: If user clicked one, use it. Otherwise, if list isn't empty, use the first. Otherwise, null.
            final selectedBuilding =
                (selectedIndex != null && selectedIndex! < buildings.length)
                ? buildings[selectedIndex!]
                : (hasData ? buildings.first : null);

            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor.withOpacity(0.3),
                  // backgroundBlendMode: BlendMode.colorDodge,
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    opacity: 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 260.h,
                      left: -480.w,
                      child: Container(
                        width: 997.w,
                        height: 997.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // --- LEFT SIDE ---
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOutCubic,
                                tween: Tween(
                                  begin: -300,
                                  end: 0,
                                ), // slide from left
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(value, 0),
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 90.w,
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.textColor2(context),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            (selectedBuilding == null ||
                                                selectedBuilding.img.isEmpty)
                                            ? Image.asset(
                                                "assets/building.jpg",
                                                height: 460.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                ImageUrl.getBuildingImage(
                                                  selectedBuilding.img,
                                                ),
                                                height: 460.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (context, child, progress) {
                                                      if (progress == null) {
                                                        return child;
                                                      }
                                                      return SizedBox(
                                                        height: 460.h,
                                                        child: const Center(
                                                          child: AppLoader(),
                                                        ),
                                                      );
                                                    },

                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Image.asset(
                                                        "assets/building.jpg",
                                                        height: 460.h,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                              ),
                                      ),
                                      SpacerWidget.small,
                                      Text(
                                        selectedBuilding?.groupName
                                                .toUpperCase() ??
                                            '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 5.sp,
                                          color: AppColors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SpacerWidget.small,
                                      Text(
                                        selectedBuilding?.areaName
                                                .toUpperCase() ??
                                            '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xff2F2F2F),
                                          fontSize: 4.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- RIGHT SIDE ---
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // LOCATIONS DROPDWON
                                Row(
                                  children: [
                                    Expanded(
                                      child: LocationDropdown(
                                        hint: "Select Country",
                                        value: state.selectedCountry,
                                        items: state.countries,
                                        onChanged: (v) {
                                          context.read<BuildingBloc>().add(
                                            UpdateCountry(v),
                                          );
                                          setState(() => selectedIndex = null);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: LocationDropdown(
                                        hint: "Select State",
                                        value: state.selectedState,
                                        items: state.states,
                                        onChanged: (v) {
                                          context.read<BuildingBloc>().add(
                                            UpdateState(v),
                                          );
                                          setState(() => selectedIndex = null);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: LocationDropdown(
                                        hint: "Select City",
                                        value: state.selectedCity,
                                        items: state.cities,
                                        onChanged: (v) {
                                          context.read<BuildingBloc>().add(
                                            UpdateCity(v),
                                          );
                                          setState(() => selectedIndex = null);
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SpacerWidget.size75,

                                //  HEADER TEXT
                                if (selectedBuilding != null) ...[
                                  Text(
                                    selectedBuilding.groupName.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SpacerWidget.small,
                                  Text(
                                    selectedBuilding.areaName.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                  SpacerWidget.small,
                                  Text(
                                    "Buildings - ${state.buildingCountByGroup[selectedBuilding.groupName] ?? 0}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 7.sp,
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    "NO LOCATIONS FOUND",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],

                                SpacerWidget.size16,

                                //  VIEW BUTTON
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedBuilding != null
                                        ? AppColors.green
                                        : Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: selectedBuilding == null
                                      ? null
                                      : () async {
                                          await LocalStorage.saveLocationData(
                                            groupName:
                                                selectedBuilding.groupName,
                                            areaName: selectedBuilding.areaName,
                                          );

                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppRoutes.buildinglist,
                                            arguments: {
                                              'building': selectedBuilding,
                                              'user': widget.userModel,
                                            },
                                          );
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Text(
                                      "View Location",
                                      style: TextStyle(
                                        fontSize: 5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                SpacerWidget.size64,
                                Text(
                                  "${state.buildingCountByGroup.length} Total Locations",
                                  style: TextStyle(
                                    fontSize: 6.sp,
                                    color: AppColors.textColor2(context),
                                  ),
                                ),
                                SizedBox(height: 15.h),

                                // LOCATIONS LISTVIEW
                                if (!hasData)
                                  const Center(
                                    child: Text(
                                      "No locations matching filter",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: buildings.length,
                                      itemBuilder: (context, i) {
                                        final b = buildings[i];
                                        final isSelected =
                                            (selectedIndex == i) ||
                                            (selectedIndex == null && i == 0);

                                        return InkWell(
                                          onTap: () async {
                                            setState(() => selectedIndex = i);
                                          },
                                          child: Container(
                                            width: 80.w,
                                            margin: EdgeInsets.only(right: 9.w),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.white.withOpacity(
                                                      0.3,
                                                    )
                                                  : AppColors.conatinerColor(
                                                      context,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.green
                                                    : Colors.white10,
                                                width: isSelected ? 2 : 1,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 7.w,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    b.groupName.toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 5.sp,
                                                      color: AppColors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SpacerWidget.size2,
                                                  Text(
                                                    b.areaName,
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                        ),
                      ],
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
}
