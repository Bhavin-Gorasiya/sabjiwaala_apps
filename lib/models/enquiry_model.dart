class EnquiryModel {
  String? enquiryId;
  String? enquiryEmp;
  String? enquiryUid;
  String? enquiryUtype;
  String? enquiryName;
  String? enquiryEmail;
  String? enquiryPhoneno;
  String? enquirySubject;
  String? enquiryMessage;
  DateTime? enquiryDate;

  EnquiryModel({
    this.enquiryId,
    this.enquiryEmp,
    this.enquiryUid,
    this.enquiryUtype,
    this.enquiryName,
    this.enquiryEmail,
    this.enquiryPhoneno,
    this.enquirySubject,
    this.enquiryMessage,
    this.enquiryDate,
  });

  factory EnquiryModel.fromJson(Map<String, dynamic> json) => EnquiryModel(
        enquiryId: json["enquiryID"] ?? "",
        enquiryEmp: json["enquiryEmp"] ?? "",
        enquiryUid: json["enquiryUid"] ?? "",
        enquiryUtype: json["enquiryUtype"] ?? "",
        enquiryName: json["enquiryName"] ?? "",
        enquiryEmail: json["enquiryEmail"] ?? "",
        enquiryPhoneno: json["enquiryPhoneno"] ?? "",
        enquirySubject: json["enquirySubject"] ?? "",
        enquiryMessage: json["enquiryMessage"] ?? "",
        enquiryDate: json["enquiryDate"] == null ? null : DateTime.parse(json["enquiryDate"]),
      );
}
