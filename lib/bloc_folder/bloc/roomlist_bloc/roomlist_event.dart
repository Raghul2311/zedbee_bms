import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/roomlist_model.dart';

abstract class RoomListEvent extends Equatable {
  const RoomListEvent();

  @override
  List<Object?> get props => [];
}

// Load all rooms from API
class LoadRoomListEvent extends RoomListEvent {}

// Filter rooms based on area / group / floor
class FilterRoomEvent extends RoomListEvent {
  final String? areaName;
  final String? groupName;
  final String? floorId;

  const FilterRoomEvent({
    this.areaName,
    this.groupName,
    this.floorId,
  });

  @override
  List<Object?> get props => [areaName, groupName, floorId,];
}

// Select room from dropdown
class SelectRoomEvent extends RoomListEvent {
  final RoomModel? selectedRoom;

  const SelectRoomEvent(this.selectedRoom);

  @override
  List<Object?> get props => [selectedRoom];
}
