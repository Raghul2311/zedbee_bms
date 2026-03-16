import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/floor_model.dart';

abstract class FloorState extends Equatable {
  const FloorState();
  @override
  List<Object?> get props => [];
}

class FloorInitial extends FloorState {
  const FloorInitial();
}

class FloorLoading extends FloorState {
  const FloorLoading();
}

class FloorLoaded extends FloorState {
  final Map<String, List<FloorModel>> floorsByBuilding;

  const FloorLoaded(this.floorsByBuilding);
}

class FloorError extends FloorState {
  final String message;
  const FloorError(this.message);

  @override
  List<Object?> get props => [message];
}
