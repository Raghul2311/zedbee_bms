import 'package:equatable/equatable.dart';

abstract class FloorEvent extends Equatable {
  const FloorEvent();

   @override
  List<Object?> get props => [];
}



class LoadFloors extends FloorEvent {
  const LoadFloors();
}
