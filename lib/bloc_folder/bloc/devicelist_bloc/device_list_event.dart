import 'package:equatable/equatable.dart';

abstract class DeviceListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDeviceListEvent extends DeviceListEvent {}
