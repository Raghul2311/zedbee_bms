import 'package:equatable/equatable.dart';

abstract class EquipmentEvent extends Equatable {
  const EquipmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadEquipmentEvent extends EquipmentEvent {

  const LoadEquipmentEvent();
  @override
  List<Object?> get props => [];
}

class UpdateEqupimentEvent extends EquipmentEvent {
  final String? equipmentName;
  const UpdateEqupimentEvent(this.equipmentName);
}

class UpdateRoomEvent extends EquipmentEvent {
  final String? roomName;
  const UpdateRoomEvent(this.roomName);
}
class FilterEquipmentByRoomEvent extends EquipmentEvent {
  final String roomId;

  const FilterEquipmentByRoomEvent(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

