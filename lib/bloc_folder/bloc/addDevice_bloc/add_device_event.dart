import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

class AddDeviceEvent extends DeviceEvent {
  final String deviceId;
  final UserModel user;

  const AddDeviceEvent({required this.deviceId, required this.user});

  @override
  List<Object?> get props => [deviceId, user];
}

class DeleteDeviceEvent extends DeviceEvent {
  final String deviceId;
  final UserModel user;

  const DeleteDeviceEvent({required this.deviceId, required this.user});

  @override
  List<Object?> get props => [deviceId, user];
}
