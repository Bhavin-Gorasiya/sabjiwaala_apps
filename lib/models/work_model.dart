class WorkModel {
  WorkModel({
    this.workhistoryId,
    this.workhistoryUid,
    this.workhistoryTfrom,
    this.workhistoryTto,
    this.workhistorySubject,
    this.workhistoryMsg,
    this.workhistoryPic,
    this.workhistoryDate,
  });

  String? workhistoryId;
  String? workhistoryUid;
  String? workhistoryTfrom;
  String? workhistoryTto;
  String? workhistorySubject;
  String? workhistoryMsg;
  String? workhistoryPic;
  DateTime? workhistoryDate;

  factory WorkModel.fromJson(Map<String, dynamic> json) => WorkModel(
        workhistoryId: json["workhistoryID"] ?? "",
        workhistoryUid: json["workhistoryUid"] ?? "",
        workhistoryTfrom: json["workhistoryTfrom"] ?? "",
        workhistoryTto: json["workhistoryTto"] ?? "",
        workhistorySubject: json["workhistorySubject"] ?? "",
        workhistoryMsg: json["workhistoryMsg"] ?? "",
        workhistoryPic: json["workhistoryPic"] ?? "",
        workhistoryDate: DateTime.parse(json["workhistoryDate"] ?? DateTime.now()),
      );
}
