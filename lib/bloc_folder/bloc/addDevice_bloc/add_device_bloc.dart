
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/adddevice_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/deletedevice_model.dart';

import 'add_device_event.dart';
import 'add_device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AuthService authService;

  DeviceBloc({required this.authService}) : super(DeviceInitial()) {
    on<AddDeviceEvent>(_onAddDevice);
    on<DeleteDeviceEvent>(_onDeleteDevice);
  }

  Future<void> _onAddDevice(
    AddDeviceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());

    try {
      // Use Request model here
      final request = AddDeviceRequestModel.fromUser(
        user: event.user,
        deviceId: event.deviceId,
      );

      // Call API
      final result = await authService.addDevice(
        request,
      ); //  Returns AddDeviceModel

      emit(DeviceSuccess(result)); // Success state with response model
    } catch (e) {
      emit(DeviceFailure(e.toString()));
    }
  }

  Future<void> _onDeleteDevice(
    DeleteDeviceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());

    try {
      final request = DeletedeviceModel.fromUser(
        user: event.user,
        deviceId: event.deviceId,
      );

      final result = await authService.deleteDevice(request);

      emit(DeviceSuccess(result));
    } catch (e) {
      emit(DeviceFailure(e.toString()));
    }
  }
}
