class AddCartResponseModel {
  String? cartId;
  String? cartCid;
  String? cartVid;
  String? cartPid;
  String? cartQty;
  DateTime? cartDate;
  String? userproductID;
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

  AddCartResponseModel({
    this.cartId,
    this.cartCid,
    this.cartVid,
    this.cartPid,
    this.cartQty,
    this.cartDate,
    this.userproductID,
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
  });

  factory AddCartResponseModel.fromJson(Map<String, dynamic> json) => AddCartResponseModel(
    cartId: json["cartID"],
    cartCid: json["cartCID"],
    cartVid: json["cartVID"],
    cartPid: json["cartPID"],
    cartQty: json["cartQTY"],
    cartDate: json["cartDate"] == null ? null : DateTime.parse(json["cartDate"]),
    userproductID: json["userproductID"],
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
    userproductDate: json["userproductDate"] == null ? null : DateTime.parse(json["inventorysfrDate"] ?? DateTime.now().toString()),
  );
}
