class OrderPlace {
  String? userId;
  String? addressId;
  String? subTotal;
  String? totalAmount;
  String? razorpayId;
  String? paystatus;
  String? orderCoupanid;
  String? orderCoupancode;
  String? orderCoupanamt;
  String? orderSubfrid;
  String? orderCreateDate;
  List<Cartdatum>? cartdata;

  OrderPlace({
    this.userId,
    this.addressId,
    this.subTotal,
    this.totalAmount,
    this.razorpayId,
    this.paystatus,
    this.cartdata,
    this.orderCoupanid,
    this.orderCoupancode,
    this.orderCoupanamt,
    this.orderSubfrid,
    this.orderCreateDate,
  });

  factory OrderPlace.fromJson(Map<String, dynamic> json) => OrderPlace(
        userId: json["userID"] ?? "",
        addressId: json["addressID"] ?? "",
        subTotal: json["subTotal"] ?? "",
        totalAmount: json["totalAmount"] ?? "",
        razorpayId: json["razorpayId"] ?? "",
        paystatus: json["paystatus"] ?? "",
        orderCoupanid: json["orderCoupanid"] ?? "",
        orderCoupancode: json["orderCoupancode"] ?? "",
        orderCoupanamt: json["orderCoupanamt"] ?? "",
        orderSubfrid: json["orderSubfrid"] ?? "",
        orderCreateDate: json["orderCreateDate"] ?? "",
        cartdata:
            json["cartdata"] == null ? [] : List<Cartdatum>.from(json["cartdata"]!.map((x) => Cartdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "addressID": addressId,
        "subTotal": subTotal,
        "totalAmount": totalAmount,
        "razorpayId": razorpayId,
        "paystatus": paystatus,
        "orderCoupanid": orderCoupanid,
        "orderCoupancode": orderCoupancode,
        "orderCoupanamt": orderCoupanamt,
        "orderSubfrid": orderSubfrid,
        "orderCreateDate": orderCreateDate,
        "cartdata": cartdata == null ? [] : List<dynamic>.from(cartdata!.map((x) => x.toJson())),
      };
}

class Cartdatum {
  String? productId;
  String? pQty;
  String? productMrp;
  String? productTotalamt;

  Cartdatum({
    this.productId,
    this.pQty,
    this.productMrp,
    this.productTotalamt,
  });

  factory Cartdatum.fromJson(Map<String, dynamic> json) => Cartdatum(
        productId: json["productID"],
        pQty: json["pQty"],
        productMrp: json["productMrp"],
        productTotalamt: json["productTotalamt"],
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "pQty": pQty,
        "productMrp": productMrp,
        "productTotalamt": productTotalamt,
      };
}

class MyOrder {
  String? orderID;
  String? orderGeneratedid;
  String? orderCustomerid;
  String? orderSubfrid;
  String? orderDeliveryboyid;
  String? orderCustomeraid;
  String? orderType;
  String? orderCoupancode;
  String? orderCoupanid;
  String? orderCoupanamt;
  String? orderSubscription;
  String? orderSStartdate;
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
  String? vendorAddres;
  List<Orderdetail>? orderdetails;

  MyOrder({
    this.orderID,
    this.orderGeneratedid,
    this.orderCustomerid,
    this.orderSubfrid,
    this.orderDeliveryboyid,
    this.orderCustomeraid,
    this.orderType,
    this.orderCoupancode,
    this.orderCoupanid,
    this.orderCoupanamt,
    this.orderSubscription,
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
    this.vendorAddres,
    this.orderdetails,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
        orderID: json["orderID"],
        orderGeneratedid: json["orderGeneratedid"],
        orderCustomerid: json["orderCustomerid"],
        orderSubfrid: json["orderSubfrid"],
        orderDeliveryboyid: json["orderDeliveryboyid"],
        orderCustomeraid: json["orderCustomeraid"],
        orderType: json["orderType"],
        orderCoupancode: json["orderCoupancode"],
        orderCoupanid: json["orderCoupanid"],
        orderCoupanamt: json["orderCoupanamt"],
        orderSubscription: json["orderSubscription"],
        orderSStartdate: json["orderSStartdate"],
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
        vendorAddres: json["VendorAddress"],
        orderdetails: json["orderdetails"] == null
            ? [Orderdetail()]
            : List<Orderdetail>.from(json["orderdetails"]!.map((x) => Orderdetail.fromJson(x))),
      );
}

class Orderdetail {
  String? orderdetailsId;
  String? orderdetailsSfrid;
  String? orderdetailsGeneratedid;
  String? orderdetailsProductid;
  String? orderdetailsPname;
  String? orderdetailsQnty;
  String? orderdetailsPdesc;
  String? orderdetailsPpic;
  String? orderdetailsTotalamt;
  String? orderdetailsMrp;
  DateTime? orderdetailsDate;
  dynamic orderdetailsRefundAmount;
  String? orderdetailsRefund;

  Orderdetail({
    this.orderdetailsId,
    this.orderdetailsSfrid,
    this.orderdetailsGeneratedid,
    this.orderdetailsProductid,
    this.orderdetailsPname,
    this.orderdetailsQnty,
    this.orderdetailsPdesc,
    this.orderdetailsPpic,
    this.orderdetailsTotalamt,
    this.orderdetailsMrp,
    this.orderdetailsDate,
    this.orderdetailsRefundAmount,
    this.orderdetailsRefund,
  });

  factory Orderdetail.fromJson(Map<String, dynamic> json) => Orderdetail(
        orderdetailsId: json["orderdetailsID"] ?? "",
        orderdetailsSfrid: json["orderdetailsSfrid"] ?? "",
        orderdetailsGeneratedid: json["orderdetailsGeneratedid"] ?? "",
        orderdetailsProductid: json["orderdetailsProductid"] ?? "",
        orderdetailsPname: json["orderdetailsPname"] ?? "",
        orderdetailsQnty: json["orderdetailsQnty"] ?? "",
        orderdetailsPdesc: json["orderdetailsPdesc"] ?? "",
        orderdetailsPpic: json["orderdetailsPpic"] ?? "",
        orderdetailsTotalamt: json["orderdetailsTotalamt"] ?? "",
        orderdetailsMrp: json["orderdetailsMrp"] ?? "",
        orderdetailsDate: json["orderdetailsDate"] == null ? null : DateTime.parse(json["orderdetailsDate"]),
        orderdetailsRefundAmount: json["orderdetailsRefundAmount"] ?? "",
        orderdetailsRefund: json["orderdetailsRefund"] ?? "",
      );
}

class Productdetail {
  String? userproductID;
  String? userproductFamerid;
  String? userproductSubfid;
  String? userproductPid;
  String? userproductCatid;
  String? userproductScatid;
  String? userproductPname;
  String? userproductPpic;
  String? userproductDesc;
  String? userproductQrcode;
  String? userproductQty;
  String? userproductTotalamt;
  String? userproductPrice;
  DateTime? userproductDate;

  Productdetail({
    this.userproductID,
    this.userproductFamerid,
    this.userproductSubfid,
    this.userproductPid,
    this.userproductCatid,
    this.userproductScatid,
    this.userproductPname,
    this.userproductPpic,
    this.userproductDesc,
    this.userproductQrcode,
    this.userproductQty,
    this.userproductTotalamt,
    this.userproductPrice,
    this.userproductDate,
  });

  factory Productdetail.fromJson(Map<String, dynamic> json) => Productdetail(
        userproductID: json["userproductID"],
        userproductFamerid: json["userproductFamerid"],
        userproductSubfid: json["userproductSubfid"],
        userproductPid: json["userproductPid"],
        userproductCatid: json["userproductCatid"],
        userproductScatid: json["userproductScatid"],
        userproductPname: json["userproductPname"],
        userproductPpic: json["userproductPpic"],
        userproductDesc: json["userproductDesc"],
        userproductQrcode: json["userproductQrcode"],
        userproductQty: json["userproductQty"],
        userproductTotalamt: json["userproductTotalamt"],
        userproductPrice: json["userproductPrice"],
        userproductDate: json["userproductDate"] == null ? null : DateTime.parse(json["userproductDate"]),
      );
}

class OnlineSellStats {
  String? orderdetailsPname;
  String? totalQty;
  String? totalAmt;
  DateTime? orderdetailsDate;

  OnlineSellStats({
    this.orderdetailsPname,
    this.totalQty,
    this.totalAmt,
    this.orderdetailsDate,
  });

  factory OnlineSellStats.fromJson(Map<String, dynamic> json) => OnlineSellStats(
        orderdetailsPname: json["orderdetailsPname"],
        totalQty: json["TotalQty"],
        totalAmt: json["TotalAmt"],
        orderdetailsDate: json["orderdetailsDate"] == null ? null : DateTime.parse(json["userproductDate"]),
      );
}

class OfflineSellStats {
  String? offlinesalePName;
  String? totalQty;
  String? totalAmt;
  DateTime? offlinesaleDate;

  OfflineSellStats({
    this.offlinesalePName,
    this.totalQty,
    this.totalAmt,
    this.offlinesaleDate,
  });

  factory OfflineSellStats.fromJson(Map<String, dynamic> json) => OfflineSellStats(
    offlinesalePName: json["offlinesalePName"],
    totalQty: json["TotalQty"],
    totalAmt: json["TotalAmt"],
    offlinesaleDate: json["offlinesaleDate"] == null ? null : DateTime.parse(json["userproductDate"]),
  );
}
