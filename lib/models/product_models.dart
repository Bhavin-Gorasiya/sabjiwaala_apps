class ProductModel {
  String? userproductId;
  String? userproductFamerid;
  String? userproductSubfid;
  String? userproductPid;
  String? userproductCatid;
  String? userproductScatid;
  String? userproductPname;
  String? userproductPPic;
  String? userproductDesc;
  String? userproductQrcode;
  String? userproductQty;
  String? userproductTotalamt;
  String? userproductPrice;
  DateTime? userproductDate;
  bool isCart;
  List<Nutritiondatum>? nutritiondata;

  ProductModel({
    this.userproductId,
    this.userproductFamerid,
    this.userproductSubfid,
    this.userproductPid,
    this.userproductCatid,
    this.userproductScatid,
    this.userproductPname,
    this.userproductPPic,
    this.userproductDesc,
    this.userproductQrcode,
    this.userproductQty,
    this.userproductTotalamt,
    this.userproductPrice,
    this.userproductDate,
    this.nutritiondata,
    this.isCart = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        userproductId: json["userproductID"],
        userproductFamerid: json["userproductFamerid"],
        userproductSubfid: json["userproductSubfid"],
        userproductPid: json["userproductPid"],
        userproductCatid: json["userproductCatid"],
        userproductScatid: json["userproductScatid"],
        userproductPname: json["userproductPname"],
        userproductPPic: json["userproductPPic"],
        userproductDesc: json["userproductDesc"],
        userproductQrcode: json["userproductQrcode"],
        userproductQty: json["userproductQty"],
        userproductTotalamt: json["userproductTotalamt"],
        userproductPrice: json["userproductPrice"],
        userproductDate: json["userproductDate"] == null ? null : DateTime.parse(json["userproductDate"]),
        nutritiondata: json["nutritiondata"] == null
            ? []
            : List<Nutritiondatum>.from(json["nutritiondata"].map((x) => Nutritiondatum.fromJson(x))),
        isCart: json["is_cart"] == "True" ? true : false,
      );
}

class Nutritiondatum {
  String? nutritionId;
  String? nutritionPid;
  String? nutritionType;
  String? nutritionName;
  DateTime? nutritionDate;
  String? nutritionStatus;

  Nutritiondatum({
    this.nutritionId,
    this.nutritionPid,
    this.nutritionType,
    this.nutritionName,
    this.nutritionDate,
    this.nutritionStatus,
  });

  factory Nutritiondatum.fromJson(Map<String, dynamic> json) => Nutritiondatum(
        nutritionId: json["nutritionID"],
        nutritionPid: json["nutritionPid"],
        nutritionType: json["nutritionType"],
        nutritionName: json["nutritionName"],
        nutritionDate: json["nutritionDate"] == null ? null : DateTime.parse(json["nutritionDate"]),
        nutritionStatus: json["nutritionStatus"],
      );

  Map<String, dynamic> toJson() => {
        "nutritionID": nutritionId,
        "nutritionPid": nutritionPid,
        "nutritionType": nutritionType,
        "nutritionName": nutritionName,
        "nutritionDate": nutritionDate?.toIso8601String(),
        "nutritionStatus": nutritionStatus,
      };
}

class VendorProfile {
  String? userId;
  String? userUid;
  String? userEmpid;
  String? userFname;
  String? userLname;
  String? userEmail;
  String? userPicture;
  String? userDob;
  String? userGender;
  String? userFcmtoken;
  String? userHaddress;
  String? userMobileno1;
  String? userMobileno2;
  String? userLat;
  String? userLong;
  String? userStateid;
  String? userCityid;
  String? userDistrict;
  String? userPincode;
  String? userStatus;
  List<Categories>? category;

  VendorProfile({
    this.userId,
    this.userUid,
    this.userEmpid,
    this.userFname,
    this.userLname,
    this.userEmail,
    this.userPicture,
    this.userDob,
    this.userGender,
    this.userFcmtoken,
    this.userHaddress,
    this.userMobileno1,
    this.userMobileno2,
    this.userLat,
    this.userLong,
    this.userStateid,
    this.userCityid,
    this.userDistrict,
    this.userPincode,
    this.userStatus,
    this.category,
  });

  factory VendorProfile.fromJson(Map<String, dynamic> json) => VendorProfile(
        userId: json["userID"] ?? "",
        userUid: json["userUid"] ?? "",
        userEmpid: json["userEmpid"] ?? "",
        userFname: json["userFname"] ?? "",
        userLname: json["userLname"] ?? "",
        userEmail: json["userEmail"] ?? "",
        userPicture: json["userPicture"] ?? "",
        userDob: json["userDob"] ?? "",
        userGender: json["userGender"] ?? "",
        userFcmtoken: json["userFcmtoken"] ?? "",
        userHaddress: json["userHaddress"] ?? "",
        userMobileno1: json["userMobileno1"] ?? "",
        userMobileno2: json["userMobileno2"] ?? "",
        userLat: json["userLat"] ?? "0.0",
        userLong: json["userLong"] ?? "0.0",
        userStateid: json["userStateid"] ?? "",
        userCityid: json["userCityid"] ?? "",
        userDistrict: json["userDistrict"] ?? "",
        userPincode: json["userPincode"] ?? "",
        userStatus: json["userStatus"] ?? "",
        category:
            json["category"] == null ? [Categories()] : List<Categories>.from(json["category"].map((x) => Categories.fromJson(x))),
      );
}

class Categories {
  String? catid;
  String? subcatid;

  Categories({
    this.catid,
    this.subcatid,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        catid: json["catid"] ?? "",
        subcatid: json["subcatid"] ?? "",
      );
}
