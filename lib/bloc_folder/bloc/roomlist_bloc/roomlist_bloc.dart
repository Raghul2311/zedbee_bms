
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'roomlist_event.dart';
import 'roomlist_state.dart';

class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  final AuthService authService;

  RoomListBloc(this.authService) : super(RoomListInitial()) {
    on<LoadRoomListEvent>(_onLoadRooms);
    on<SelectRoomEvent>(_onSelectRoom);
    
  }

  // Load all rooms
 Future<void> _onLoadRooms(
  LoadRoomListEvent event,
  Emitter<RoomListState> emit,
) async {
  emit(RoomListLoading());

  try {
    final areaName = await LocalStorage.getAreaName();
    final groupName = await LocalStorage.getGroupName();
    final floorId = await LocalStorage.getFloorId();

    if (areaName == null || groupName == null) {
      throw Exception("Location not selected");
    }

    final rooms = await authService.fetchRooms();

    // FILTER BY AREA + GROUP + FLOOR
    final filteredRooms = rooms.where((room) {
      final areaMatch =
          (room.areaName) == areaName.toLowerCase();
      final groupMatch =
          (room.groupName) == groupName.toLowerCase();
      final floorMatch = room.floorId == floorId;

      return areaMatch && groupMatch && floorMatch;
    }).toList();

    emit(
      RoomListLoaded(
        rooms: rooms,
        filteredRooms: filteredRooms,
        selectedRoom: null,
      ),
    );
  } catch (e) {
    emit(RoomListError(e.toString()));
  }
}

  // Select a room
  void _onSelectRoom(
    SelectRoomEvent event,
    Emitter<RoomListState> emit,
  ) {
    if (state is RoomListLoaded) {
      final current = state as RoomListLoaded;

      emit(
        RoomListLoaded(
          rooms: current.rooms,
          filteredRooms: current.filteredRooms,
          selectedRoom: event.selectedRoom,
        ),
      );
    }
  }
}
