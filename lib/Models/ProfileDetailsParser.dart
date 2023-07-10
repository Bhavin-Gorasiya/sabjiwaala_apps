class ProfileDetailsParser {
  String? userID;
  String? userContracttype;
  String? userType;
  String? userUid;
  String? userEmpid;
  String? userFname;
  String? userLname;
  String? userPicture;
  String? userEmail;
  String? userDob;
  String? userGender;
  String? userPassword;
  String? userFcmtoken;
  String? userPlatformos;
  String? userHaddress;
  String? userDoyou;
  String? userMobileno1;
  String? userMobileno2;
  String? userAadharno;
  String? userAadharpic;
  String? userPanno;
  String? userPanpic;
  String? userDrivingLicence;
  String? userDrivingLicencepic;
  String? usersVoteridno;
  String? usersVoteridpic;
  String? userPassportNo;
  String? userPassportPic;
  String? userBusinessType;
  String? userEducationName;
  String? userEducationfile;
  String? userOfficearea;
  String? userBaddress;
  String? userStateid;
  String? userCityid;
  String? userDistrict;
  String? userPincode;
  String? userBankname;
  String? userAccountno;
  String? userAccounthname;
  String? userIFSCcode;
  String? userBranchaddress;
  String? userYearlyincome;
  String? userMarriedstatus;
  String? userRefrancesdetails;
  String? userRefrancesdetails2;
  String? userBusinessexperiance;
  String? userOtherbusiness;
  String? userAgreementFile;
  String? userResume;
  String? userOfferletter;
  String? userDate;
  String? userVerificationstatus;
  String? userStatus;
  String? userCrops;
  String? userLand;

  ProfileDetailsParser(
      {this.userID,
      this.userContracttype,
      this.userType,
      this.userUid,
      this.userEmpid,
      this.userFname,
      this.userLname,
      this.userPicture,
      this.userEmail,
      this.userDob,
      this.userGender,
      this.userPassword,
      this.userFcmtoken,
      this.userPlatformos,
      this.userHaddress,
      this.userDoyou,
      this.userMobileno1,
      this.userMobileno2,
      this.userAadharno,
      this.userAadharpic,
      this.userPanno,
      this.userPanpic,
      this.userDrivingLicence,
      this.userDrivingLicencepic,
      this.usersVoteridno,
      this.usersVoteridpic,
      this.userPassportNo,
      this.userPassportPic,
      this.userBusinessType,
      this.userEducationName,
      this.userEducationfile,
      this.userOfficearea,
      this.userBaddress,
      this.userStateid,
      this.userCityid,
      this.userDistrict,
      this.userPincode,
      this.userBankname,
      this.userAccountno,
      this.userAccounthname,
      this.userIFSCcode,
      this.userBranchaddress,
      this.userYearlyincome,
      this.userMarriedstatus,
      this.userRefrancesdetails,
      this.userRefrancesdetails2,
      this.userBusinessexperiance,
      this.userOtherbusiness,
      this.userAgreementFile,
      this.userResume,
      this.userOfferletter,
      this.userDate,
      this.userVerificationstatus,
      this.userCrops,
      this.userLand,
      this.userStatus});

  ProfileDetailsParser.fromJson(Map<String, dynamic> json) {
    userID = json['userID'] ?? "";
    userContracttype = json['userContracttype'] ?? "";
    userType = json['userType'] ?? "";
    userUid = json['userUid'] ?? "";
    userEmpid = json['userEmpid'] ?? "";
    userFname = json['userFname'] ?? "";
    userLname = json['userLname'] ?? "";
    userPicture = json['userPicture'] ?? "";
    userEmail = json['userEmail'] ?? "";
    userDob = json['userDob'] ?? "";
    userGender = json['userGender'] ?? "";
    userPassword = json['userPassword'] ?? "";
    userFcmtoken = json['userFcmtoken'] ?? "";
    userPlatformos = json['userPlatformos'] ?? "";
    userHaddress = json['userHaddress'] ?? "";
    userDoyou = json['userDoyou'] ?? "";
    userMobileno1 = json['userMobileno1'] ?? "";
    userMobileno2 = json['userMobileno2'] ?? "";
    userAadharno = json['userAadharno'] ?? "";
    userAadharpic = json['userAadharpic'] ?? "";
    userPanno = json['userPanno'] ?? "";
    userPanpic = json['userPanpic'] ?? "";
    userDrivingLicence = json['userDrivingLicence'] ?? "";
    userDrivingLicencepic = json['userDrivingLicencepic'] ?? "";
    usersVoteridno = json['usersVoteridno'] ?? "";
    usersVoteridpic = json['usersVoteridpic'] ?? "";
    userPassportNo = json['userPassportNo'] ?? "";
    userPassportPic = json['userPassportPic'] ?? "";
    userBusinessType = json['userBusinessType'] ?? "";
    userEducationName = json['userEducationName'] ?? "";
    userEducationfile = json['userEducationfile'] ?? "";
    userOfficearea = json['userOfficearea'] ?? "";
    userBaddress = json['userBaddress'] ?? "";
    userStateid = json['userStateid'] ?? "";
    userCityid = json['userCityid'] ?? "";
    userDistrict = json['userDistrict'] ?? "";
    userPincode = json['userPincode'] ?? "";
    userBankname = json['userBankname'] ?? "";
    userAccountno = json['userAccountno'] ?? "";
    userAccounthname = json['userAccounthname'] ?? "";
    userIFSCcode = json['userIFSCcode'] ?? "";
    userBranchaddress = json['userBranchaddress'] ?? "";
    userYearlyincome = json['userYearlyincome'] ?? "";
    userMarriedstatus = json['userMarriedstatus'] ?? "";
    userRefrancesdetails = json['userRefrancesdetails'] ?? "";
    userRefrancesdetails2 = json['userRefrancesdetails2'] ?? "";
    userBusinessexperiance = json['userBusinessexperiance'] ?? "";
    userOtherbusiness = json['userOtherbusiness'] ?? "";
    userAgreementFile = json['userAgreementFile'] ?? "";
    userResume = json['userResume'] ?? "";
    userOfferletter = json['userOfferletter'] ?? "";
    userDate = json['userDate'] ?? "";
    userVerificationstatus = json['userVerificationstatus'] ?? "";
    userStatus = json['userStatus'] ?? "";
    userCrops = json["userCrops"] ?? "";
    userLand = json["userLand"] ?? "";
    userOfficearea = json["userOfficearea"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID ?? "";
    data['userContracttype'] = userContracttype ?? "";
    data['userType'] = userType ?? "";
    data['userUid'] = userUid ?? "";
    data['userFname'] = userFname ?? "";
    data['userLname'] = userLname ?? "";
    data['userPicture'] = userPicture ?? "";
    data['userEmail'] = userEmail ?? "";
    data['userDob'] = userDob ?? "";
    data['userGender'] = userGender ?? "";
    data['userPassword'] = userPassword ?? "";
    data['userFcmtoken'] = userFcmtoken ?? "";
    data['userPlatformos'] = userPlatformos ?? "";
    data['userHaddress'] = userHaddress ?? "";
    data['userDoyou'] = userDoyou ?? "";
    data['userMobileno1'] = userMobileno1 ?? "";
    data['userMobileno2'] = userMobileno2 ?? "";
    data['userAadharno'] = userAadharno ?? "";
    data['userAadharpic'] = userAadharpic ?? "";
    data['userPanno'] = userPanno ?? "";
    data['userPanpic'] = userPanpic ?? "";
    data['userDrivingLicence'] = userDrivingLicence ?? "";
    data['userDrivingLicencepic'] = userDrivingLicencepic ?? "";
    data['usersVoteridno'] = usersVoteridno ?? "";
    data['usersVoteridpic'] = usersVoteridpic ?? "";
    data['userPassportNo'] = userPassportNo ?? "";
    data['userPassportPic'] = userPassportPic ?? "";
    data['userBusinessType'] = userBusinessType ?? "";
    data['userEducationName'] = userEducationName ?? "";
    data['userEducationfile'] = userEducationfile ?? "";
    data['userOfficearea'] = userOfficearea ?? "";
    data['userBaddress'] = userBaddress ?? "";
    data['userStateid'] = userStateid ?? "";
    data['userCityid'] = userCityid ?? "";
    data['userDistrict'] = userDistrict ?? "";
    data['userPincode'] = userPincode ?? "";
    data['userBankname'] = userBankname ?? "";
    data['userAccountno'] = userAccountno ?? "";
    data['userAccounthname'] = userAccounthname ?? "";
    data['userIFSCcode'] = userIFSCcode ?? "";
    data['userBranchaddress'] = userBranchaddress ?? "";
    data['userYearlyincome'] = userYearlyincome ?? "";
    data['userMarriedstatus'] = userMarriedstatus ?? "";
    data['userRefrancesdetails'] = userRefrancesdetails ?? "";
    data['userRefrancesdetails2'] = userRefrancesdetails2 ?? "";
    data['userBusinessexperiance'] = userBusinessexperiance ?? "";
    data['userOtherbusiness'] = userOtherbusiness ?? "";
    data['userAgreementFile'] = userAgreementFile ?? "";
    data['userResume'] = userResume ?? "";
    data['userOfferletter'] = userOfferletter ?? "";
    data['userDate'] = userDate ?? "";
    data['userVerificationstatus'] = userVerificationstatus ?? "";
    data['userStatus'] = userStatus ?? "";
    data["userCrops"] = userCrops ?? "";
    data["userLand"] = userLand ?? "";
    data["userOfficearea"] = userOfficearea ?? "";
    return data;
  }
}

class Enquiry {
  Enquiry({
    this.enquiryName,
    this.enquiryEmp,
    this.enquiryUid,
    this.enquiryUtype,
    this.enquiryEmail,
    this.enquiryPhoneno,
    this.enquirySubject,
    this.enquiryMessage,
    // this.type,
  });

  String? enquiryName;
  String? enquiryEmp;
  String? enquiryUid;
  String? enquiryUtype;
  String? enquiryEmail;
  String? enquiryPhoneno;
  String? enquirySubject;
  String? enquiryMessage;
// String? type;
}
