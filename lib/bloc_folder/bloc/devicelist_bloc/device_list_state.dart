import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/devicelist_model.dart';

abstract class DeviceListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceListInitial extends DeviceListState {}

class DeviceListLoading extends DeviceListState {}

class DeviceListLoaded extends DeviceListState {
  final List<DeviceItem> devices;

  DeviceListLoaded(this.devices);

  @override
  List<Object?> get props => [devices];
}

class DeviceListError extends DeviceListState {
  final String message;

  DeviceListError(this.message);

  @override
  List<Object?> get props => [message];
}
