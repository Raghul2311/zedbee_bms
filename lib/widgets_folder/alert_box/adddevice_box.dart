
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_state.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/admin_drawer/qrcode_scanner.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class AddDeviceDialog extends StatefulWidget {
  final UserModel userModel;

  const AddDeviceDialog({super.key, required this.userModel});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final TextEditingController deviceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceBloc(authService: AuthService()),
      child: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceSuccess) {
            // PRINT SUCCESS
            print(" Device Added Successfully");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.result.message ?? "Success")),
            );
            Navigator.pop(context);
          }

          if (state is DeviceFailure) {
            // PRINT FAILURE
            print("Device Add Failed");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          final isLoading = state is DeviceLoading;

          return AlertDialog(
            backgroundColor: Color(0xffF8FFF2),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.lightgreen),
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Device",
                  style: TextStyle(
                    fontSize: 6.sp,
                    color: AppColors.lightgreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CircleAvatar(
                  radius: 12.r,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textColor2(context),
                      size: 17.r,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DEVICE ID FIELD
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: deviceController,
                      style: TextStyle(
                        fontSize: 5.sp,
                        color: AppColors.textColor1(context),
                      ),
                      decoration: InputDecoration(
                        labelText: "Device ID",
                        filled: true,
                        fillColor: Color(0xffE5E5E5),
                        labelStyle: TextStyle(
                          fontSize: 4.sp,
                          color: Color(0XFF868686),
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Device ID is required";
                        }
                        if (value.trim().length < 5) {
                          return "Device ID must be atleast 5 character";
                        }
                        return null;
                      },
              
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
              
                  SizedBox(height: 12.h),
              
                  // QR SCAN BUTTON
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QRScannerScreen()),
                      );
              
                      if (result != null) {
                        deviceController.text = result.toString();
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 200.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.lightgreen, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          "Scan Device",
                          style: TextStyle(
                            fontSize: 6.sp,
                            color: AppColors.lightgreen,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SpacerWidget.size16,
              
                  // save button add device ........
                  SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightgreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.lightgreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<DeviceBloc>().add(
                                  AddDeviceEvent(
                                    deviceId: deviceController.text.trim(),
                                    user: widget.userModel,
                                  ),
                                );
                              }
                            },
              
                      child: isLoading
                          ? const AppLoader()
                          : Text(
                              "Save Device",
                              style: TextStyle(
                                fontSize: 4.sp,
                                color: AppColors.textColor2(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
