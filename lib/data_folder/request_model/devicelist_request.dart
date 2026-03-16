import 'dart:convert';

class DevicelistRequest {
  static String build(String custKey) {
    return jsonEncode({
      "query": {
        "_source": [
          "area_name",
          "building_id",
          "building_name",
          "floor_name",
          "group_name",
          "floor_id",
          "device_id",
          "model",
          "version",
          "created_ts",
          "last_updated_ts",
        ],
        "query": {
          "bool": {
            "must": [
              {
                "match": {"is_active": true},
              },
            ],
            "should": [],
          },
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
