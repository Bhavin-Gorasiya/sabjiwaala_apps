class AddSubscriptionModel {
  String? userID;
  String? addressID;
  String? orderSubfrid;
  String? subTotal;
  String? totalAmount;
  String? razorpayId;
  String? orderFlag;
  String? productID;
  String? startDate;

  AddSubscriptionModel({
    this.userID,
    this.addressID,
    this.orderSubfrid,
    this.subTotal,
    this.totalAmount,
    this.razorpayId,
    this.orderFlag,
    this.productID,
    this.startDate,
  });

  factory AddSubscriptionModel.fromJson(Map<String, dynamic> json) => AddSubscriptionModel(
      userID: json["userID"] ?? "",
      addressID: json["addressID"] ?? "",
      orderSubfrid: json["orderSubfrid"] ?? "",
      subTotal: json["subTotal"] ?? "",
      totalAmount: json["totalAmount"] ?? "",
      razorpayId: json["razorpayId"] ?? "",
      orderFlag: json["orderFlag"] ?? "",
      productID: json["productID"] ?? "",
      startDate: json["startDate"] ?? "");

  Map<String, dynamic> toJson() => {
        "userID": userID ?? "",
        "addressID": addressID ?? "",
        "orderSubfrid": orderSubfrid ?? "",
        "subTotal": subTotal ?? "",
        "totalAmount": totalAmount ?? "",
        "razorpayId": razorpayId ?? "",
        "orderFlag": orderFlag ?? "",
        "productID": productID ?? "",
        "startDate": startDate ?? "",
      };
}

class Productdatum {
  String? productId;
  String? pQty;
  String? productMrp;
  String? productTotalamt;

  Productdatum({
    this.productId,
    this.pQty,
    this.productMrp,
    this.productTotalamt,
  });

  factory Productdatum.fromJson(Map<String, dynamic> json) => Productdatum(
        productId: json["productID"] ?? "",
        pQty: json["pQty"] ?? "",
        productMrp: json["productMrp"] ?? "",
        productTotalamt: json["productTotalamt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "productID": productId ?? "",
        "pQty": pQty ?? "",
        "productMrp": productMrp ?? "",
        "productTotalamt": productTotalamt ?? "",
      };
}

class Subscription {
  String? orderId;
  String? orderGeneratedid;
  String? orderCustomerid;
  String? orderSubfrid;
  String? orderDeliveryboyid;
  String? orderCustomeraid;
  String? orderType;
  String? orderCoupancode;
  String? orderCoupanid;
  String? orderCoupanamt;
  String? orderSubscriptionType;
  DateTime? orderSStartdate;
  String? orderSubtotal;
  String? orderTotalamt;
  String? orderCreateDate;
  String? orderRazorpayid;
  String? orderPaymentStatus;
  String? orderState;
  String? orderStatus;
  DateTime? orderDate;
  String? vendorName;
  String? vendorEmail;
  String? vendorMobile;
  String? vendorAddress;
  List<SubsProducts>? productDetails;

  Subscription({
    this.orderId,
    this.orderGeneratedid,
    this.orderCustomerid,
    this.orderSubfrid,
    this.orderDeliveryboyid,
    this.orderCustomeraid,
    this.orderType,
    this.orderCoupancode,
    this.orderCoupanid,
    this.orderCoupanamt,
    this.orderSubscriptionType,
    this.orderSStartdate,
    this.orderSubtotal,
    this.orderTotalamt,
    this.orderCreateDate,
    this.orderRazorpayid,
    this.orderPaymentStatus,
    this.orderState,
    this.orderStatus,
    this.orderDate,
    this.vendorName,
    this.vendorEmail,
    this.vendorMobile,
    this.vendorAddress,
    this.productDetails,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        orderId: json["orderID"],
        orderGeneratedid: json["orderGeneratedid"],
        orderCustomerid: json["orderCustomerid"],
        orderSubfrid: json["orderSubfrid"],
        orderDeliveryboyid: json["orderDeliveryboyid"],
        orderCustomeraid: json["orderCustomeraid"],
        orderType: json["orderType"],
        orderCoupancode: json["orderCoupancode"],
        orderCoupanid: json["orderCoupanid"],
        orderCoupanamt: json["orderCoupanamt"],
        orderSubscriptionType: json["orderSubscriptionType"],
        orderSStartdate: json["orderSStartdate"] == null ? null : DateTime.parse(json["orderSStartdate"]),
        orderSubtotal: json["orderSubtotal"],
        orderTotalamt: json["orderTotalamt"],
        orderCreateDate: json["orderCreateDate"],
        orderRazorpayid: json["orderRazorpayid"],
        orderPaymentStatus: json["orderPaymentStatus"],
        orderState: json["orderState"],
        orderStatus: json["orderStatus"],
        orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
        vendorName: json["VendorName"],
        vendorEmail: json["VendorEmail"],
        vendorMobile: json["VendorMobile"],
        vendorAddress: json["VendorAddress"],
        productDetails: json["productdetails"] == null
            ? []
            : List<SubsProducts>.from(json["productdetails"]!.map((x) => SubsProducts.fromJson(x))),
      );
}

class SubsProducts {
  String? subscriptionorderId;
  String? subscriptionorderDeliveryboyid;
  String? subscriptionorderOid;
  String? subscriptionorderSFid;
  String? subscriptionorderGid;
  String? subscriptionorderPid;
  String? subscriptionorderPname;
  String? subscriptionPPrice;
  String? subscriptionPdec;
  String? subscriptionPpic;
  String? subscriptionorderSDate;
  String? subscriptionorderStatus;
  String? subscriptionorderDel;
  DateTime? subscriptionorderDate;
  List<Product>? products;

  SubsProducts({
    this.subscriptionorderId,
    this.subscriptionorderDeliveryboyid,
    this.subscriptionorderOid,
    this.subscriptionorderSFid,
    this.subscriptionorderGid,
    this.subscriptionorderPid,
    this.subscriptionorderPname,
    this.subscriptionPPrice,
    this.subscriptionPdec,
    this.subscriptionPpic,
    this.subscriptionorderSDate,
    this.subscriptionorderStatus,
    this.subscriptionorderDel,
    this.subscriptionorderDate,
    this.products,
  });

  factory SubsProducts.fromJson(Map<String, dynamic> json) => SubsProducts(
        subscriptionorderId: json["subscriptionorderID"],
        subscriptionorderDeliveryboyid: json["subscriptionorderDeliveryboyid"],
        subscriptionorderOid: json["subscriptionorderOid"],
        subscriptionorderSFid: json["subscriptionorderSFid"],
        subscriptionorderGid: json["subscriptionorderGid"],
        subscriptionorderPid: json["subscriptionorderPid"],
        subscriptionorderPname: json["subscriptionorderPname"],
        subscriptionPPrice: json["subscriptionPPrice"],
        subscriptionPdec: json["subscriptionPdec"],
        subscriptionPpic: json["subscriptionPpic"],
        subscriptionorderSDate: json["subscriptionorderSDate"],
        subscriptionorderStatus: json["subscriptionorderStatus"],
        subscriptionorderDel: json["subscriptionorderDel"],
        subscriptionorderDate:
            json["subscriptionorderDate"] == null ? null : DateTime.parse(json["subscriptionorderDate"]),
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      );
}

class Product {
  String? productsubDay;
  String? productsubName;
  String? productsubPrice;
  String? productsubWeight;
  String? productsubUnit;

  Product({
    this.productsubDay,
    this.productsubName,
    this.productsubPrice,
    this.productsubWeight,
    this.productsubUnit,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productsubDay: json["productsubDay"],
        productsubName: json["productsubName"],
        productsubPrice: json["productsubPrice"],
        productsubWeight: json["productsubWeight"],
        productsubUnit: json["productsubUnit"],
      );
}

class VendorSubscription {
  String? sassignSFid;
  String? subscriptionproductId;
  String? subscriptionproductSdesc;
  String? subscriptionproductFrid;
  String? subscriptionPtype;
  String? subscriptionproductPname;
  String? subscriptionproductPrice;
  String? subscriptionproductPdesc;
  String? subscriptionproductDprice;
  String? subscriptionproductPpic;
  DateTime? subscriptionproductDate;
  String? subscriptionproductStatus;
  List<WeekProduct>? weekProducts;
  List<MonthProduct>? monthProducts;

  VendorSubscription({
    this.sassignSFid,
    this.subscriptionproductId,
    this.subscriptionproductFrid,
    this.subscriptionproductSdesc,
    this.subscriptionPtype,
    this.subscriptionproductPname,
    this.subscriptionproductPrice,
    this.subscriptionproductDprice,
    this.subscriptionproductPdesc,
    this.subscriptionproductPpic,
    this.subscriptionproductDate,
    this.subscriptionproductStatus,
    this.weekProducts,
    this.monthProducts,
  });

  factory VendorSubscription.fromJson(Map<String, dynamic> json) => VendorSubscription(
        sassignSFid: json["sassignSFid"] ?? "",
        subscriptionproductId: json["subscriptionproductID"] ?? "",
        subscriptionproductSdesc: json["subscriptionproductSdesc"] ?? "",
        subscriptionproductFrid: json["subscriptionproductFrid"] ?? "",
        subscriptionPtype: json["subscriptionPtype"] ?? "",
        subscriptionproductPname: json["subscriptionproductPname"] ?? "",
        subscriptionproductPrice: json["subscriptionproductPrice"] ?? "",
        subscriptionproductDprice: json["subscriptionproductDprice"] ?? "",
        subscriptionproductPdesc: json["subscriptionproductPdesc"] ?? "",
        subscriptionproductPpic: json["subscriptionproductPpic"] ?? "",
        subscriptionproductDate:
            json["subscriptionproductDate"] == null ? null : DateTime.parse(json["subscriptionproductDate"]),
        subscriptionproductStatus: json["subscriptionproductStatus"] ?? "",
        monthProducts: json["products"] == null
            ? []
            : List<MonthProduct>.from(json["products"]!.map((x) => MonthProduct.fromJson(x))),
        weekProducts: json["products"] == null
            ? []
            : List<WeekProduct>.from(json["products"]!.map((x) => WeekProduct.fromJson(x))),
      );
}

class MonthProduct {
  String? productsubId;
  String? productsubPid;
  String? productsubSid;
  String? productsubName;
  String? productsubPrice;
  String? productsubWeight;

  MonthProduct({
    this.productsubId,
    this.productsubPid,
    this.productsubSid,
    this.productsubName,
    this.productsubPrice,
    this.productsubWeight,
  });

  factory MonthProduct.fromJson(Map<String, dynamic> json) => MonthProduct(
        productsubId: json["productsubID"] ?? "",
        productsubPid: json["productsubPid"] ?? "",
        productsubSid: json["productsubSid"] ?? "",
        productsubName: json["productsubName"] ?? "",
        productsubPrice: json["productsubPrice"] ?? "0",
        productsubWeight: json["productsubWeight"] ?? "0",
      );
}

class WeekProduct {
  String? productsubId;
  String? productsubSid;
  String? productsubDay;
  List<Productdetail>? productdetails;

  WeekProduct({
    this.productsubId,
    this.productsubSid,
    this.productsubDay,
    this.productdetails,
  });

  factory WeekProduct.fromJson(Map<String, dynamic> json) => WeekProduct(
        productsubId: json["productsubID"],
        productsubSid: json["productsubSid"],
        productsubDay: json["productsubDay"],
        productdetails: json["productdetails"] == null
            ? []
            : List<Productdetail>.from(json["productdetails"]!.map((x) => Productdetail.fromJson(x))),
      );
}

class Productdetail {
  String? productsubPid;
  String? productsubName;
  String? productsubPrice;
  String? productsubWeight;
  String? productsubUnit;

  Productdetail({
    this.productsubPid,
    this.productsubName,
    this.productsubPrice,
    this.productsubWeight,
    this.productsubUnit,
  });

  factory Productdetail.fromJson(Map<String, dynamic> json) => Productdetail(
        productsubPid: json["productsubPid"],
        productsubName: json["productsubName"],
        productsubPrice: json["productsubPrice"],
        productsubWeight: json["productsubWeight"],
        productsubUnit: json["productsubUnit"],
      );
}
