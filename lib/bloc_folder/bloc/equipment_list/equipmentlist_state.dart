import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';

abstract class EquipmentState extends Equatable {
  const EquipmentState();

  @override
  List<Object?> get props => [];
}

class EquipmentInitial extends EquipmentState {}

class EquipmentLoading extends EquipmentState {}

class EquipmentLoaded extends EquipmentState {
  final List<EquipmentModel> equipments;
  final List<EquipmentModel> filteredEquipments;

  //  DROPDOWN DATA
  final Map<String, int> equipmentCount;   // Pump → 2
  final int totalEquipmentCount;            // Unique equipment names

  final List<String> roomName;

  final String? selectedEquipment;
  final String? selectedRoom;

  // COUNTS
  final int totalDevices;
  final int reportingDevices;
  final int notReportingDevices;

  const EquipmentLoaded({
    required this.equipments,
    required this.filteredEquipments,
    required this.equipmentCount,
    required this.totalEquipmentCount,
    required this.roomName,
    required this.selectedEquipment,
    required this.selectedRoom,
    required this.totalDevices,
    required this.reportingDevices,
    required this.notReportingDevices,
  });

  //  ADD THIS METHOD (FIXES YOUR ERROR)
  EquipmentLoaded copyWith({
    List<EquipmentModel>? equipments,
    List<EquipmentModel>? filteredEquipments,
    Map<String, int>? equipmentCount,
    int? totalEquipmentCount,
    List<String>? roomName,
    String? selectedEquipment,
    String? selectedRoom,
    int? totalDevices,
    int? reportingDevices,
    int? notReportingDevices,
  }) {
    return EquipmentLoaded(
      equipments: equipments ?? this.equipments,
      filteredEquipments:
          filteredEquipments ?? this.filteredEquipments,
      equipmentCount: equipmentCount ?? this.equipmentCount,
      totalEquipmentCount:
          totalEquipmentCount ?? this.totalEquipmentCount,
      roomName: roomName ?? this.roomName,
      selectedEquipment: selectedEquipment,
      selectedRoom: selectedRoom,
      totalDevices: totalDevices ?? this.totalDevices,
      reportingDevices:
          reportingDevices ?? this.reportingDevices,
      notReportingDevices:
          notReportingDevices ?? this.notReportingDevices,
    );
  }

  @override
  List<Object?> get props => [
        equipments,
        filteredEquipments,
        equipmentCount,
        totalEquipmentCount,
        roomName,
        selectedEquipment,
        selectedRoom,
        totalDevices,
        reportingDevices,
        notReportingDevices,
      ];
}

class EquipmentError extends EquipmentState {
  final String message;

  const EquipmentError(this.message);

  @override
  List<Object?> get props => [message];
}
