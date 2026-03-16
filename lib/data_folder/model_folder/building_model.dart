
class BuildingModel {
  final String areaName;
  final String buildingId;
  final String buildingName;
  final String img;
  final String builImg;
  final String state;
  final String country;
  final String custDomainKey;
  final String groupName;
  final String city;

  BuildingModel({
    required this.areaName,
    required this.buildingId,
    required this.buildingName,
    required this.img,
    required this.builImg,
    required this.state,
    required this.country,
    required this.custDomainKey,
    required this.groupName,
    required this.city,
  });

  factory BuildingModel.fromJson(
    Map<String, dynamic> json,
    String custDomainKey,
  ) {
    return BuildingModel(
      areaName: json['area_name'] ?? '',
      buildingId: json['building_id'] ?? '',
      buildingName: json['building_name'] ?? '',
      img: json['img'] ?? '',
      builImg: json['buil_img'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      groupName: json['group_name'] ?? '',
      city: json['city'] ?? '',
      custDomainKey: custDomainKey,
    );
  }
}

