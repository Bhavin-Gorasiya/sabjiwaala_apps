class ScanProduct {
  String? status;
  List<Farmer>? farmerdetails;
  List<ProductDetail>? productdetail;

  ScanProduct({
    this.status,
    this.farmerdetails,
    this.productdetail,
  });

  factory ScanProduct.fromJson(Map<String, dynamic> json) => ScanProduct(
        status: json["status"],
        farmerdetails: json["farmerdetails"] == null
            ? []
            : List<Farmer>.from(json["farmerdetails"]!.map((x) => Farmer.fromJson(x))),
        productdetail: json["productdetail"] == null
            ? []
            : List<ProductDetail>.from(json["productdetail"]!.map((x) => ProductDetail.fromJson(x))),
      );
}

class Farmer {
  String? userFname;
  String? userLname;
  String? userEmail;
  String? userPicture;
  DateTime? userDob;
  String? userGender;
  String? userPassword;
  String? userHaddress;
  String? userDoyou;
  String? userMobileno1;
  String? userBusinessType;
  String? userEducationName;
  String? userStateid;
  String? userCityid;
  String? userDistrict;
  String? userPincode;
  String? userBusinessexperiance;

  Farmer({
    this.userFname,
    this.userLname,
    this.userEmail,
    this.userPicture,
    this.userDob,
    this.userGender,
    this.userPassword,
    this.userHaddress,
    this.userDoyou,
    this.userMobileno1,
    this.userBusinessType,
    this.userEducationName,
    this.userStateid,
    this.userCityid,
    this.userDistrict,
    this.userPincode,
    this.userBusinessexperiance,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) => Farmer(
        userFname: json["userFname"] ?? "",
        userLname: json["userLname"] ?? "",
        userEmail: json["userEmail"] ?? "",
        userPicture: json["userPicture"] ?? "",
        userDob: json["userDob"] == null ? null : DateTime.parse(json["userDob"]),
        userGender: json["userGender"] ?? "",
        userPassword: json["userPassword"] ?? "",
        userHaddress: json["userHaddress"] ?? "",
        userDoyou: json["userDoyou"] ?? "",
        userMobileno1: json["userMobileno1"] ?? "",
        userBusinessType: json["userBusinessType"] ?? "",
        userEducationName: json["userEducationName"] ?? "",
        userStateid: json["userStateid"] ?? "",
        userCityid: json["userCityid"] ?? "",
        userDistrict: json["userDistrict"] ?? "",
        userPincode: json["userPincode"] ?? "",
        userBusinessexperiance: json["userBusinessexperiance"] ?? "",
      );
}

class ProductDetail {
  String? productId;
  String? productFarmerid;
  String? productCatid;
  String? productSubcatid;
  String? productName;
  String? productPrice;
  String? productTotalamt;
  String? productQty;
  String? productVqty;
  String? productHarvestFrom;
  String? productHarvestTo;
  String? productPic;
  String? productNPic;
  String? productDescription;
  List<NutritionData>? nutritiondata;

  ProductDetail({
    this.productId,
    this.productFarmerid,
    this.productCatid,
    this.productSubcatid,
    this.productName,
    this.productPrice,
    this.productTotalamt,
    this.productQty,
    this.productVqty,
    this.productHarvestFrom,
    this.productHarvestTo,
    this.productPic,
    this.productNPic,
    this.productDescription,
    this.nutritiondata,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        productId: json["productID"] ?? "",
        productFarmerid: json["productFarmerid"] ?? "",
        productCatid: json["productCatid"] ?? "",
        productSubcatid: json["productSubcatid"] ?? "",
        productName: json["productName"] ?? "",
        productPrice: json["productPrice"] ?? "",
        productTotalamt: json["productTotalamt"] ?? "",
        productQty: json["productQty"] ?? "",
        productVqty: json["productVqty"] ?? "",
        productHarvestFrom: json["productHarvestFrom"] ?? "",
        productHarvestTo: json["productHarvestTo"] ?? "",
        productPic: json["productPic"] ?? "",
        productNPic: json["productNPic"] ?? "",
        productDescription: json["productDescription"] ?? "",
        nutritiondata: json["nutritiondata"] == null
            ? []
            : List<NutritionData>.from(json["nutritiondata"]!.map((x) => NutritionData.fromJson(x))),
      );
}

class NutritionData {
  String? nutritionId;
  String? nutritionPid;
  String? nutritionType;
  String? nutritionName;
  DateTime? nutritionDate;
  String? nutritionStatus;

  NutritionData({
    this.nutritionId,
    this.nutritionPid,
    this.nutritionType,
    this.nutritionName,
    this.nutritionDate,
    this.nutritionStatus,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) => NutritionData(
        nutritionId: json["nutritionID"],
        nutritionPid: json["nutritionPid"],
        nutritionType: json["nutritionType"],
        nutritionName: json["nutritionName"],
        nutritionDate: json["nutritionDate"] == null ? null : DateTime.parse(json["nutritionDate"]),
        nutritionStatus: json["nutritionStatus"],
      );
}
