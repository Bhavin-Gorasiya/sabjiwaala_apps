class ProductModel {
  String? inventorysfrId;
  String? inventorysfrPid;
  String? inventorysfrCatid;
  String? inventorysfrScatid;
  String? inventorysfrPname;
  String? inventorysfrPPic;
  String? inventorysfrDesc;
  String? inventorysfrQrcode;
  String? inventorysfrSubfrid;
  String? inventorysfrFrid;
  String? inventorysfrQty;
  String? inventorysfrVqty;
  String? inventorysfrMfrid;
  String? inventorysfrTotalamt;
  String? inventorysfrPrice;
  String? inventorysfrPayStatus;
  DateTime? inventorysfrPayDate;
  DateTime? inventorysfrDate;
  List<Nutritiondatum>? nutritiondata;

  ProductModel({
    this.inventorysfrId,
    this.inventorysfrPid,
    this.inventorysfrCatid,
    this.inventorysfrScatid,
    this.inventorysfrPname,
    this.inventorysfrPPic,
    this.inventorysfrDesc,
    this.inventorysfrQrcode,
    this.inventorysfrSubfrid,
    this.inventorysfrFrid,
    this.inventorysfrQty,
    this.inventorysfrVqty,
    this.inventorysfrMfrid,
    this.inventorysfrTotalamt,
    this.inventorysfrPrice,
    this.inventorysfrPayStatus,
    this.inventorysfrPayDate,
    this.inventorysfrDate,
    this.nutritiondata,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        inventorysfrId: json["inventorysfrID"] ?? "",
        inventorysfrPid: json["inventorysfrPid"] ?? "",
        inventorysfrCatid: json["inventorysfrCatid"] ?? "",
        inventorysfrScatid: json["inventorysfrScatid"] ?? "",
        inventorysfrPname: json["inventorysfrPname"] ?? "",
        inventorysfrPPic: json["inventorysfrPPic"] ?? "",
        inventorysfrDesc: json["inventorysfrDesc"] ?? "",
        inventorysfrQrcode: json["inventorysfrQrcode"] ?? "",
        inventorysfrSubfrid: json["inventorysfrSubfrid"] ?? "",
        inventorysfrFrid: json["inventorysfrFrid"] ?? "",
        inventorysfrQty: json["inventorysfrQty"] ?? "",
        inventorysfrVqty: json["inventorysfrVqty"] ?? "",
        inventorysfrMfrid: json["inventorysfrMfrid"] ?? "",
        inventorysfrTotalamt: json["inventorysfrTotalamt"] ?? "",
        inventorysfrPrice: json["inventorysfrPrice"] ?? "",
        inventorysfrPayStatus: json["inventorysfrPayStatus"] ?? "",
        inventorysfrPayDate:
            json["inventorysfrPayDate"] == null ? DateTime.now() : DateTime.parse(json["inventorysfrPayDate"]),
        inventorysfrDate: json["inventorysfrDate"] == null ? DateTime.now() : DateTime.parse(json["inventorysfrDate"]),
        nutritiondata: json["nutritiondata"] == null
            ? []
            : List<Nutritiondatum>.from(json["nutritiondata"]!.map((x) => Nutritiondatum.fromJson(x))),
      );
}

class InventoryModel {
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
  List<Nutritiondatum>? nutritiondata;

  InventoryModel({
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
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        userproductId: json["userproductID"] ?? "",
        userproductFamerid: json["userproductFamerid"] ?? "",
        userproductSubfid: json["userproductSubfid"] ?? "",
        userproductPid: json["userproductPid"] ?? "",
        userproductCatid: json["userproductCatid"] ?? "",
        userproductScatid: json["userproductScatid"] ?? "",
        userproductPname: json["userproductPname"] ?? "",
        userproductPPic: json["userproductPPic"] ?? "",
        userproductDesc: json["userproductDesc"] ?? "",
        userproductQrcode: json["userproductQrcode"] ?? "",
        userproductQty: json["userproductQty"] ?? "",
        userproductTotalamt: json["userproductTotalamt"] ?? "",
        userproductPrice: json["userproductPrice"] ?? "",
        userproductDate: json["userproductDate"] == null ? null : DateTime.parse(json["userproductDate"]),
        nutritiondata: json["nutritiondata"] == null
            ? []
            : List<Nutritiondatum>.from(json["nutritiondata"]!.map((x) => Nutritiondatum.fromJson(x))),
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
        nutritionId: json["nutritionID"] ?? "",
        nutritionPid: json["nutritionPid"] ?? "",
        nutritionType: json["nutritionType"] ?? "",
        nutritionName: json["nutritionName"] ?? "",
        nutritionDate: json["nutritionDate"] == null ? DateTime.now() : DateTime.parse(json["nutritionDate"]),
        nutritionStatus: json["nutritionStatus"] ?? "",
      );
}

class UnitModel {
  String? unitsID;
  String? unitsName;
  String? unitsStatus;

  UnitModel({
    this.unitsID,
    this.unitsName,
    this.unitsStatus,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        unitsID: json["unitsID"] ?? "",
        unitsName: json["unitsName"] ?? "",
        unitsStatus: json["unitsStatus"] ?? "",
      );
}

class Discount {
  String? discountID;
  String? discountPercent;

  Discount({
    this.discountID,
    this.discountPercent,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        discountID: json["discountID"] ?? "",
        discountPercent: json["discountPercent"] ?? "",
      );
}

class RequestMore {
  String requestqtyUname;
  String requestqtyPname;
  String requestqtyPid;
  String requestqtyQty;
  String requestqtyFuid;
  String requestqtyTuid;
  String requestqtyTag;

  RequestMore({
    required this.requestqtyUname,
    required this.requestqtyPname,
    required this.requestqtyPid,
    required this.requestqtyQty,
    required this.requestqtyFuid,
    required this.requestqtyTuid,
    required this.requestqtyTag,
  });

  factory RequestMore.fromJson(Map<String, dynamic> json) => RequestMore(
        requestqtyUname: json["requestqtyUname"],
        requestqtyPname: json["requestqtyPname"],
        requestqtyPid: json["requestqtyPid"],
        requestqtyQty: json["requestqtyQty"],
        requestqtyFuid: json["requestqtyFuid"],
        requestqtyTuid: json["requestqtyTuid"],
        requestqtyTag: json["requestqtyTag"],
      );

  Map<String, dynamic> toJson() => {
        "requestqtyUname": requestqtyUname,
        "requestqtyPname": requestqtyPname,
        "requestqtyPid": requestqtyPid,
        "requestqtyQty": requestqtyQty,
        "requestqtyFuid": requestqtyFuid,
        "requestqtyTuid": requestqtyTuid,
        "requestqtyTag": requestqtyTag,
      };
}

class GetRequestMore {
  String? requestqtyId;
  String? requestqtyUname;
  String? requestqtyPname;
  String? requestqtyPid;
  String? requestqtyQty;
  String? requestqtyFuid;
  String? requestqtyTuid;
  DateTime? requestqtyDate;
  String? requestqtyTag;
  String? requestqtyStatus;

  GetRequestMore({
    this.requestqtyId,
    this.requestqtyUname,
    this.requestqtyPname,
    this.requestqtyPid,
    this.requestqtyQty,
    this.requestqtyFuid,
    this.requestqtyTuid,
    this.requestqtyDate,
    this.requestqtyTag,
    this.requestqtyStatus,
  });

  factory GetRequestMore.fromJson(Map<String, dynamic> json) => GetRequestMore(
    requestqtyId: json["requestqtyID"] ?? "",
    requestqtyUname: json["requestqtyUname"] ?? "",
    requestqtyPname: json["requestqtyPname"] ?? "",
    requestqtyPid: json["requestqtyPid"] ?? "",
    requestqtyQty: json["requestqtyQty"] ?? "",
    requestqtyFuid: json["requestqtyFuid"] ?? "",
    requestqtyTuid: json["requestqtyTuid"] ?? "",
    requestqtyDate: json["requestqtyDate"] == null ? DateTime.now() : DateTime.parse(json["requestqtyDate"]),
    requestqtyTag: json["requestqtyTag"] ?? "",
    requestqtyStatus: json["requestqtyStatus"] ?? "",
  );
}

class Review {
  String? reviewId;
  String? reviewTag;
  String? reviewCid;
  String? reviewVid;
  String? reviewPid;
  String? reviewRating;
  String? reviewDesc;
  DateTime? reviewDate;
  String? customerName;
  String? customerPicture;
  String? productName;
  String? productPicture;
  String? productDesc;

  Review({
    this.reviewId,
    this.reviewTag,
    this.reviewCid,
    this.reviewVid,
    this.reviewPid,
    this.reviewRating,
    this.reviewDesc,
    this.reviewDate,
    this.customerName,
    this.customerPicture,
    this.productName,
    this.productPicture,
    this.productDesc,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json["reviewID"],
    reviewTag: json["reviewTag"],
    reviewCid: json["reviewCid"],
    reviewVid: json["reviewVid"],
    reviewPid: json["reviewPid"],
    reviewRating: json["reviewRating"],
    reviewDesc: json["reviewDesc"],
    reviewDate: json["reviewDate"] == null ? null : DateTime.parse(json["reviewDate"]),
    customerName: json["customerName"],
    customerPicture: json["customerPicture"],
    productName: json["productName"],
    productPicture: json["productPicture"],
    productDesc: json["productDesc"],
  );

  Map<String, dynamic> toJson() => {
    "reviewID": reviewId,
    "reviewTag": reviewTag,
    "reviewCid": reviewCid,
    "reviewVid": reviewVid,
    "reviewPid": reviewPid,
    "reviewRating": reviewRating,
    "reviewDesc": reviewDesc,
    "reviewDate": reviewDate?.toIso8601String(),
    "customerName": customerName,
    "customerPicture": customerPicture,
    "productName": productName,
    "productPicture": productPicture,
    "productDesc": productDesc,
  };
}


