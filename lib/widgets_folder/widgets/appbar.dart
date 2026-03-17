
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/theme_bloc/themes_bloc.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/app_routes.dart';
import 'package:zedbee_bms/utils/appbar_gradient.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/alert_box/message_alert.dart';


class DynamicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final UserModel userModel;
  final bool showHomeIcon;
  final bool showLoginButton;
  final bool backButton;
  final VoidCallback? onBackPressed;

  const DynamicAppbar({
    super.key,
    required this.title,
    required this.userModel,
    this.scaffoldKey,
    this.showHomeIcon = true,
    this.showLoginButton = true,
    this.backButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeBloc>().state.theme;
    final gradientColors = getThemeGradient(theme);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 65.h,
      // default back button .........
      automaticallyImplyLeading: false,
      // EVERYTHING GOES HERE
      flexibleSpace: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              children: [
                if (backButton)
                  IconButton(
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.r,
                    ),
                  ),
                SpacerWidget.size8w,
                // TITLE
                Text(
                  title.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),

                /// HOME BUTTON
                if (showHomeIcon)
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 24.r,
                    ),
                    onPressed: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushReplacementNamed(
                        AppRoutes.locationList,
                        arguments: {'user': userModel},
                      );
                    },
                  ),

                // LOGOUT BUTTON
                if (showLoginButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColor2(context),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
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
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 4.sp,
                        color: AppColors.textColor1(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                // MENU BUTTON
                if (scaffoldKey != null)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.menu_sharp,
                      color: Colors.white,
                      size: 24.r,
                    ),
                    onPressed: () => scaffoldKey!.currentState?.openDrawer(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
