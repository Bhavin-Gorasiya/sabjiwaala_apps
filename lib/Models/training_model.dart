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