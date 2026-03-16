import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';

abstract class EquipmentHistoryState extends Equatable {
  const EquipmentHistoryState();

  @override
  List<Object?> get props => [];
}

class EquipmentHistoryInitial extends EquipmentHistoryState {}

class EquipmentHistoryLoading extends EquipmentHistoryState {}

class EquipmentHistoryLoaded extends EquipmentHistoryState {
  final List<EquipmentModel> historyList;

  const EquipmentHistoryLoaded(this.historyList);

  @override
  List<Object?> get props => [historyList];
}

class EquipmentHistoryError extends EquipmentHistoryState {
  final String message;

  const EquipmentHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
