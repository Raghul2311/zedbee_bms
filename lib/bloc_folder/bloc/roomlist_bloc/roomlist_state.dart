import 'package:equatable/equatable.dart';
import '../../../data_folder/model_folder/roomlist_model.dart';

abstract class RoomListState extends Equatable {
  const RoomListState();

  @override
  List<Object?> get props => [];
}

class RoomListInitial extends RoomListState {}

class RoomListLoading extends RoomListState {}

class RoomListLoaded extends RoomListState {
  final List<RoomModel> rooms;         // Full list from API
  final List<RoomModel> filteredRooms; // Filtered list for dropdown
  final RoomModel? selectedRoom;

  const RoomListLoaded({
    required this.rooms,
    required this.filteredRooms,
    this.selectedRoom,
  });

  @override
  List<Object?> get props => [
        rooms,
        filteredRooms,
        selectedRoom,
      ];
}

class RoomListError extends RoomListState {
  final String message;

  const RoomListError(this.message);

  @override
  List<Object?> get props => [message];
}
