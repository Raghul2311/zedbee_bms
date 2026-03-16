import 'dart:convert';

class EquipmentRequest {
  static String build(
    String custKey, {
    List<String>? areaNames,
    List<String>? groupNames,
  }) {
    final List<Map<String, dynamic>> must = [
      {
        "match": {"is_active": true},
      },
    ];

    // Area filter
    if (areaNames != null && areaNames.isNotEmpty) {
      must.add({
        "terms": {"area_name.keyword": areaNames},
      });
    }

    // Group filter
    if (groupNames != null && groupNames.isNotEmpty) {
      must.add({
        "terms": {"group_name.keyword": groupNames},
      });
    }

    return jsonEncode({
      "query": {
        "_source": ["*"],
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
