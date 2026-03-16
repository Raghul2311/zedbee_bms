
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/devicelist_model.dart';
import 'device_list_event.dart';
import 'device_list_state.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  final AuthService authService;

  // Correct constructor
  DeviceListBloc({required this.authService}) : super(DeviceListInitial()) {
    on<FetchDeviceListEvent>(_fetchDevices);
  }

  Future<void> _fetchDevices(
    FetchDeviceListEvent event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(DeviceListLoading());

    try {
      final response = await authService.fetchDeviceList();

      final devices = response.message?.hits?.items ?? <DeviceItem>[];

      emit(DeviceListLoaded(devices));
    } catch (e) {
      emit(DeviceListError(e.toString()));
    }
  }
}
