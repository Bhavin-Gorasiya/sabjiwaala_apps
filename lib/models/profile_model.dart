class ProfileModel {
  String? userID;
  String? userUid;
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
  String? userStatus;
  String? userPercentage;

  ProfileModel(
      {this.userID,
      this.userUid,
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
      this.userPercentage,
      this.userStatus,
      this.userIFSCcode});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'] ?? "";
    userUid = json['userUid'] ?? "";
    userFname = json['userFname'] ?? "";
    userLname = json['userLname'] ?? "";
    userPicture = json['userPicture'] ?? "";
    userEmail = json['userEmail'] ?? "";
    userHaddress = json['userHaddress'] ?? "";
    userMobileno1 = json['userMobileno1'] ?? "";
    userMobileno2 = json['userMobileno2'] ?? "";
    userAadharno = json['userAadharno'] ?? "";
    userPanno = json['userPanno'] ?? "";
    userStateid = json['userStateid'] ?? "";
    userCityid = json['userCityid'] ?? "";
    userDistrict = json['userDistrict'] ?? "";
    userPincode = json['userPincode'] ?? "";
    userBankname = json['userBankname'] ?? "";
    userAccountno = json['userAccountno'] ?? "";
    userAccounthname = json['userAccounthname'] ?? "";
    userIFSCcode = json['userIFSCcode'] ?? "";
    userStatus = json['userStatus'] ?? "0";
    userPercentage = json['userPercentage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID ?? "";
    data['userUid'] = userUid ?? "";
    data['userFname'] = userFname ?? "";
    data['userLname'] = userLname ?? "";
    data['userPicture'] = userPicture ?? "";
    data['userEmail'] = userEmail ?? "";
    data['userHaddress'] = userHaddress ?? "";
    data['userMobileno1'] = userMobileno1 ?? "";
    data['userMobileno2'] = userMobileno2 ?? "";
    data['userAadharno'] = userAadharno ?? "";
    data['userPanno'] = userPanno ?? "";
    data['userStateid'] = userStateid ?? "";
    data['userCityid'] = userCityid ?? "";
    data['userDistrict'] = userDistrict ?? "";
    data['userPincode'] = userPincode ?? "";
    data['userBankname'] = userBankname ?? "";
    data['userAccountno'] = userAccountno ?? "";
    data['userAccounthname'] = userAccounthname ?? "";
    data['userIFSCcode'] = userIFSCcode ?? "";
    data['userStatus'] = userStatus ?? "0";
    data['userPercentage'] = userPercentage ?? "";
    return data;
  }
}
