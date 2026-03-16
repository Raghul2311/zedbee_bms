import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';

abstract class BuildingState extends Equatable {
  const BuildingState();

  @override
  List<Object?> get props => [];
}

class BuildingInitial extends BuildingState {}

class BuildingLoading extends BuildingState {}

class BuildingLoaded extends BuildingState {
  final List<BuildingModel> allBuildings;
  final List<BuildingModel> filteredBuildings;

  final List<String> countries;
  final List<String> states;
  final List<String> cities;

  final String? selectedCountry;
  final String? selectedState;
  final String? selectedCity;

  final Map<String, int> buildingCountByGroup;

  const BuildingLoaded({
    required this.allBuildings,
    required this.filteredBuildings,
    required this.countries,
    required this.states,
    required this.cities,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.buildingCountByGroup,
  });

  @override
  List<Object?> get props => [
    allBuildings,
    filteredBuildings,
    countries,
    states,
    cities,
    selectedCountry,
    selectedState,
    selectedCity,
    buildingCountByGroup,
  ];
}

class BuildingFailure extends BuildingState {
  final String error;
  const BuildingFailure(this.error);

  @override
  List<Object?> get props => [error];
}


