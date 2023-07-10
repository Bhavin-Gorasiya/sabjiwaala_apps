class Training {
  String? customnotificationId;
  String? customnotificationUtype;
  String? customnotificationType;
  String? customnotificationTitle;
  String? customnotificationMsg;
  String? customnotificationUrl;
  String? customnotificationPic;
  DateTime? customnotificationDate;

  Training({
    this.customnotificationId,
    this.customnotificationUtype,
    this.customnotificationType,
    this.customnotificationTitle,
    this.customnotificationMsg,
    this.customnotificationUrl,
    this.customnotificationPic,
    this.customnotificationDate,
  });

  factory Training.fromJson(Map<String, dynamic> json) => Training(
        customnotificationId: json["customnotificationID"] ?? "",
        customnotificationUtype: json["customnotificationUtype"] ?? "",
        customnotificationType: json["customnotificationType"] ?? "",
        customnotificationTitle: json["customnotificationTitle"] ?? "",
        customnotificationMsg: json["customnotificationMsg"] ?? "",
        customnotificationUrl: json["customnotificationUrl"] ?? "",
        customnotificationPic: json["customnotificationPic"] ?? "",
        customnotificationDate:
            json["customnotificationDate"] == null ? DateTime.now() : DateTime.parse(json["customnotificationDate"]),
      );
}

class Leave {
  String? leaveId;
  String? leaveUserid;
  String? leaveUsertype;
  String? leaveType;
  String? leaveMessage;
  DateTime? leaveFromdate;
  DateTime? leaveTodate;
  DateTime? leaveDate;
  String? leaveStatus;

  Leave({
    this.leaveId,
    this.leaveUserid,
    this.leaveUsertype,
    this.leaveType,
    this.leaveMessage,
    this.leaveFromdate,
    this.leaveTodate,
    this.leaveDate,
    this.leaveStatus,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        leaveId: json["leaveID"] ?? "",
        leaveUserid: json["leaveUserid"] ?? "",
        leaveUsertype: json["leaveUsertype"] ?? "",
        leaveType: json["leaveType"] ?? "",
        leaveMessage: json["leaveMessage"] ?? "",
        leaveFromdate: (json["leaveFromdate"] == "" || json["leaveFromdate"] == null)
            ? DateTime.now()
            : DateTime.parse(json["leaveFromdate"]),
        leaveTodate:
            (json["leaveTodate"] == "" || json["leaveTodate"] == null) ? null : DateTime.parse(json["leaveTodate"]),
        leaveDate:
            (json["leaveDate"] == "" || json["leaveDate"] == null) ? DateTime.now() : DateTime.parse(json["leaveDate"]),
        leaveStatus: json["leaveStatus"] ?? "",
      );
}

class EditLeave {
  String? leaveId;
  String? leaveUserid;
  String? leaveMessage;
  String? leaveFromdate;
  String? leaveTodate;
  String? leaveType;

  EditLeave({
    this.leaveId,
    this.leaveUserid,
    this.leaveMessage,
    this.leaveFromdate,
    this.leaveTodate,
    this.leaveType,
  });

  factory EditLeave.fromJson(Map<String, dynamic> json) => EditLeave(
        leaveId: json["leaveID"] ?? "",
        leaveUserid: json["leaveUserid"] ?? "",
        leaveMessage: json["leaveMessage"] ?? "",
        leaveFromdate: json["leaveFromdate"] ?? "",
        leaveTodate: json["leaveTodate"] ?? "",
        leaveType: json["leaveType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "leaveID": leaveId,
        "leaveUserid": leaveUserid,
        "leaveMessage": leaveMessage,
        "leaveFromdate": leaveFromdate,
        "leaveTodate": leaveTodate,
        "leaveType": leaveType,
      };
}

class AddLeaveModel {
  String? leaveUserid;
  String? leaveType;
  String? leaveMessage;
  String? leaveFromdate;
  String? leaveTodate;

  AddLeaveModel({
    this.leaveUserid,
    this.leaveType,
    this.leaveMessage,
    this.leaveFromdate,
    this.leaveTodate,
  });

  factory AddLeaveModel.fromJson(Map<String, dynamic> json) => AddLeaveModel(
        leaveUserid: json["leaveUserid"] ?? "",
        leaveType: json["leaveType"] ?? "",
        leaveMessage: json["leaveMessage"] ?? "",
        leaveFromdate: json["leaveFromdate"],
        leaveTodate: json["leaveTodate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "leaveUserid": leaveUserid,
        "leaveType": leaveType,
        "leaveMessage": leaveMessage,
        "leaveFromdate": leaveFromdate,
        "leaveTodate": leaveTodate,
      };
}
