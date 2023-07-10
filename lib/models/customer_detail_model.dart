class CustomerDetailModel {
  CustomerDetailModel({
    this.customerId,
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

  String? customerId;
  String? customerFirstname;
  String? customerLastname;
  String? customerDob;
  String? customerGender;
  String? customerEmail;
  dynamic customerPassword;
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
  DateTime? customerDate;
  String? customerStatus;

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) => CustomerDetailModel(
        customerId: json["customerID"] ?? '',
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
        customerLong: json["customerLong"] ?? '',
        customerPic: json["customerPic"] ?? '',
        customerBoi: json["customerBoi"] ?? '',
        customerDate: DateTime.parse(json["customerDate"]) ?? DateTime.now(),
        customerStatus: json["customerStatus"] ?? '',
      );
}

class AddressModel {
  AddressModel({
    required this.addressesId,
    required this.addressesCustomerId,
    required this.addressesAddress,
    required this.addressesLandmark,
    required this.addressesLat,
    required this.addressesLong,
    required this.addressesStatus,
    required this.addressesTag,
  });

  String addressesId;
  String addressesCustomerId;
  String addressesAddress;
  String addressesLandmark;
  String addressesLat;
  String addressesLong;
  String addressesStatus;
  String addressesTag;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    addressesId: json["addressesID"],
    addressesCustomerId: json["addressesCustomerID"],
    addressesAddress: json["addressesAddress"],
    addressesLandmark: json["addressesLandmark"],
    addressesLat: json["addressesLat"],
    addressesLong: json["addressesLong"],
    addressesStatus: json["addressesStatus"],
    addressesTag: json["addressesTag"],
  );

  Map<String, dynamic> toJson() => {
    "addressesID": addressesId,
    "addressesCustomerID": addressesCustomerId,
    "addressesAddress": addressesAddress,
    "addressesLandmark": addressesLandmark,
    "addressesLat": addressesLat,
    "addressesLong": addressesLong,
    "addressesStatus": addressesStatus,
    "addressesTag": addressesTag,
  };
}
