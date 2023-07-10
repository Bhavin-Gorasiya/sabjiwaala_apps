class OrderModel {
  String? orderId;
  String? orderGeneratedid;
  String? orderCustomerid;
  String? orderSubfrid;
  String? orderDeliveryboyid;
  String? orderType;
  String? orderSubscriptionType;
  String? orderSubtotal;
  String? orderRazorpayid;
  String? orderPaymentStatus;
  String? orderStatus;
  String? subscriptionorderSDate;
  UserDetails? userDetails;
  List<Product>? products;

  OrderModel({
    this.orderId,
    this.orderGeneratedid,
    this.orderCustomerid,
    this.orderSubfrid,
    this.orderDeliveryboyid,
    this.orderType,
    this.orderSubscriptionType,
    this.orderSubtotal,
    this.orderRazorpayid,
    this.orderPaymentStatus,
    this.orderStatus,
    this.subscriptionorderSDate,
    this.userDetails,
    this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["orderID"] ?? "0",
        orderGeneratedid: json["orderGeneratedid"] ?? "0",
        orderCustomerid: json["orderCustomerid"] ?? "0",
        orderSubfrid: json["orderSubfrid"] ?? "0",
        orderDeliveryboyid: json["orderDeliveryboyid"] ?? "0",
        orderType: json["orderType"] ?? "",
        orderSubscriptionType: json["orderSubscriptionType"] ?? "",
        orderSubtotal: json["orderSubtotal"] ?? "0",
        orderRazorpayid: json["orderRazorpayid"] ?? "",
        orderPaymentStatus: json["orderPaymentStatus"] ?? "",
        orderStatus: json["orderStatus"] ?? "",
        subscriptionorderSDate: json["subscriptionorderSDate"] ?? "",
        userDetails: json["userDetails"] == null ? UserDetails() : UserDetails.fromJson(json["userDetails"]),
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      );
}

class Product {
  String? productsubName;
  String? productsubPrice;
  String? productsubWeight;
  String? productsubUnit;
  String? productsubQty;

  Product({
    this.productsubName,
    this.productsubPrice,
    this.productsubWeight,
    this.productsubUnit,
    this.productsubQty,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productsubName: json["productsubName"] ?? "Product",
        productsubPrice: json["productsubPrice"] ?? "0",
        productsubWeight: json["productsubWeight"] ?? "0",
        productsubUnit: json["productsubUnit"] ?? "kg",
        productsubQty: json["productsubQty"] ?? "1",
      );
}

class UserDetails {
  String? customerId;
  String? customerFirstname;
  String? customerLastname;
  String? customerPhoneno;
  String? customerPic;
  String? addressesAddress;
  String? addressesLandmark;
  String? addressesLat;
  String? addressesLong;

  UserDetails({
    this.customerId,
    this.customerFirstname,
    this.customerLastname,
    this.customerPhoneno,
    this.customerPic,
    this.addressesAddress,
    this.addressesLandmark,
    this.addressesLat,
    this.addressesLong,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        customerId: json["customerID"] ?? "0",
        customerFirstname: json["customerFirstname"] ?? "User Name",
        customerLastname: json["customerLastname"] ?? "",
        customerPhoneno: json["customerPhoneno"] ?? "mobile no.",
        customerPic: json["customerPic"] ?? "",
        addressesAddress: json["addressesAddress"] ?? "address",
        addressesLandmark: json["addressesLandmark"] ?? "",
        addressesLat: json["addressesLat"] ?? "",
        addressesLong: json["addressesLong"] ?? "",
      );
}
