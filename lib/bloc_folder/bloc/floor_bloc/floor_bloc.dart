
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/floor_model.dart';
import 'floor_event.dart';
import 'floor_state.dart';

class FloorBloc extends Bloc<FloorEvent, FloorState> {
  final AuthService authService;

  FloorBloc(this.authService) : super(FloorInitial()) {
    on<LoadFloors>(_onLoadFloors);
  }

  Future<void> _onLoadFloors(
    LoadFloors event,
    Emitter<FloorState> emit,
  ) async {
    emit(FloorLoading());

    try {
      final floors = await authService.fetchFloors();

      // Group floors by BUILDING ID (CORRECT)
      final Map<String, List<FloorModel>> grouped = {};

      for (final floor in floors) {
        final key = floor.buildingId;

        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(floor);
      }

      emit(FloorLoaded(grouped));
    } catch (e) {
      emit(FloorError(e.toString()));
    }
  }
}
