// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/profile_details.dart';

class ProfileDialog extends StatefulWidget {
  final UserModel userModel;
  const ProfileDialog({super.key, required this.userModel});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  File? _imageFile; // store selected image
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
    bool isTablet = ScreenUtil().screenWidth >= 600;


  @override
  void initState() {
    super.initState();
    loadSavedImage();
  }

  // Load saved image from local storage
  Future<void> loadSavedImage() async {
    final savePath = await LocalStorage.getProfileImagePath();
    if (savePath != null && File(savePath).existsSync()) {
      setState(() {
        _imageFile = File(savePath);
      });
    }
  }

  // pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile == null) return; // no image selection
      // App private storage with file name & path
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final saveImage = await File(
        pickedFile.path,
      ).copy('${directory.path}/$fileName');
      // save it to local storage
      await LocalStorage.savedProfileImagePath(saveImage.path);

      setState(() {
        _imageFile = saveImage;
      });
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade300,
          content: Text(
            "Profile updated successfully!",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // show error if fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Failed to upload image: $e",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      insetPadding: EdgeInsets.symmetric(vertical: 15.h),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: isTablet ? 6.sp : 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
      content: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 3,
        radius: Radius.circular(20),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Image
                Container(
                  width: isTablet? 30.w : 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: AppColors.textColor2(context),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
                        ? Icon(
                            Icons.person,
                            size: isTablet? 50.r : 60.r,
                            color: AppColors.textColor1(context),
                          )
                        : null,
                  ),
                ),
              isTablet? SpacerWidget.size32 : SpacerWidget.small,
      
                // Upload button
                Padding(
                  padding: EdgeInsets.all(15.0.r),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: AppColors.textColor1(context),
                    ),
                    onPressed: _pickImage,
                    child: Text(
                      "Upload",
                      style: TextStyle(
                        fontSize: isTablet? 4.sp : 12.sp,
                        color: AppColors.textColor1(context),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              isTablet? SpacerWidget.size32 : SpacerWidget.small,
      
                // Profile Details
                ProfileDetails(
                  label: "Name",
                  value:
                      "${widget.userModel.firstName} ${widget.userModel.lastName}",
                  icon: Icons.person,
                ),
                SizedBox(height: 20.h),
                ProfileDetails(
                  label: "Contact",
                  value: widget.userModel.mobile,
                  icon: Icons.phone,
                ),
                SizedBox(height: 20.h),
                ProfileDetails(
                  label: "Email",
                  value: widget.userModel.email,
                  icon: Icons.email,
                ),
                SizedBox(height: 20.h),
                ProfileDetails(
                  label: "Location",
                  value: widget.userModel.city,
                  icon: Icons.location_city,
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
