import 'dart:convert';

class RoomRequest {
  static String build(
    String custKey, {
    required String areaName,
    required String groupName,
    required String? floorId,
  }) {
    final List<Map<String, dynamic>> must = [
      {
        "match": {"is_active": true},
      },
      {
        "term": {"area_name.keyword": areaName},
      },
      {
        "term": {"group_name.keyword": groupName},
      },
      {
        "term": {"floor_id.keyword": floorId},
      },
    ];

    return jsonEncode({
      "query": {
        "_source": [
          "area_name",
          "building_id",
          "building_name",
          "room_id",
          "floor_name",
          "group_name",
          "room_name",
          "floor_id",
        ],
        "query": {
          "bool": {"must": must, "should": []},
        },
        "sort": [
          {
            "last_updated_ts": {"order": "desc"},
          },
        ],
        "size": 1000,
        "from": 0,
      },
      "domainKey": custKey,
    });
  }
}
