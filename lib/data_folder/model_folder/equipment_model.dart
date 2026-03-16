class EquipmentModel {
  final Map<String, dynamic> rawData; // store full JSON for dynamic UI

  EquipmentModel({required this.rawData});

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      rawData: json,
    );
  }

  /// Convenience getter for lastUpdatedTs if exists
  String get lastUpdatedTs {
    final ts = rawData['last_updated_ts'];
    return ts != null ? ts.toString() : '0';
  }
}
