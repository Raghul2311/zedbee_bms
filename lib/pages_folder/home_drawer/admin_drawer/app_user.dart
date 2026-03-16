
import 'package:flutter/material.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';

class AppUser extends StatefulWidget {
  final UserModel userModel;
  const AppUser({super.key, required this.userModel});

  @override
  State<AppUser> createState() => _AppUserState();
}

class _AppUserState extends State<AppUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedMenu = "App Users";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'App User',
          style: TextStyle(
            fontSize: 22,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: AppColors.textColor1(context),
          ),
        ),
      ),
    );
  }
}
