class LeadModel {
  LeadModel({
    this.leadId,
    this.leadType,
    this.leadUid,
    this.leadFname,
    this.leadLname,
    this.leadEmail,
    this.leadHaddress,
    this.leadMobileno,
    this.leadStatus,
    this.leadArea,
    this.leadStateid,
    this.leadCityid,
  });

  String? leadId;
  String? leadType;
  String? leadUid;
  String? leadFname;
  String? leadLname;
  String? leadEmail;
  String? leadHaddress;
  String? leadMobileno;
  String? leadStatus;
  String? leadArea;
  String? leadStateid;
  String? leadCityid;

  factory LeadModel.fromJson(Map<String, dynamic> json) => LeadModel(
        leadId: json["leadID"] ?? "",
        leadType: json["leadType"] ?? "",
        leadUid: json["leadUid"] ?? "",
        leadFname: json["leadFname"] ?? "",
        leadLname: json["leadLname"] ?? "",
        leadEmail: json["leadEmail"] ?? "",
        leadHaddress: json["leadHaddress"] ?? "",
        leadMobileno: json["leadMobileno"] ?? "",
        leadStatus: json["leadStatus"] ?? "",
        leadArea: json["leadArea"] ?? "",
        leadStateid: json["leadStateid"] ?? "",
        leadCityid: json["leadCityid"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "leadID": leadId ?? "",
        "leadType": leadType ?? "",
        "leadUid": leadUid ?? "",
        "leadFname": leadFname ?? "",
        "leadLname": leadLname ?? "",
        "leadEmail": leadEmail ?? "",
        "leadHaddress": leadHaddress ?? "",
        "leadMobileno": leadMobileno ?? "",
        "leadStatus": leadStatus ?? "",
        "leadArea": leadArea ?? "",
        "leadStateid": leadStateid ?? "",
        "leadCityid": leadCityid ?? "",
      };
}
