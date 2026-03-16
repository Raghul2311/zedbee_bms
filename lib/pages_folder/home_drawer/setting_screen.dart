
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/theme_bloc/themes_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/theme_bloc/themes_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/theme_bloc/themes_state.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/app_drawer.dart';
import 'package:zedbee_bms/pages_folder/screens/floor_list.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/app_themes.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/contact_box.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/profile_box.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/terms_box.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/version_box.dart';
import 'package:zedbee_bms/widgets_folder/widgets/appbar.dart';

class SettingScreen extends StatefulWidget {
  final UserModel userModel;
  final BuildingModel buildingModel;

  const SettingScreen({
    super.key,
    required this.userModel,
    required this.buildingModel,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String selectedMenu = "Setting";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        userModel: widget.userModel,
        buildingModel: widget.buildingModel,
        selectedMenu: selectedMenu,
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
      appBar: DynamicAppbar(
        title: "Setting",
        userModel: widget.userModel,
        scaffoldKey: _scaffoldKey,
        showHomeIcon: false,
        showLoginButton: false,
        backButton: true,
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FloorList(
                buildingModel: widget.buildingModel,
                userModel: widget.userModel,
              ),
            ),
          );
        },
      ),
      backgroundColor: AppColors.darkgreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final currentTheme = appThemeData.entries
                        .firstWhere((e) => e.value == state.themeData)
                        .key;
                    return SettingTile(
                      title: "Theme",
                      subtitle: currentTheme.name.toUpperCase(),
                      icon: Icons.invert_colors,
                      color: Colors.lightBlue,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              ThemeSelectionDialog(selectedTheme: currentTheme),
                        );
                      },
                    );
                  },
                ),
                SpacerWidget.large,
                SettingTile(
                  title: "Profile",
                  subtitle: "View & edit profile",
                  icon: Icons.person,
                  color: AppColors.orange,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          ProfileDialog(userModel: widget.userModel),
                    );
                  },
                ),
                SpacerWidget.large,
                SettingTile(
                  title: "App Version",
                  subtitle: "v1.0.1",
                  icon: Icons.system_security_update,
                  color: AppColors.green,
                  onTap: () {
                    showDialog(context: context, builder: (_) => VersionBox());
                  },
                ),

                SpacerWidget.large,

                SettingTile(
                  title: "Terms & Conditions",
                  subtitle: "Read policies",
                  icon: Icons.event_note_sharp,
                  color: AppColors.violet,
                  onTap: () {
                    showDialog(context: context, builder: (_) => TermsBox());
                  },
                ),

                SpacerWidget.large,
                SettingTile(
                  title: "Contact Us",
                  subtitle: "Get in touch",
                  icon: Icons.contact_page,
                  color: Colors.red,
                  onTap: () {
                    showDialog(context: context, builder: (_) => ContactBox());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: const Color(0xff111D21),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.lightgreen.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor2(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 4.sp,
                      color: AppColors.textColor2(context).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 10.r,
              color: AppColors.textColor2(context).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSelectionDialog extends StatelessWidget {
  final AppTheme selectedTheme;

  const ThemeSelectionDialog({super.key, required this.selectedTheme});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkgreen.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.lightgreen, width: 1.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: Text(
        "Choose Theme",
        style: TextStyle(color: AppColors.lightgreen.withOpacity(0.9)),
      ),
      content: SizedBox(
        width: 90.w,
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final currentTheme = appThemeData.entries
                .firstWhere((e) => e.value == state.themeData)
                .key;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: AppTheme.values.map((theme) {
                return RadioListTile<AppTheme>(
                  value: theme,
                  groupValue: currentTheme,
                  activeColor: themePreviewColor(theme),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeBloc>().add(ThemeChanged(value));
                      Navigator.pop(context);
                    }
                  },
                  title: Text(
                    theme.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor2(context),
                    ),
                  ),
                  secondary: ThemeColorDot(color: themePreviewColor(theme)),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class ThemeColorDot extends StatelessWidget {
  final Color color;

  const ThemeColorDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: AppColors.textColor2(context), width: 1.5),
      ),
    );
  }
}
