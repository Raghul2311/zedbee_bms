
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/addDevice_bloc/add_device_event.dart';
import 'package:zedbee_bms/data_folder/model_folder/devicelist_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final DeviceItem device;
  final UserModel userModel;

  const DeleteDeviceDialog({
    super.key,
    required this.device,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Device"),
      content: Text("Are you sure you want to delete ${device.deviceId}?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        /// DELETE BUTTON
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);

            context.read<DeviceBloc>().add(
              DeleteDeviceEvent(deviceId: device.deviceId, user: userModel),
            );
          },
          child: const Text("Delete", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
