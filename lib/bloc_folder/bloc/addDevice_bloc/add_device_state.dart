import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/adddevice_model.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceSuccess extends DeviceState {
  final AddDeviceModel result;

  const DeviceSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class DeviceFailure extends DeviceState {
  final String error;

  const DeviceFailure(this.error);

  @override
  List<Object?> get props => [error];
}
