class RoomModel {
  final String? areaName;
  final String? buildingId;
  final String? buildingName;
  final String? roomId;
  final String? floorName;
  final String? groupName;
  final String? roomName;
  final String? floorId;

  RoomModel({
    this.areaName,
    this.buildingId,
    this.buildingName,
    this.roomId,
    this.floorName,
    this.groupName,
    this.roomName,
    this.floorId,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      areaName: json['area_name']?.toString(),
      buildingId: json['building_id']?.toString(),
      buildingName: json['building_name']?.toString(),
      roomId: json['room_id']?.toString(),
      floorName: json['floor_name']?.toString(),
      groupName: json['group_name']?.toString(),
      roomName: json['room_name']?.toString(),
      floorId: json['floor_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_name': areaName,
      'building_id': buildingId,
      'building_name': buildingName,
      'room_id': roomId,
      'floor_name': floorName,
      'group_name': groupName,
      'room_name': roomName,
      'floor_id': floorId,
    };
  }
}
