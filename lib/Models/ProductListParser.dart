class ProductListParser {
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
  String? productQrcode;
  String? productDescription;
  String? productPay;
  DateTime? productDate;
  String? productStatus;
  List<Nutritiondatum>? nutritiondata;

  ProductListParser({
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
    this.productQrcode,
    this.productDescription,
    this.productPay,
    this.productDate,
    this.productStatus,
    this.nutritiondata,
  });

  factory ProductListParser.fromJson(Map<String, dynamic> json) => ProductListParser(
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
        productQrcode: json["productQrcode"] ?? "",
        productDescription: json["productDescription"] ?? "",
        productPay: json["productPay"] ?? "",
        productDate: json["productDate"] == null ? DateTime.now() : DateTime.parse(json["productDate"]),
        productStatus: json["productStatus"],
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
  String? nutritionStatus;

  Nutritiondatum({
    this.nutritionId,
    this.nutritionPid,
    this.nutritionType,
    this.nutritionName,
    this.nutritionStatus,
  });

  factory Nutritiondatum.fromJson(Map<String, dynamic> json) => Nutritiondatum(
        nutritionId: json["nutritionID"] ?? "",
        nutritionPid: json["nutritionPid"] ?? "",
        nutritionType: json["nutritionType"] ?? "",
        nutritionName: json["nutritionName"] ?? "",
        nutritionStatus: json["nutritionStatus"] ?? "",
      );
}

class AddProductModel {
  String? productFarmerid;
  String? productCatid;
  String? productName;
  String? productPrice;
  String? productDescription;
  String? productTotalamt;
  String? productQty;
  String? productHarvestFrom;
  String? productHarvestTo;
  String? productSubcatid;
  String? productPic;
  List<Map<String, dynamic>>? nutritiondata;

  AddProductModel({
    this.productFarmerid,
    this.productCatid,
    this.productName,
    this.productPrice,
    this.productDescription,
    this.productTotalamt,
    this.productQty,
    this.productHarvestFrom,
    this.productHarvestTo,
    this.productSubcatid,
    this.productPic,
    this.nutritiondata,
  });

  AddProductModel.fromJson(Map<dynamic, dynamic> json) {
    productFarmerid = json['productFarmerid'] ?? "";
    productCatid = json['productCatid'] ?? "";
    productName = json['productName'] ?? "";
    productPrice = json['productPrice'] ?? "";
    productDescription = json['productDescription'] ?? "";
    productTotalamt = json['productTotalamt'] ?? "";
    productQty = json['productQty'] ?? "";
    productHarvestFrom = json['productHarvestFrom'] ?? "";
    productHarvestTo = json['productHarvestTo'] ?? "";
    productSubcatid = json['productSubcatid'] ?? "";
    productPic = json['productPic'] ?? "";
    nutritiondata = json['nutritiondata'] ?? [];
  }
}

class EditProductModel {
  String? productID;
  String? productFarmerid;
  String? productCatid;
  String? productSubcatid;
  String? productName;
  String? productPrice;
  String? productDescription;
  String? productTotalamt;
  String? productQty;
  String? productHarvestFrom;
  String? productHarvestTo;
  String? productPic;
  List<Map<String, dynamic>>? nutritiondata;

  EditProductModel({
    this.productID,
    this.productFarmerid,
    this.productCatid,
    this.productSubcatid,
    this.productName,
    this.productPrice,
    this.productDescription,
    this.productTotalamt,
    this.productQty,
    this.productHarvestFrom,
    this.productHarvestTo,
    this.productPic,
    this.nutritiondata,
  });

  EditProductModel.fromJson(Map<dynamic, dynamic> json) {
    productID = json['productID'];
    productFarmerid = json['productFarmerid'];
    productCatid = json['productCatid'];
    productSubcatid = json['productSubcatid'];
    productName = json['productName'];
    productPrice = json['productPrice'];
    productDescription = json['productDescription'];
    productTotalamt = json['productTotalamt'];
    productQty = json['productQty'];
    productHarvestFrom = json['productHarvestFrom'];
    productHarvestTo = json['productHarvestTo'];
    productPic = json['productPic'];
    nutritiondata = json['nutritiondata'];
  }
}

class Review {
  String? reviewId;
  String? reviewCid;
  String? reviewVid;
  String? reviewPid;
  String? reviewRating;
  String? reviewDesc;
  DateTime? reviewDate;
  String? customerName;

  Review({
    this.reviewId,
    this.reviewCid,
    this.reviewVid,
    this.reviewPid,
    this.reviewRating,
    this.reviewDesc,
    this.reviewDate,
    this.customerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json["reviewID"],
    reviewCid: json["reviewCid"],
    reviewVid: json["reviewVid"],
    reviewPid: json["reviewPid"],
    reviewRating: json["reviewRating"],
    reviewDesc: json["reviewDesc"],
    reviewDate: json["reviewDate"] == null ? null : DateTime.parse(json["reviewDate"]),
    customerName: json["CustomerName"],
  );
}
