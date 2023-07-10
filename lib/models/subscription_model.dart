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
    orderId: json["orderID"] ?? "",
    orderGeneratedid: json["orderGeneratedid"] ?? "",
    orderCustomerid: json["orderCustomerid"] ?? "",
    orderSubfrid: json["orderSubfrid"] ?? "",
    orderDeliveryboyid: json["orderDeliveryboyid"] ?? "",
    orderCustomeraid: json["orderCustomeraid"] ?? "",
    orderType: json["orderType"] ?? "",
    orderCoupancode: json["orderCoupancode"] ?? "",
    orderCoupanid: json["orderCoupanid"] ?? "",
    orderCoupanamt: json["orderCoupanamt"] ?? "",
    orderSubscriptionType: json["orderSubscriptionType"] ?? "",
    orderSStartdate: json["orderSStartdate"] == null ? null : DateTime.parse(json["orderSStartdate"]),
    orderSubtotal: json["orderSubtotal"] ?? "",
    orderTotalamt: json["orderTotalamt"] ?? "",
    orderCreateDate: json["orderCreateDate"] ?? "",
    orderRazorpayid: json["orderRazorpayid"] ?? "",
    orderPaymentStatus: json["orderPaymentStatus"] ?? "",
    orderState: json["orderState"] ?? "",
    orderStatus: json["orderStatus"] ?? "",
    orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
    vendorName: json["VendorName"],
    vendorEmail: json["VendorEmail"] ?? "",
    vendorMobile: json["VendorMobile"],
    vendorAddress: json["VendorAddress"] ?? "",
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
    subscriptionorderId: json["subscriptionorderID"] ?? "",
    subscriptionorderDeliveryboyid: json["subscriptionorderDeliveryboyid"] ?? "",
    subscriptionorderOid: json["subscriptionorderOid"] ?? "",
    subscriptionorderSFid: json["subscriptionorderSFid"] ?? "",
    subscriptionorderGid: json["subscriptionorderGid"] ?? "",
    subscriptionorderPid: json["subscriptionorderPid"] ?? "",
    subscriptionorderPname: json["subscriptionorderPname"] ?? "",
    subscriptionPPrice: json["subscriptionPPrice"] ?? "",
    subscriptionPdec: json["subscriptionPdec"] ?? "",
    subscriptionPpic: json["subscriptionPpic"] ?? "",
    subscriptionorderSDate: json["subscriptionorderSDate"] ?? "",
    subscriptionorderStatus: json["subscriptionorderStatus"] ?? "",
    subscriptionorderDel: json["subscriptionorderDel"] ?? "",
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
    productsubDay: json["productsubDay"] ?? "",
    productsubName: json["productsubName"] ?? "",
    productsubPrice: json["productsubPrice"] ?? "",
    productsubWeight: json["productsubWeight"] ?? "",
    productsubUnit: json["productsubUnit"] ?? "",
  );
}