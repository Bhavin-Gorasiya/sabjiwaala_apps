class ProfileModel {
  String? userID;
  String? sfId;
  String? userFname;
  String? userLname;
  String? userPicture;
  String? userEmail;
  String? userHaddress;
  String? userMobileno1;
  String? userMobileno2;
  String? userAadharno;
  String? userPanno;
  String? userStateid;
  String? userCityid;
  String? userDistrict;
  String? userPincode;
  String? userBankname;
  String? userAccountno;
  String? userAccounthname;
  String? userIFSCcode;

  ProfileModel(
      {this.userID,
      this.sfId,
      this.userFname,
      this.userLname,
      this.userPicture,
      this.userEmail,
      this.userHaddress,
      this.userMobileno1,
      this.userMobileno2,
      this.userAadharno,
      this.userPanno,
      this.userStateid,
      this.userCityid,
      this.userDistrict,
      this.userPincode,
      this.userBankname,
      this.userAccountno,
      this.userAccounthname,
      this.userIFSCcode});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    userID = json['deliverypersonID'] ?? "";
    userFname = json['deliverypersonFname'] ?? "";
    sfId = json['deliverypersonSFID'] ?? "";
    userLname = json['deliverypersonLname'] ?? "";
    userPicture = json['deliverypersonPic'] ?? "";
    userEmail = json['deliverypersonEmail'] ?? "";
    userHaddress = json['deliverypersonHaddress'] ?? "";
    userMobileno1 = json['deliverypersonMobileno1'] ?? "";
    userMobileno2 = json['deliverypersonMobileno2'] ?? "";
    userAadharno = json['deliverypersonAadharno'] ?? "";
    userPanno = json['deliverypersonPanno'] ?? "";
    userStateid = json['deliverypersonStateid'] ?? "";
    userCityid = json['deliverypersonCityid'] ?? "";
    userDistrict = json['deliverypersonDistrict'] ?? "";
    userPincode = json['deliverypersonPincode'] ?? "";
    userBankname = json['deliverypersonBankname'] ?? "";
    userAccountno = json['deliverypersonAccountno'] ?? "";
    userAccounthname = json['deliverypersonAccounthname'] ?? "";
    userIFSCcode = json['deliverypersonIFSCcode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliverypersonID'] = userID ?? "";
    data['deliverypersonFname'] = userFname ?? "";
    data['deliverypersonLname'] = userLname ?? "";
    data['deliverypersonPic'] = userPicture ?? "";
    data['deliverypersonEmail'] = userEmail ?? "";
    data['deliverypersonHaddress'] = userHaddress ?? "";
    data['deliverypersonMobileno1'] = userMobileno1 ?? "";
    data['deliverypersonMobileno2'] = userMobileno2 ?? "";
    data['deliverypersonAadharno'] = userAadharno ?? "";
    data['deliverypersonPanno'] = userPanno ?? "";
    data['deliverypersonStateid'] = userStateid ?? "";
    data['deliverypersonCityid'] = userCityid ?? "";
    data['deliverypersonDistrict'] = userDistrict ?? "";
    data['deliverypersonPincode'] = userPincode ?? "";
    data['deliverypersonBankname'] = userBankname ?? "";
    data['deliverypersonAccountno'] = userAccountno ?? "";
    data['deliverypersonAccounthname'] = userAccounthname ?? "";
    data['deliverypersonIFSCcode'] = userIFSCcode ?? "";
    return data;
  }
}
