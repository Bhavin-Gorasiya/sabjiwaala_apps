class DeliveryModel {
  DeliveryModel({
    this.deliverypersonId,
    this.deliverypersonSfid,
    this.deliverypersonFname,
    this.deliverypersonLname,
    this.deliverypersonEmail,
    this.deliverypersonDob,
    this.deliverypersonGender,
    this.deliverypersonPassword,
    this.deliverypersonFcmtoken,
    this.deliverypersonPlatformos,
    this.deliverypersonHaddress,
    this.deliverypersonMobileno1,
    this.deliverypersonMobileno2,
    this.deliverypersonAadharno,
    this.deliverypersonAadharpic,
    this.deliverypersonPanno,
    this.deliverypersonPanpic,
    this.deliverypersonDrivingLicence,
    this.deliverypersonDrivingLicencepic,
    this.deliverypersonVoteridno,
    this.deliverypersonVoteridpic,
    this.deliverypersonPic,
    this.deliverypersonEducationName,
    this.deliverypersonEducationfile,
    this.deliverypersonStateid,
    this.deliverypersonCityid,
    this.deliverypersonDistrict,
    this.deliverypersonPincode,
    this.deliverypersonAccounthname,
    this.deliverypersonBankname,
    this.deliverypersonAccountno,
    this.deliverypersonIfsCcode,
    this.deliverypersonBranchaddress,
    this.deliverypersonRefrancesdetails,
    this.deliverypersonExperiance,
  });

  String? deliverypersonId;
  String? deliverypersonSfid;
  String? deliverypersonFname;
  String? deliverypersonLname;
  String? deliverypersonEmail;
  String? deliverypersonDob;
  String? deliverypersonGender;
  String? deliverypersonPassword;
  String? deliverypersonFcmtoken;
  String? deliverypersonPlatformos;
  String? deliverypersonHaddress;
  String? deliverypersonMobileno1;
  String? deliverypersonMobileno2;
  String? deliverypersonAadharno;
  String? deliverypersonAadharpic;
  String? deliverypersonPanno;
  String? deliverypersonPanpic;
  String? deliverypersonDrivingLicence;
  String? deliverypersonDrivingLicencepic;
  String? deliverypersonVoteridno;
  String? deliverypersonVoteridpic;
  String? deliverypersonPic;
  String? deliverypersonEducationName;
  String? deliverypersonEducationfile;
  String? deliverypersonStateid;
  String? deliverypersonCityid;
  String? deliverypersonDistrict;
  String? deliverypersonPincode;
  String? deliverypersonAccounthname;
  String? deliverypersonBankname;
  String? deliverypersonAccountno;
  String? deliverypersonIfsCcode;
  String? deliverypersonBranchaddress;
  String? deliverypersonRefrancesdetails;
  String? deliverypersonExperiance;

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
    deliverypersonId: json["deliverypersonID"] ?? "",
    deliverypersonSfid: json["deliverypersonSFID"] ?? "",
    deliverypersonFname: json["deliverypersonFname"] ?? "",
    deliverypersonLname: json["deliverypersonLname"] ?? "",
    deliverypersonEmail: json["deliverypersonEmail"] ?? "",
    deliverypersonDob: json["deliverypersonDob"] ?? "",
    deliverypersonGender: json["deliverypersonGender"] ?? "",
    deliverypersonPassword: json["deliverypersonPassword"] ?? "",
    deliverypersonFcmtoken: json["deliverypersonFcmtoken"] ?? "",
    deliverypersonPlatformos: json["deliverypersonPlatformos"] ?? "",
    deliverypersonHaddress: json["deliverypersonHaddress"] ?? "",
    deliverypersonMobileno1: json["deliverypersonMobileno1"] ?? "",
    deliverypersonMobileno2: json["deliverypersonMobileno2"] ?? "",
    deliverypersonAadharno: json["deliverypersonAadharno"] ?? "",
    deliverypersonAadharpic: json["deliverypersonAadharpic"] ?? "",
    deliverypersonPanno: json["deliverypersonPanno"] ?? "",
    deliverypersonPanpic: json["deliverypersonPanpic"] ?? "",
    deliverypersonDrivingLicence: json["deliverypersonDrivingLicence"] ?? "",
    deliverypersonDrivingLicencepic: json["deliverypersonDrivingLicencepic"] ?? "",
    deliverypersonVoteridno: json["deliverypersonVoteridno"] ?? "",
    deliverypersonVoteridpic: json["deliverypersonVoteridpic"] ?? "",
    deliverypersonPic: json["deliverypersonPic"] ?? "",
    deliverypersonEducationName: json["deliverypersonEducationName"] ?? "",
    deliverypersonEducationfile: json["deliverypersonEducationfile"] ?? "",
    deliverypersonStateid: json["deliverypersonStateid"] ?? "",
    deliverypersonCityid: json["deliverypersonCityid"] ?? "",
    deliverypersonDistrict: json["deliverypersonDistrict"] ?? "",
    deliverypersonPincode: json["deliverypersonPincode"] ?? "",
    deliverypersonAccounthname: json["deliverypersonAccounthname"] ?? "",
    deliverypersonBankname: json["deliverypersonBankname"] ?? "",
    deliverypersonAccountno: json["deliverypersonAccountno"] ?? "",
    deliverypersonIfsCcode: json["deliverypersonIFSCcode"] ?? "",
    deliverypersonBranchaddress: json["deliverypersonBranchaddress"] ?? "",
    deliverypersonRefrancesdetails: json["deliverypersonRefrancesdetails"] ?? "",
    deliverypersonExperiance: json["deliverypersonExperiance"] ?? "",
  );
}
