class StateModel {
  StateModel({
    this.stateId,
    this.stateName,
    this.stateCode,
    this.stateStatus,
  });

  String? stateId;
  String? stateName;
  String? stateCode;
  String? stateStatus;

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        stateId: json["stateID"] ?? "",
        stateName: json["stateName"] ?? "",
        stateCode: json["stateCode"] ?? "",
        stateStatus: json["stateStatus"] ?? "",
      );
}

class CityModel {
  CityModel({
    this.locationId,
    this.locationStateid,
    this.locationCity,
    this.locationStatus,
  });

  String? locationId;
  String? locationStateid;
  String? locationCity;
  String? locationStatus;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        locationId: json["locationID"] ?? "",
        locationStateid: json["locationStateid"] ?? "",
        locationCity: json["locationCity"] ?? "",
        locationStatus: json["locationStatus"] ?? "",
      );
}
