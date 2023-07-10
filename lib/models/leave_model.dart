class Leave {
  String? leavedeliveryID;
  String? leavedeliveryDbid;
  String? leavedeliverySubfid;
  String? leavedeliveryType;
  String? leavedeliveryMessage;
  DateTime? leavedeliveryFromdate;
  DateTime? leavedeliveryTodate;
  DateTime? leavedeliveryDate;
  String? leavedeliveryStatus;

  Leave({
    this.leavedeliveryID,
    this.leavedeliveryDbid,
    this.leavedeliverySubfid,
    this.leavedeliveryType,
    this.leavedeliveryMessage,
    this.leavedeliveryFromdate,
    this.leavedeliveryTodate,
    this.leavedeliveryDate,
    this.leavedeliveryStatus,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        leavedeliveryID: json["leavedeliveryID"] ?? "",
        leavedeliveryDbid: json["leavedeliveryDbid"] ?? "",
        leavedeliverySubfid: json["leavedeliverySubfid"] ?? "",
        leavedeliveryType: json["leavedeliveryType"] ?? "",
        leavedeliveryMessage: json["leavedeliveryMessage"] ?? "",
        leavedeliveryFromdate: (json["leavedeliveryFromdate"] == "" || json["leavedeliveryFromdate"] == null)
            ? DateTime.now()
            : DateTime.parse(json["leavedeliveryFromdate"]),
        leavedeliveryTodate: (json["leavedeliveryTodate"] == "" || json["leavedeliveryTodate"] == null)
            ? null
            : DateTime.parse(json["leavedeliveryTodate"]),
        leavedeliveryDate: (json["leavedeliveryDate"] == "" || json["leavedeliveryDate"] == null)
            ? DateTime.now()
            : DateTime.parse(json["leavedeliveryDate"]),
        leavedeliveryStatus: json["leavedeliveryStatus"] ?? "",
      );
}

class EditLeave {
  String? leavedeliveryID;
  String? leavedeliveryDbid;
  String? leavedeliverySubfid;
  String? leavedeliveryType;
  String? leavedeliveryMessage;
  String? leavedeliveryFromdate;
  String? leavedeliveryTodate;

  EditLeave({
    this.leavedeliveryID,
    this.leavedeliveryDbid,
    this.leavedeliverySubfid,
    this.leavedeliveryType,
    this.leavedeliveryMessage,
    this.leavedeliveryFromdate,
    this.leavedeliveryTodate,
  });

  factory EditLeave.fromJson(Map<String, dynamic> json) => EditLeave(
        leavedeliveryID: json["leavedeliveryID"] ?? "",
        leavedeliveryDbid: json["leavedeliveryDbid"] ?? "",
        leavedeliverySubfid: json["leavedeliverySubfid"] ?? "",
        leavedeliveryType: json["leavedeliveryType"] ?? "",
        leavedeliveryMessage: json["leavedeliveryMessage"] ?? "",
        leavedeliveryFromdate: json["leavedeliveryFromdate"] ?? "",
        leavedeliveryTodate: json["leavedeliveryTodate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "leavedeliveryID": leavedeliveryID,
        "leavedeliveryDbid": leavedeliveryDbid,
        "leavedeliverySubfid": leavedeliverySubfid,
        "leavedeliveryType": leavedeliveryType,
        "leavedeliveryMessage": leavedeliveryMessage,
        "leavedeliveryFromdate": leavedeliveryFromdate,
        "leavedeliveryTodate": leavedeliveryTodate,
      };
}

class AddLeaveModel {
  String? leavedeliveryDbid;
  String? leavedeliverySubfid;
  String? leavedeliveryType;
  String? leavedeliveryMessage;
  String? leavedeliveryFromdate;
  String? leavedeliveryTodate;

  AddLeaveModel({
    this.leavedeliveryDbid,
    this.leavedeliverySubfid,
    this.leavedeliveryType,
    this.leavedeliveryMessage,
    this.leavedeliveryFromdate,
    this.leavedeliveryTodate,
  });

  factory AddLeaveModel.fromJson(Map<String, dynamic> json) => AddLeaveModel(
        leavedeliveryDbid: json["leavedeliveryDbid"] ?? "",
        leavedeliverySubfid: json["leavedeliverySubfid"] ?? "",
        leavedeliveryType: json["leavedeliveryType"] ?? "",
        leavedeliveryMessage: json["leavedeliveryMessage"],
        leavedeliveryFromdate: json["leavedeliveryFromdate"] ?? "",
        leavedeliveryTodate: json["leavedeliveryTodate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "leavedeliveryDbid": leavedeliveryDbid,
        "leavedeliverySubfid": leavedeliverySubfid,
        "leavedeliveryType": leavedeliveryType,
        "leavedeliveryMessage": leavedeliveryMessage,
        "leavedeliveryFromdate": leavedeliveryFromdate,
        "leavedeliveryTodate": leavedeliveryTodate,
      };
}
