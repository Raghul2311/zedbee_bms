import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';

abstract class BuildingEvent extends Equatable {
  const BuildingEvent();
  @override
  List<Object?> get props => [];
}

class LoadBuildings extends BuildingEvent {
  final UserModel user;

  const LoadBuildings(this.user);
}

class LoadSavedFilters extends BuildingEvent {}

class UpdateCountry extends BuildingEvent {
  final String? country;
  const UpdateCountry(this.country);

  @override
  List<Object?> get props => [country];
}

class UpdateState extends BuildingEvent {
  final String? state;
  const UpdateState(this.state);

  @override
  List<Object?> get props => [state];
}

class UpdateCity extends BuildingEvent {
  final String? city;
  const UpdateCity(this.city);

  @override
  List<Object?> get props => [city];
}
