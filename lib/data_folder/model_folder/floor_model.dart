class FloorModel {
  final String floorId;
  final String floorName;
  final String buildingId;
  final String buildingName;
  final String country;
  final String areaName;
  final String groupName;
  final String custDomainKey;

  final String floorType;      
  final int floorPosition;      

  final int floorCount;

  FloorModel({
    required this.floorId,
    required this.floorName,
    required this.buildingId,
    required this.buildingName,
    required this.country,
    required this.areaName,
    required this.groupName,
    required this.custDomainKey,
    required this.floorType,
    required this.floorPosition,
    required this.floorCount,
  });

  /// 🔹 Factory from API / Elasticsearch response
  factory FloorModel.fromJson(Map<String, dynamic> json, String custKey) {
    return FloorModel(
      floorId: json['floor_id']?.toString() ?? '',
      floorName: json['floor_name'] ?? '',
      buildingId: json['building_id']?.toString() ?? '',
      buildingName: json['building_name'] ?? '',
      country: json['country'] ?? '',
      areaName: json['area_name'] ?? '',
      groupName: json['group_name'] ?? '',
      custDomainKey: json['cust_domainkey'] ?? custKey,

      /// NEW FIELDS
      floorType: json['floor_type']?.toString() ?? '',
      floorPosition: json['floor_position'] is int
          ? json['floor_position']
          : int.tryParse(json['floor_position']?.toString() ?? '0') ?? 0,

      floorCount: json['floor_count'] is int
          ? json['floor_count']
          : int.tryParse(json['floor_count']?.toString() ?? '0') ?? 0,
    );
  }

  // Convert model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'floor_id': floorId,
      'floor_name': floorName,
      'building_id': buildingId,
      'building_name': buildingName,
      'country': country,
      'area_name': areaName,
      'group_name': groupName,
      'cust_domainkey': custDomainKey,
      'floor_type': floorType,
      'floor_position': floorPosition,
      'floor_count': floorCount,
    };
  }
}
