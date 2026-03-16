class DeviceListResponse {
  final bool callStatus;
  final Message? message;

  DeviceListResponse({required this.callStatus, required this.message});

  factory DeviceListResponse.fromJson(Map<String, dynamic> json) {
    return DeviceListResponse(
      callStatus: json["call_status"] ?? false,
      message: json["message"] != null
          ? Message.fromJson(json["message"])
          : null,
    );
  }
}

class Message {
  final Hits? hits;

  Message({required this.hits});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      hits: json["hits"] != null ? Hits.fromJson(json["hits"]) : null,
    );
  }
}

class Hits {
  final List<DeviceItem> items;

  Hits({required this.items});

  factory Hits.fromJson(Map<String, dynamic> json) {
    return Hits(
      items: json["hits"] == null
          ? []
          : List<DeviceItem>.from(
              json["hits"].map((x) => DeviceItem.fromJson(x)),
            ),
    );
  }
}

class DeviceItem {
  final String areaName;
  final String floorName;
  final String buildingId;
  final String buildingName;
  final String deviceId;
  final String groupName;
  final String model;
  final String floorId;
  final String version;
  final String id;
  final String index;
  final String? lastUpdatedTs;
  final String? currentUpdatedTs;
  final List<dynamic> sort;

  DeviceItem({
    required this.areaName,
    required this.floorName,
    required this.buildingId,
    required this.buildingName,
    required this.deviceId,
    required this.groupName,
    required this.model,
    required this.floorId,
    required this.version,
    required this.id,
    required this.index,
    required this.currentUpdatedTs,
    required this.lastUpdatedTs,
    required this.sort,
  });

  factory DeviceItem.fromJson(Map<String, dynamic> json) {
    final source = json["_source"] ?? {};

    return DeviceItem(
      areaName: source["area_name"] ?? "",
      floorName: source["floor_name"] ?? "",
      buildingId: source["building_id"] ?? "",
      buildingName: source["building_name"] ?? "",
      deviceId: source["device_id"] ?? "",
      groupName: source["group_name"] ?? "",
      model: source["model"] ?? "",
      floorId: source["floor_id"] ?? "",
      version: source["version"] ?? "",

      // FIXED — timestamps MUST come from _source
      currentUpdatedTs: source["created_ts"]?.toString() ?? "-",
      lastUpdatedTs: source["last_updated_ts"]?.toString() ?? "-",

      id: json["_id"] ?? "",
      index: json["_index"] ?? "",
      sort: json["sort"] ?? [],
    );
  }
}
