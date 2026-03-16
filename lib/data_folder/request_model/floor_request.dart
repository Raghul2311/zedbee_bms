import 'dart:convert';

class FloorRequest {
  static String build(String custKey) {
    return jsonEncode({
      "query": {
        "_source": [
          "area_name",
          "building_id",
          "building_name",
          "floor_name",
          "floor_id",
          "cust_domainkey",
          "floor_count",
          "floor_position",
          "floor_type",
        ],
        "query": {
          "bool": {
            "must": [
              {
                "match": {"is_active": true},
              },
            ],
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
