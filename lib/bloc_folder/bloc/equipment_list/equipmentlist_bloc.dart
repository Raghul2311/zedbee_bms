
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';
import 'package:zedbee_bms/utils/helper_function/equip_status.dart';
import 'package:zedbee_bms/utils/local_storage.dart';

import 'equipmentlist_event.dart';
import 'equipmentlist_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final AuthService authService;

  EquipmentBloc(this.authService) : super(EquipmentInitial()) {
    on<LoadEquipmentEvent>(_onLoadEquipment);
    on<UpdateEqupimentEvent>(_onUpdateEquipment);
    on<UpdateRoomEvent>(_onUpdateRoom);
    on<FilterEquipmentByRoomEvent>(_onFilterByRoom);
  }

  // LOAD EQUIPMENT
  Future<void> _onLoadEquipment(
    LoadEquipmentEvent event,
    Emitter<EquipmentState> emit,
  ) async {
    emit(EquipmentLoading());

    try {
      final areaName = await LocalStorage.getAreaName();
      final groupName = await LocalStorage.getGroupName();
      final floorId = await LocalStorage.getFloorId();

      if (areaName == null || groupName == null) {
        throw Exception("Location not selected");
      }

      final allEquipments = await authService.fetchEquipments();

      // FILTER BY LOCATION
      final equipments = allEquipments.where((e) {
        final areaMatch =
            (e.rawData['area_name'] ?? '').toString().toLowerCase() ==
            areaName.toLowerCase();
        final groupMatch =
            (e.rawData['group_name'] ?? '').toString().toLowerCase() ==
            groupName.toLowerCase();
        final floorMatch = (e.rawData['floor_id'] ?? '').toString() == floorId;

        return areaMatch && groupMatch && floorMatch;
      }).toList();

      final equipmentCount = _calculateCounts(equipments);

      final totalDevices = equipments.length;
      final reportingDevices = equipments.where((e) {
        final lastUpdatedTs = (e.rawData['last_updated_ts'] ?? 0).toString();
        final status = DeviceStatusHelper.getStatusFromLastReporting(
          lastReportingTs: lastUpdatedTs,
          threshold: const Duration(hours: 2),
        );

        return status == DeviceStatus.reporting;
      }).length;
      final notReportingDevices = totalDevices - reportingDevices;

      emit(
        EquipmentLoaded(
          equipments: equipments,
          filteredEquipments: equipments,
          equipmentCount: equipmentCount,
          totalEquipmentCount: equipmentCount.length,
          roomName: _extractRooms(equipments),
          selectedEquipment: null,
          selectedRoom: null,
          totalDevices: totalDevices,
          reportingDevices: reportingDevices,
          notReportingDevices: notReportingDevices,
        ),
      );
    } catch (e) {
      emit(EquipmentError(e.toString()));
    }
  }

  // FILTER BY EQUIPMENT NAME
  void _onUpdateEquipment(
    UpdateEqupimentEvent event,
    Emitter<EquipmentState> emit,
  ) {
    if (state is! EquipmentLoaded) return;
    final current = state as EquipmentLoaded;

    final filtered = event.equipmentName == null
        ? current.equipments
        : current.equipments
              .where(
                (e) =>
                    (e.rawData['equipment_nam'] ?? '').toString() ==
                    event.equipmentName,
              )
              .toList();

    emit(
      current.copyWith(
        filteredEquipments: filtered,
        selectedEquipment: event.equipmentName,
        selectedRoom: null,
        roomName: _extractRooms(filtered),
        equipmentCount: _calculateCounts(filtered),
        totalEquipmentCount: _calculateCounts(filtered).length,
        totalDevices: filtered.length,
      ),
    );
  }

  // FILTER BY ROOM NAME
  void _onUpdateRoom(UpdateRoomEvent event, Emitter<EquipmentState> emit) {
    if (state is! EquipmentLoaded) return;
    final current = state as EquipmentLoaded;

    final filtered = event.roomName == null
        ? current.filteredEquipments
        : current.filteredEquipments
              .where(
                (e) =>
                    (e.rawData['room_name'] ?? '').toString() == event.roomName,
              )
              .toList();

    emit(
      current.copyWith(
        filteredEquipments: filtered,
        selectedRoom: event.roomName,
      ),
    );
  }

  // FILTER BY ROOM ID
  void _onFilterByRoom(
    FilterEquipmentByRoomEvent event,
    Emitter<EquipmentState> emit,
  ) {
    if (state is! EquipmentLoaded) return;
    final current = state as EquipmentLoaded;

    final filtered = current.equipments
        .where((e) => (e.rawData['room_id'] ?? '').toString() == event.roomId)
        .toList();

    emit(
      current.copyWith(
        filteredEquipments: filtered,
        equipmentCount: _calculateCounts(filtered),
        totalEquipmentCount: _calculateCounts(filtered).length,
        totalDevices: filtered.length,
        reportingDevices: filtered.where((e) {
          final lastUpdatedTs = (e.rawData['last_updated_ts'] ?? 0).toString();
          final status = DeviceStatusHelper.getStatusFromLastReporting(
            lastReportingTs: lastUpdatedTs,
            threshold: const Duration(hours: 2),
          );

          return status == DeviceStatus.reporting;
        }).length,
        notReportingDevices: filtered.where((e) {
          final lastUpdatedTs = (e.rawData['last_updated_ts'] ?? 0).toString();
          final status = DeviceStatusHelper.getStatusFromLastReporting(
            lastReportingTs: lastUpdatedTs,
            threshold: const Duration(hours: 2),
          );

          return status == DeviceStatus.notReporting;
        }).length,
        roomName: _extractRooms(filtered),
        selectedEquipment: null,
        selectedRoom: null,
      ),
    );
  }

  // COUNT EQUIPMENT TYPES
  Map<String, int> _calculateCounts(List<EquipmentModel> equipments) {
    final Map<String, int> map = {};
    for (final e in equipments) {
      final name = (e.rawData['equipment_nam'] ?? '').toString();
      if (name.isNotEmpty) {
        map[name] = (map[name] ?? 0) + 1;
      }
    }
    return map;
  }

  // EXTRACT UNIQUE ROOMS
  List<String> _extractRooms(List<EquipmentModel> equipments) {
    return equipments
        .map((e) => e.rawData['room_name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }
}
