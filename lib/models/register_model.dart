import 'dart:io';

class RegisterModel {
  RegisterModel({
    this.customerID,
    this.customerFirstname,
    this.customerLastname,
    this.customerDob,
    this.customerGender,
    this.customerEmail,
    this.customerPassword,
    this.customerPhoneno,
    this.customerReferCode,
    this.customerReferByCode,
    this.customerWalletAmount,
    this.platformOs,
    this.customerFcmtoken,
    this.customerState,
    this.customerCity,
    this.customerAddress,
    this.customerLat,
    this.customerLong,
    this.customerPic,
    this.customerBoi,
    this.customerDate,
    this.customerStatus,
  });

  String? customerID;
  String? customerFirstname;
  String? customerLastname;
  String? customerDob;
  String? customerGender;
  String? customerEmail;
  String? customerPassword;
  String? customerPhoneno;
  String? customerReferCode;
  String? customerReferByCode;
  String? customerWalletAmount;
  String? platformOs;
  String? customerFcmtoken;
  String? customerState;
  String? customerCity;
  String? customerAddress;
  String? customerLat;
  String? customerLong;
  String? customerPic;
  String? customerBoi;
  String? customerDate;
  String? customerStatus;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        customerID: json["customerID"] ?? '',
        customerFirstname: json["customerFirstname"] ?? '',
        customerLastname: json["customerLastname"] ?? '',
        customerDob: json["customerDob"] ?? '',
        customerGender: json["customerGender"] ?? '',
        customerEmail: json["customerEmail"] ?? '',
        customerPassword: json["customerPassword"] ?? '',
        customerPhoneno: json["customerPhoneno"] ?? '',
        customerReferCode: json["customerReferCode"] ?? '',
        customerReferByCode: json["customerReferByCode"] ?? '',
        customerWalletAmount: json["customerWallet_amount"] ?? '',
        platformOs: json["Platform_os"] ?? '',
        customerFcmtoken: json["customerFcmtoken"] ?? '',
        customerState: json["customerState"] ?? '',
        customerCity: json["customerCity"] ?? '',
        customerAddress: json["customerAddress"] ?? '',
        customerLat: json["customerLat"] ?? '',
        customerPic: json["customerPic"] ?? '',
        customerBoi: json["customerBoi"] ?? '',
        customerDate: json["customerDate"] ?? '',
        customerStatus: json["customerStatus"] ?? '',
      );
}

class RegisterRequiredModel {
  RegisterRequiredModel({
    this.customerPhoneno,
    this.customerFirstname,
    this.customerLastname,
    this.customerEmail,
    this.customerLat,
    this.customerLong,
    this.customerAddress,
    this.customerState,
    this.customerCity,
    this.customerBoi,
    this.platformOs,
    this.customerWalletAmount,
    this.customerFcmtoken,
    this.customerReferCode,
    this.customerReferByCode,
    this.customerDob,
    this.customerGender,
    this.customerPic
  });

  String? customerPhoneno;
  String? customerFirstname;
  String? customerLastname;
  String? customerEmail;
  String? customerLat;
  String? customerLong;
  String? customerAddress;
  String? customerState;
  String? customerCity;
  String? customerBoi;
  String? platformOs;
  String? customerWalletAmount;
  String? customerFcmtoken;
  String? customerReferCode;
  String? customerReferByCode;
  String? customerDob;
  String? customerGender;
  String? customerPic;

  /*factory RegisterRequiredModel.fromJson(Map<String, dynamic> json) => RegisterRequiredModel(
        customerPhoneno: json["customerPhoneno"] ?? '',
        customerFirstname: json["customerFirstname"] ?? '',
        customerLastname: json["customerLastname"] ?? '',
        customerEmail: json["customerEmail"] ?? '',
        customerLat: json["customerLat"] ?? '',
        customerLong: json["customerLong"] ?? '',
        customerAddress: json["customerAddress"] ?? '',
        customerState: json["customerState"] ?? '',
        customerCity: json["customerCity"] ?? '',
        customerBoi: json["customerBoi"] ?? '',
        platformOs: json["Platform_os"] ?? '',
        customerWalletAmount: json["customerWallet_amount"] ?? '',
        customerFcmtoken: json["customerFcmtoken"] ?? '',
        customerReferCode: json["customerReferCode"] ?? '',
        customerReferByCode: json["customerReferByCode"] ?? '',
        customerDob: json["customerDob"] ?? '',
        customerGender: json["customerGender"] ?? '',
        customerPic: json["customerPic"] ?? '',
      );*/
}
