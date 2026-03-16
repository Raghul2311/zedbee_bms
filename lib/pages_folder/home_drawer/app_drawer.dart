import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/admin_drawer/device_management.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/admin_drawer/equipment_management.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/setting_screen.dart';
import 'package:zedbee_bms/pages_folder/screens/building_list.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';

class AppDrawer extends StatefulWidget {
  final String selectedMenu;
  final Function(String title, Widget? screen) onMenuTap;
  final UserModel userModel;
  final BuildingModel buildingModel;

  const AppDrawer({
    super.key,
    required this.selectedMenu,
    required this.onMenuTap,
    required this.userModel,
    required this.buildingModel,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isAdminExpanded = false;
  File? _profileImage; // profile image


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.textColor1(context),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _drawerHeader(context),
              drawerTile(
                context,
                "Building List",
                Icons.apartment,
                screen: BuildingList(
                  buildingModel: widget.buildingModel,
                  userModel: widget.userModel,
                ),
              ),

              // ================= ADMINISTRATION =================
              _adminParentTile(context),

              if (isAdminExpanded) ..._adminItems(context),

              // drawerTile(
              //   context,
              //   "Reports",
              //   Icons.insert_chart,
              //   screen: Reports(),
              // ),
              drawerTile(
                context,
                "Settings",
                Icons.settings,
                screen: SettingScreen(
                  userModel: widget.userModel,
                  buildingModel: widget.buildingModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final path = await LocalStorage.getProfileImagePath();
    if (path != null && File(path).existsSync()) {
      setState(() {
        _profileImage = File(path);
      });
    }
  }

  // ================= HEADER =================
  Widget _drawerHeader(BuildContext context) {
    bool isTablet = ScreenUtil().screenWidth >= 600;

    return DrawerHeader(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: isTablet? 30.w : 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.conatinerColor(context),
                    foregroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Center(
                          child: Icon(
                              Icons.person_outline,
                              size: 25.r,
                              color: Colors.grey,
                            ),
                        )
                        : null,
                  ),
                ),

                SpacerWidget.small,
                Text(
                  "${widget.userModel.firstName} ${widget.userModel.lastName}",
                  style: TextStyle(
                    fontSize: isTablet ? 6.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= ADMIN PARENT =================
  Widget _adminParentTile(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isAdminExpanded = !isAdminExpanded);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isAdminExpanded
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.admin_panel_settings,
              color: isAdminExpanded
                  ? AppColors.textColor1(context)
                  : AppColors.textColor2(context), // icon color
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Administration",
                style: TextStyle(
                  color: isAdminExpanded
                      ? AppColors.textColor1(context)
                      : AppColors.textColor2(context), // text color
                ),
              ),
            ),
            Icon(
              isAdminExpanded ? Icons.expand_less : Icons.expand_more,
              color: isAdminExpanded
                  ? AppColors.textColor1(context)
                  : AppColors.textColor2(context), // arrow color
            ),
          ],
        ),
      ),
    );
  }

  // ================= ADMIN ITEMS =================
  List<Widget> _adminItems(BuildContext context) {
    return [
      // adminTile(
      //   context,
      //   "App Users",
      //   Icons.person,
      //   screen: AppUser(userModel: widget.userModel),
      // ),
      // adminTile(context, "Audit Logs", Icons.history_edu),
      // adminTile(context, "Control Panel", Icons.settings_applications),
      adminTile(
        context,
        "Device Management",
        Icons.devices,
        screen: DeviceManagement(
          userModel: widget.userModel,
          buildingModel: widget.buildingModel,
        ),
      ),
      adminTile(
        context,
        "Equipment Management",
        Icons.build,
        screen: EquipmentScreen(
          userModel: widget.userModel,
          buildingModel: widget.buildingModel,
        ),
      ),
    ];
  }

  // ================= MAIN TILE =================
  Widget drawerTile(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? screen,
  }) {
    final isSelected = widget.selectedMenu == title;

    return InkWell(
      onTap: () => widget.onMenuTap(title, screen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.textColor1(context)
                  : AppColors.textColor2(context),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textColor1(context)
                    : AppColors.textColor2(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ADMIN CHILD TILE =================
  Widget adminTile(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? screen,
  }) {
    final isSelected = widget.selectedMenu == title;

    return InkWell(
      onTap: () => widget.onMenuTap(title, screen),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context)
                    .primaryColor // background when selected
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.textColor2(context)
                  : AppColors.textColor2(context),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? AppColors.textColor2(context)
                    : AppColors.textColor2(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
