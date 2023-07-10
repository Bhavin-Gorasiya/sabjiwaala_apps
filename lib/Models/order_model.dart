import 'ProductListParser.dart';

class OrderModel {
  String? productId;
  String? productInvoiceno;
  String? productFarmerid;
  String? productCatid;
  String? productSubcatid;
  String? productName;
  int? productPrice;
  int? productTotalamt;
  String? productQty;
  String? productVqty;
  String? productHarvestingtime;
  String? productHarvestFrom;
  String? productHarvestTo;
  String? productPic;
  String? productNPic;
  String? productQrcode;
  String? productDescription;
  String? productPay;
  DateTime? productDate;
  String? productStatus;
  int? transactionAmt;
  List<Nutritiondatum>? nutritiondata;

  OrderModel({
    this.productId,
    this.productInvoiceno,
    this.productFarmerid,
    this.productCatid,
    this.productSubcatid,
    this.productName,
    this.productPrice,
    this.productTotalamt,
    this.productQty,
    this.productVqty,
    this.productHarvestingtime,
    this.productHarvestFrom,
    this.productHarvestTo,
    this.productPic,
    this.productNPic,
    this.productQrcode,
    this.productDescription,
    this.productPay,
    this.productDate,
    this.productStatus,
    this.transactionAmt,
    this.nutritiondata,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        productId: json["productID"] ?? "",
        productInvoiceno: json["productInvoiceno"] ?? "",
        productFarmerid: json["productFarmerid"] ?? "",
        productCatid: json["productCatid"] ?? "",
        productSubcatid: json["productSubcatid"] ?? "",
        productName: json["productName"] ?? "",
        productPrice: int.parse(json["productPrice"] ?? "0"),
        productTotalamt: int.parse(json["productTotalamt"] ?? "0"),
        productQty: json["productQty"] ?? "",
        productVqty: json["productVqty"] ?? "",
        productHarvestingtime: json["productHarvestingtime"] ?? "",
        productHarvestFrom: json["productHarvestFrom"] ?? "",
        productHarvestTo: json["productHarvestTo"] ?? "",
        productPic: json["productPic"] ?? "",
        productNPic: json["productNPic"] ?? "",
        productQrcode: json["productQrcode"] ?? "",
        productDescription: json["productDescription"] ?? "",
        productPay: json["productPay"] ?? "",
        productDate: json["productDate"] == null ? null : DateTime.parse(json["productDate"]),
        productStatus: json["productStatus"] ?? "",
        transactionAmt: int.parse(json["transactionAmt"] ?? "0"),
        nutritiondata: json["nutritiondata"] == null
            ? []
            : List<Nutritiondatum>.from(json["nutritiondata"]!.map((x) => Nutritiondatum.fromJson(x))),
      );
}
