// import 'package:bms/bloc_folder/bloc/equiphistory_bloc/equipmenthistory_event.dart';
// import 'package:bms/bloc_folder/bloc/equiphistory_bloc/equipmenthistory_state.dart';
// import 'package:bms/data_folder/auth_services/auth_service.dart';
// import 'package:bms/data_folder/model_folder/equipment_history.dart';
// import 'package:bms/data_folder/model_folder/equipment_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EquipmentHistoryBloc
//     extends Bloc<EquipmentHistoryEvent, EquipmentHistoryState> {
//   final AuthService authService;

//   EquipmentHistoryBloc(this.authService)
//       : super(EquipmentHistoryInitial()) {
//     on<LoadEquipmentHistory>(_onLoadHistory);
//   }

//   Future<void> _onLoadHistory(
//     LoadEquipmentHistory event,
//     Emitter<EquipmentHistoryState> emit,
//   ) async {
//     emit(EquipmentHistoryLoading());

//     try {
//       // API response model
//       final List<EquipmentResponseModel> apiList =
//           await authService.getEquipmentHistory(
//         equipmentId: event.equipmentId,
//       );

//       // ✅ Convert API model → UI model
//       final List<EquipmentModel> uiList = apiList.map((e) {
//         return EquipmentModel(
//           deviceId: e.equipmentId,
//           buildingName: event.buildingName,
//           floorName: event.floorName,
//           lastUpdatedTs:
//               DateTime.fromMillisecondsSinceEpoch(e.createdTs)
//                   .toIso8601String(),
//         );
//       }).toList();

//       emit(EquipmentHistoryLoaded(uiList));
//     } catch (e) {
//       emit(EquipmentHistoryError(e.toString()));
//     }
//   }
// }
