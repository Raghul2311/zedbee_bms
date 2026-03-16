
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_state.dart';
import 'package:zedbee_bms/bloc_folder/bloc/roomlist_bloc/roomlist_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/roomlist_bloc/roomlist_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/roomlist_bloc/roomlist_state.dart';
import 'package:zedbee_bms/data_folder/model_folder/roomlist_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/local_storage.dart';

class EquRoomdropdown extends StatefulWidget {
  const EquRoomdropdown({super.key});

  @override
  State<EquRoomdropdown> createState() => _EquRoomdropdownState();
}

class _EquRoomdropdownState extends State<EquRoomdropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      child: Row(
        children: [
          // ================= EQUIPMENT DROPDOWN =================
          Expanded(
            child: BlocBuilder<EquipmentBloc, EquipmentState>(
              builder: (context, state) {
                if (state is! EquipmentLoaded) {
                  return const SizedBox();
                }
                // sorting equipments ..................
                final sortedEquipmentEntries =
                    state.equipmentCount.entries.toList()..sort(
                      (a, b) =>
                          a.key.toLowerCase().compareTo(b.key.toLowerCase()),
                    );
                return DropdownButtonFormField<String?>(
                  dropdownColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  isExpanded: true,
                  initialValue:
                      state.selectedEquipment != null &&
                          state.equipmentCount.containsKey(
                            state.selectedEquipment,
                          )
                      ? state.selectedEquipment
                      : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
      
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    labelText: 'Equipment Types: ${state.totalEquipmentCount}',
                    labelStyle: TextStyle(
                      fontSize: 4.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        'Select equipment (${state.totalDevices})',
                        style: TextStyle(
                          fontSize: 4.sp,
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...sortedEquipmentEntries.map(
                      (entry) => DropdownMenuItem<String?>(
                        value: entry.key,
                        child: Text(
                          '${entry.key} (${entry.value})',
                          style: TextStyle(
                            fontSize: 4.sp,
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    context.read<EquipmentBloc>().add(
                      UpdateEqupimentEvent(value),
                    );
                  },
                );
              },
            ),
          ),
      
          SizedBox(width: 10.w),
      
          /// ================= ROOM DROPDOWN =================
          Expanded(
            child: BlocBuilder<RoomListBloc, RoomListState>(
              builder: (context, state) {
                if (state is RoomListError) {
                  return Text(
                    state.message,
                    style: TextStyle(fontSize: 4.sp, color: Colors.red),
                  );
                }
      
                if (state is! RoomListLoaded) {
                  return const SizedBox();
                }
      
                // sort rooms ........
                final sortedRooms = [...state.rooms]
                  ..sort(
                    (a, b) => (a.roomName ?? '').toLowerCase().compareTo(
                      (b.roomName ?? '').toLowerCase(),
                    ),
                  );
      
                return DropdownButtonFormField<RoomModel?>(
                  dropdownColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  isExpanded: true,
                  initialValue: state.selectedRoom,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    labelText: 'Rooms (${sortedRooms.length})',
                    labelStyle: TextStyle(
                      fontSize: 4.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  items: [
                    DropdownMenuItem<RoomModel?>(
                      value: null,
                      child: Text(
                        'Select Room',
                        style: TextStyle(
                          fontSize: 4.sp,
                          color:AppColors.green,
                        ),
                      ),
                    ),
                    ...sortedRooms.map(
                      (room) => DropdownMenuItem<RoomModel?>(
                        value: room,
                        child: Text(
                          room.roomName ?? '',
                          style: TextStyle( fontSize: 4.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    // update room selection
                    context.read<RoomListBloc>().add(SelectRoomEvent(value));
      
                    if (value != null) {
                      // persist room
                      LocalStorage.saveRoomId(value.roomId!);
      
                      // filter equipment by selected room
                      context.read<EquipmentBloc>().add(
                        FilterEquipmentByRoomEvent(value.roomId!),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
