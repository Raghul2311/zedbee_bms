import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'building_event.dart';
import 'building_state.dart';

class BuildingBloc extends Bloc<BuildingEvent, BuildingState> {
  final AuthService authService;
  final LocalStorage localStorage;

  List<BuildingModel> _allBuildings = [];

  String? _country;
  String? _state;
  String? _city;

  BuildingBloc(this.authService, this.localStorage) : super(BuildingInitial()) {
    on<LoadBuildings>(_onLoadBuildings);
    on<LoadSavedFilters>(_onLoadSavedFilters);
    on<UpdateCountry>(_onUpdateCountry);
    on<UpdateState>(_onUpdateState);
    on<UpdateCity>(_onUpdateCity);
  }

  // ---------------- LOAD BUILDINGS ----------------

  Future<void> _onLoadBuildings(
    LoadBuildings event,
    Emitter<BuildingState> emit,
  ) async {
    emit(BuildingLoading());

    final allBuildings = await authService.fetchBuildings();

    final userBuildingIds = event.user.buildingIds;
    // login filter for admin and user login ..........
    if (userBuildingIds.isEmpty) {
      _allBuildings = allBuildings;
    } else {
      _allBuildings = allBuildings.where((b) {
        return userBuildingIds.contains(b.buildingId.toString());
      }).toList();
    }

    emit(_buildLoadedState());
  }

  // ---------------- LOAD SAVED FILTERS ----------------

  Future<void> _onLoadSavedFilters(
    LoadSavedFilters event,
    Emitter<BuildingState> emit,
  ) async {
    final saved = await localStorage.getLocationFilters();

    _country = saved["country"]?.isNotEmpty == true ? saved["country"] : null;
    _state = saved["state"]?.isNotEmpty == true ? saved["state"] : null;
    _city = saved["city"]?.isNotEmpty == true ? saved["city"] : null;

    emit(_buildLoadedState());
  }

  // ---------------- UPDATE FILTERS ----------------

  void _onUpdateCountry(UpdateCountry e, Emitter<BuildingState> emit) {
    _country = e.country;
    _state = null;
    _city = null;
    _save();
    emit(_buildLoadedState());
  }

  void _onUpdateState(UpdateState e, Emitter<BuildingState> emit) {
    _state = e.state;
    _city = null;
    _save();
    emit(_buildLoadedState());
  }

  void _onUpdateCity(UpdateCity e, Emitter<BuildingState> emit) {
    _city = e.city;
    _save();
    emit(_buildLoadedState());
  }

  // ---------------- SAVE FILTERS ----------------

  void _save() {
    localStorage.saveLocationFilters(
      country: _country,
      state: _state,
      city: _city,
    );
  }

  BuildingLoaded _buildLoadedState() {
    // FILTER BUILDINGS FIRST
    final filteredBuildings = _allBuildings.where((b) {
      if (_country != null && b.country != _country) return false;
      if (_state != null && b.state != _state) return false;
      if (_city != null && b.city != _city) return false;

      return true;
    }).toList();

    //  GROUP BY groupName → UNIQUE LOCATIONS
    final Map<String, BuildingModel> uniqueByGroup = {};

    for (final b in filteredBuildings) {
      uniqueByGroup.putIfAbsent(b.groupName, () => b);
    }

    final uniqueLocations = uniqueByGroup.values.toList();

    // COUNTRIES
    final countries = _allBuildings
        .map((e) => e.country.trim())
        .toSet()
        .toList();

    // STATES (depends on country)
    final states = _allBuildings
        .where((b) => _country == null || b.country == _country)
        .map((e) => e.state.trim())
        .toSet()
        .toList();

    // CITIES (depends on country + state)
    final cities = _allBuildings
        .where(
          (b) =>
              (_country == null || b.country == _country) &&
              (_state == null || b.state == _state),
        )
        .map((e) => e.city.trim())
        .toSet()
        .toList();

    // SAFE SELECTED VALUES
    final safeCountry = countries.contains(_country) ? _country : null;
    final safeState = states.contains(_state) ? _state : null;
    final safeCity = cities.contains(_city) ? _city : null;

    // COUNT UNIQUE BUILDINGS (BY buildingId) PER GROUP NAME
    final Map<String, Set<String>> groupBuildingIds = {};

    for (final b in filteredBuildings) {
      groupBuildingIds.putIfAbsent(b.groupName, () => <String>{});
      groupBuildingIds[b.groupName]!.add(b.buildingId);
    }

    // Convert Set length to count
    final Map<String, int> buildingCountByGroup = {
      for (final entry in groupBuildingIds.entries)
        entry.key: entry.value.length,
    };

    return BuildingLoaded(
      allBuildings: _allBuildings,
      filteredBuildings: uniqueLocations,
      countries: countries,
      states: states,
      cities: cities,
      selectedCountry: safeCountry,
      selectedState: safeState,
      selectedCity: safeCity,
      buildingCountByGroup: buildingCountByGroup,
    );
  }
}
