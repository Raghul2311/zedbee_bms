import 'package:equatable/equatable.dart';

abstract class EquipmentHistoryEvent extends Equatable {
  const EquipmentHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadEquipmentHistory extends EquipmentHistoryEvent {
  final String equipmentId;
  final String buildingName;
  final String floorName;

  const LoadEquipmentHistory({
    required this.equipmentId,
    required this.buildingName,
    required this.floorName,
  });

  @override
  List<Object?> get props =>
      [equipmentId, buildingName, floorName];
}
