class EditProfileModel {
  EditProfileModel({
    this.userId,
    this.userFname,
    this.userLname,
    this.userEmail,
    this.userHaddress,
    this.userMobileno1,
    this.userMobileno2,
    this.userStateid,
    this.userCityid,
    this.userDistrict,
    this.userAadharno,
    this.userPanno,
    this.userPincode,
    this.userBankname,
    this.userAccountno,
    this.userIfsCcode,
    this.userAccounthname,
    this.userCrops,
    this.userLand,
    this.userOfficearea,
  });

  String? userId;
  String? userFname;
  String? userLname;
  String? userEmail;
  String? userHaddress;
  String? userMobileno1;
  String? userMobileno2;
  String? userStateid;
  String? userCityid;
  String? userDistrict;
  String? userAadharno;
  String? userPanno;
  String? userPincode;
  String? userBankname;
  String? userAccountno;
  String? userIfsCcode;
  String? userAccounthname;
  String? userCrops;
  String? userLand;
  String? userOfficearea;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
        userId: json["userID"] ?? "",
        userFname: json["userFname"] ?? "",
        userLname: json["userLname"] ?? "",
        userEmail: json["userEmail"] ?? "",
        userHaddress: json["userHaddress"] ?? "",
        userMobileno1: json["userMobileno1"] ?? "",
        userMobileno2: json["userMobileno2"] ?? "",
        userStateid: json["userStateid"] ?? "",
        userCityid: json["userCityid"] ?? "",
        userDistrict: json["userDistrict"] ?? "",
        userAadharno: json["userAadharno"] ?? "",
        userPanno: json["userPanno"] ?? "",
        userPincode: json["userPincode"] ?? "",
        userBankname: json["userBankname"] ?? "",
        userAccountno: json["userAccountno"] ?? "",
        userIfsCcode: json["userIFSCcode"] ?? "",
        userAccounthname: json["userAccounthname"] ?? "",
        userCrops: json["userCrops"] ?? "",
        userLand: json["userLand"] ?? "",
        userOfficearea: json["userOfficearea"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userID": userId ?? "",
        "userFname": userFname ?? "",
        "userLname": userLname ?? "",
        "userEmail": userEmail ?? "",
        "userHaddress": userHaddress ?? "",
        "userMobileno1": userMobileno1 ?? "",
        "userMobileno2": userMobileno2 ?? "",
        "userStateid": userStateid ?? "",
        "userCityid": userCityid ?? "",
        "userDistrict": userDistrict ?? "",
        "userAadharno": userAadharno ?? "",
        "userPanno": userPanno ?? "",
        "userPincode": userPincode ?? "",
        "userBankname": userBankname ?? "",
        "userAccountno": userAccountno ?? "",
        "userIFSCcode": userIfsCcode ?? "",
        "userAccounthname": userAccounthname ?? "",
        "userOfficearea": userOfficearea ?? "",
        "userCrops": userCrops ?? "",
        "userLand": userLand ?? "",
      };
}
