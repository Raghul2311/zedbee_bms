import 'dart:convert';

class BuildingsRequest {
  static String build(String custKey) {
    return jsonEncode({
      "query": {
        "_source": [
          "area_name",
          "building_id",
          "building_name",
          "img",
          "buil_img",
          "state",
          "country",
          "group_name",
          "city",
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
