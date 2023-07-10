class OrderModel {
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
  String? orderStatus;
  DateTime? orderDate;
  List<Orderdetail>? detailsToday;
  List<Orderdetail>? detailsPrevious;
  List<UserDetail>? userDetails;
  List<UserAddress>? userAddress;
  List<Subscriptiondatum>? subscriptiondata;
  List<SubscriptionImage>? orderdata;

  OrderModel({
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
    this.orderRazorpayid,
    this.orderPaymentStatus,
    this.orderStatus,
    this.orderDate,
    this.detailsToday,
    this.detailsPrevious,
    this.userDetails,
    this.userAddress,
    this.subscriptiondata,
    this.orderdata,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderID: json["orderID"] ?? "",
        orderGeneratedid: json["orderGeneratedid"] ?? "",
        orderCustomerid: json["orderCustomerid"] ?? "",
        orderSubfrid: json["orderSubfrid"] ?? "",
        orderDeliveryboyid: json["orderDeliveryboyid"] ?? "",
        orderCustomeraid: json["orderCustomeraid"] ?? "",
        orderType: json["orderType"] ?? "",
        orderCoupancode: json["orderCoupancode"] ?? "",
        orderCoupanid: json["orderCoupanid"] ?? "",
        orderCoupanamt: json["orderCoupanamt"] ?? "",
        orderSubscription: json["orderSubscription"] ?? "",
        orderSStartdate: json["orderSStartdate"] ?? "",
        orderSubtotal: json["orderSubtotal"] ?? "",
        orderTotalamt: json["orderTotalamt"] ?? "",
        orderRazorpayid: json["orderRazorpayid"] ?? "",
        orderPaymentStatus: json["orderPaymentStatus"] ?? "",
        orderStatus: json["orderStatus"] ?? "",
        orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
        detailsToday: json["detailsToday"] == null
            ? []
            : List<Orderdetail>.from(json["detailsToday"]!.map((x) => Orderdetail.fromJson(x))),
        detailsPrevious: json["detailsPrevious"] == null
            ? []
            : List<Orderdetail>.from(json["detailsPrevious"]!.map((x) => Orderdetail.fromJson(x))),
        userDetails: json["userDetails"] == null
            ? []
            : List<UserDetail>.from(json["userDetails"]!.map((x) => UserDetail.fromJson(x))),
        userAddress: json["userAddress"] == null
            ? []
            : List<UserAddress>.from(json["userAddress"]!.map((x) => UserAddress.fromJson(x))),
        subscriptiondata: json["subscriptiondata"] == null
            ? []
            : List<Subscriptiondatum>.from(json["subscriptiondata"]!.map((x) => Subscriptiondatum.fromJson(x))),
        orderdata: json["orderdata"] == null
            ? []
            : List<SubscriptionImage>.from(json["orderdata"]!.map((x) => SubscriptionImage.fromJson(x))),
      );
}

class Orderdetail {
  String? orderdetailsID;
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
  String? orderdetailsRefundAmount;
  String? orderdetailsRefund;

  Orderdetail({
    this.orderdetailsID,
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
        orderdetailsID: json["orderdetailsID"] ?? "",
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

class Subscriptiondatum {
  String? subscriptionId;
  String? subscriptionOrderid;
  String? subscriptionProductid;
  String? subscriptionPqty;
  String? subscriptionPpic;
  String? subscriptionSDate;
  String? subscriptionStatus;
  String? subscriptionDel;
  String? subscriptionPname;
  DateTime? subscriptionDate;

  Subscriptiondatum({
    this.subscriptionId,
    this.subscriptionOrderid,
    this.subscriptionProductid,
    this.subscriptionPqty,
    this.subscriptionPpic,
    this.subscriptionSDate,
    this.subscriptionStatus,
    this.subscriptionPname,
    this.subscriptionDel,
    this.subscriptionDate,
  });

  factory Subscriptiondatum.fromJson(Map<String, dynamic> json) => Subscriptiondatum(
        subscriptionId: json["subscriptionID"] ?? "",
        subscriptionOrderid: json["subscriptionOrderid"] ?? "",
        subscriptionProductid: json["subscriptionProductid"] ?? "",
        subscriptionPqty: json["subscriptionPqty"] ?? "",
        subscriptionPpic: json["subscriptionPpic"] ?? "",
        subscriptionSDate: json["subscriptionSDate"] ?? "",
        subscriptionStatus: json["subscriptionStatus"] ?? "",
        subscriptionDel: json["subscriptionDel"] ?? "",
        subscriptionPname: json["subscriptionPname"] ?? "",
        subscriptionDate: json["subscriptionDate"] == null ? null : DateTime.parse(json["subscriptionDate"]),
      );
}

class SubscriptionImage {
  String? userproductPPic;
  String? orderdetailsMrp;

  SubscriptionImage({this.userproductPPic, this.orderdetailsMrp});

  factory SubscriptionImage.fromJson(Map<String, dynamic> json) =>
      SubscriptionImage(userproductPPic: json["userproductPPic"] ?? "", orderdetailsMrp: json['orderdetailsMrp'] ?? "");
}

class UserAddress {
  String? addressesId;
  String? addressesCustomerId;
  String? addressesAddress;
  String? addressesLandmark;
  String? addressesLat;
  String? addressesLong;

  UserAddress({
    this.addressesId,
    this.addressesCustomerId,
    this.addressesAddress,
    this.addressesLandmark,
    this.addressesLat,
    this.addressesLong,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        addressesId: json["addressesID"] ?? "",
        addressesCustomerId: json["addressesCustomerID"] ?? "",
        addressesAddress: json["addressesAddress"] ?? "",
        addressesLandmark: json["addressesLandmark"] ?? "",
        addressesLat: json["addressesLat"] ?? "",
        addressesLong: json["addressesLong"] ?? "",
      );
}

class UserDetail {
  String? customerFirstname;
  String? customerLastname;
  String? customerPhoneno;
  String? customerState;
  String? customerCity;
  String? customerAddress;
  String? customerPic;

  UserDetail({
    this.customerFirstname,
    this.customerLastname,
    this.customerPhoneno,
    this.customerState,
    this.customerCity,
    this.customerAddress,
    this.customerPic,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        customerFirstname: json["customerFirstname"] ?? "",
        customerLastname: json["customerLastname"] ?? "",
        customerPhoneno: json["customerPhoneno"] ?? "",
        customerState: json["customerState"] ?? "",
        customerCity: json["customerCity"] ?? "",
        customerAddress: json["customerAddress"] ?? "",
        customerPic: json["customerPic"] ?? "",
      );
}

class OfflineSell {
  final String? offlineorderSubfrid;
  final String? offlineorderSubtotal;
  final String? offlineorderTotalamt;
  final String? offlineorderDiscountid;
  final String? offlineorderDiscountamt;
  List<Productdatum>? productdata;

  OfflineSell({
    this.offlineorderSubfrid,
    this.offlineorderSubtotal,
    this.offlineorderTotalamt,
    this.offlineorderDiscountid,
    this.offlineorderDiscountamt,
    this.productdata,
  });

  factory OfflineSell.fromJson(Map<String, dynamic> json) => OfflineSell(
        offlineorderSubfrid: json["offlineorderSubfrid"] ?? "",
        offlineorderSubtotal: json["offlineorderSubtotal"] ?? "",
        offlineorderTotalamt: json["offlineorderTotalamt"] ?? "",
        offlineorderDiscountid: json["offlineorderDiscountid"] ?? "",
        offlineorderDiscountamt: json["offlineorderDiscountamt"] ?? "",
        productdata: json["cartdata"] == null
            ? []
            : List<Productdatum>.from(json["productdata"]!.map((x) => Productdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offlineorderSubfrid": offlineorderSubfrid,
        "offlineorderSubtotal": offlineorderSubtotal,
        "offlineorderTotalamt": offlineorderTotalamt,
        "offlineorderDiscountid": offlineorderDiscountid,
        "offlineorderDiscountamt": offlineorderDiscountamt,
        "cartdata": productdata == null ? [] : List<dynamic>.from(productdata!.map((x) => x.toJson())),
      };
}

class Productdatum {
  String? productID;
  String? pQty;
  String? name;
  String? productMrp;
  String? productTotalamt;
  String? productUnit;

  Productdatum({
    this.productID,
    this.pQty,
    this.name,
    this.productMrp,
    this.productTotalamt,
    this.productUnit,
  });

  factory Productdatum.fromJson(Map<String, dynamic> json) => Productdatum(
        productID: json["productID"] ?? "",
        pQty: json["pQty"] ?? "",
        name: json["name"] ?? "",
        productMrp: json["productMrp"] ?? "",
        productTotalamt: json["productTotalamt"] ?? "",
        productUnit: json["productUnit"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "productID": productID,
        "pQty": pQty,
        "name": name,
        "productMrp": productMrp,
        "productTotalamt": productTotalamt,
        "productUnit": productUnit,
      };
}

class ProductName {
  String? userproductID;
  String? userproductPname;

  ProductName({this.userproductID, this.userproductPname});

  factory ProductName.fromJson(Map<String, dynamic> json) =>
      ProductName(userproductID: json["userproductID"] ?? "", userproductPname: json["userproductPname"] ?? "");
}

class OfflineSellList {
  String? offlineorderId;
  String? offlineorderGeneratedid;
  String? offlineorderCustomerid;
  String? offlineorderSubfrid;
  String? offlineorderDiscountid;
  String? offlineorderDiscountamt;
  String? offlineorderSubtotal;
  String? offlineorderTotalamt;
  String? offlineorderCreateDate;
  String? offlineorderStatus;
  DateTime? offlineorderorderDate;
  List<Orderdetails>? orderdetails;

  OfflineSellList({
    this.offlineorderId,
    this.offlineorderGeneratedid,
    this.offlineorderCustomerid,
    this.offlineorderSubfrid,
    this.offlineorderDiscountid,
    this.offlineorderDiscountamt,
    this.offlineorderSubtotal,
    this.offlineorderTotalamt,
    this.offlineorderCreateDate,
    this.offlineorderStatus,
    this.offlineorderorderDate,
    this.orderdetails,
  });

  factory OfflineSellList.fromJson(Map<String, dynamic> json) => OfflineSellList(
        offlineorderId: json["offlineorderID"] ?? "0",
        offlineorderGeneratedid: json["offlineorderGeneratedid"] ?? "",
        offlineorderCustomerid: json["offlineorderCustomerid"] ?? "0",
        offlineorderSubfrid: json["offlineorderSubfrid"] ?? "0",
        offlineorderDiscountid: json["offlineorderDiscountid"] ?? "0",
        offlineorderDiscountamt: json["offlineorderDiscountamt"] ?? "0",
        offlineorderSubtotal: json["offlineorderSubtotal"] ?? "0",
        offlineorderTotalamt: json["offlineorderTotalamt"] ?? "0",
        offlineorderCreateDate: json["offlineorderCreateDate"],
        offlineorderStatus: json["offlineorderStatus"],
        offlineorderorderDate:
            json["offlineorderorderDate"] == null ? null : DateTime.parse(json["offlineorderorderDate"]),
        orderdetails: json["orderdetails"] == null
            ? []
            : List<Orderdetails>.from(json["orderdetails"]!.map((x) => Orderdetails.fromJson(x))),
      );
}

class Orderdetails {
  String? offlinesaledetailsId;
  String? offlinesaledetailsGid;
  String? offlinesaledetailsVid;
  String? offlinesaledetailsPid;
  String? offlinesaledetailsPName;
  String? offlinesaledetailsQty;
  String? offlinesaledetailsMrp;
  String? offlinesaledetailsUnit;
  String? offlinesaledetailsTotalamt;
  String? offlinesaledetailsPPic;
  String? offlinesaledetailsPDesc;
  DateTime? offlinesaledetailsDate;

  Orderdetails({
    this.offlinesaledetailsId,
    this.offlinesaledetailsGid,
    this.offlinesaledetailsVid,
    this.offlinesaledetailsPid,
    this.offlinesaledetailsPName,
    this.offlinesaledetailsQty,
    this.offlinesaledetailsMrp,
    this.offlinesaledetailsUnit,
    this.offlinesaledetailsTotalamt,
    this.offlinesaledetailsPPic,
    this.offlinesaledetailsPDesc,
    this.offlinesaledetailsDate,
  });

  factory Orderdetails.fromJson(Map<String, dynamic> json) => Orderdetails(
        offlinesaledetailsId: json["offlinesaledetailsID"],
        offlinesaledetailsGid: json["offlinesaledetailsGid"],
        offlinesaledetailsVid: json["offlinesaledetailsVid"],
        offlinesaledetailsPid: json["offlinesaledetailsPid"],
        offlinesaledetailsPName: json["offlinesaledetailsPName"],
        offlinesaledetailsQty: json["offlinesaledetailsQty"],
        offlinesaledetailsMrp: json["offlinesaledetailsMrp"],
        offlinesaledetailsUnit: json["offlinesaledetailsUnit"],
        offlinesaledetailsTotalamt: json["offlinesaledetailsTotalamt"],
        offlinesaledetailsPPic: json["offlinesaledetailsPPic"],
        offlinesaledetailsPDesc: json["offlinesaledetailsPDesc"],
        offlinesaledetailsDate:
            json["offlinesaledetailsDate"] == null ? null : DateTime.parse(json["offlinesaledetailsDate"]),
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
        orderdetailsDate: json["orderdetailsDate"] == null ? null : DateTime.parse(json["orderdetailsDate"]),
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
        offlinesalePName: json["offlinesaledetailsPName"],
        totalQty: json["TotalQty"],
        totalAmt: json["TotalAmt"],
        offlinesaleDate: json["offlinesaledetailsDate"] == null ? null : DateTime.parse(json["offlinesaledetailsDate"]),
      );
}
