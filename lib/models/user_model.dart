class UserTypeModel {
  UserTypeModel({
    this.accessId,
    this.accessType,
    this.accessDate,
    this.accessStatus,
  });

  String? accessId;
  String? accessType;
  DateTime? accessDate;
  String? accessStatus;

  factory UserTypeModel.fromJson(Map<String, dynamic> json) => UserTypeModel(
        accessId: json["accessID"] ?? "",
        accessType: json["accessType"] ?? "",
        accessDate: DateTime.parse(json["accessDate"] ?? DateTime.now().toString()),
        accessStatus: json["accessStatus"] ?? "",
      );
}

class UserModel {
  String? userId;
  String? userUid;
  String? userFname;
  String? userLname;
  String? userEmail;
  String? userPicture;
  String? userDob;
  String? userGender;
  String? userHaddress;
  String? userMobileno1;
  String? userMobileno2;
  String? userOfficearea;
  String? userBaddress;
  String? userStateid;
  String? userCityid;
  String? userDistrict;
  String? userPincode;
  String? userAccounthname;
  String? userBankname;
  String? userAccountno;
  String? userIfsCcode;
  String? userBranchaddress;
  String? userAgreementFile;
  String? stateName;
  String? cityName;

  UserModel({
    this.userId,
    this.userUid,
    this.userFname,
    this.userLname,
    this.userEmail,
    this.userPicture,
    this.userDob,
    this.userGender,
    this.userHaddress,
    this.userMobileno1,
    this.userMobileno2,
    this.userOfficearea,
    this.userBaddress,
    this.userStateid,
    this.userCityid,
    this.userDistrict,
    this.userPincode,
    this.userAccounthname,
    this.userBankname,
    this.userAccountno,
    this.userIfsCcode,
    this.userBranchaddress,
    this.userAgreementFile,
    this.stateName,
    this.cityName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userID"] ?? "",
    userUid: json["userUid"] ?? "",
    userFname: json["userFname"] ?? "",
    userLname: json["userLname"] ?? "",
    userEmail: json["userEmail"] ?? "",
    userPicture: json["userPicture"] ?? "",
    userDob: json["userDob"] ?? "",
    userGender: json["userGender"] ?? "",
    userHaddress: json["userHaddress"] ?? "",
    userMobileno1: json["userMobileno1"] ?? "",
    userMobileno2: json["userMobileno2"] ?? "",
    userOfficearea: json["userOfficearea"] ?? "",
    userBaddress: json["userBaddress"] ?? "",
    userStateid: json["userStateid"] ?? "",
    userCityid: json["userCityid"] ?? "",
    userDistrict: json["userDistrict"] ?? "",
    userPincode: json["userPincode"] ?? "",
    userAccounthname: json["userAccounthname"] ?? "",
    userBankname: json["userBankname"] ?? "",
    userAccountno: json["userAccountno"] ?? "",
    userIfsCcode: json["userIFSCcode"] ?? "",
    userBranchaddress: json["userBranchaddress"] ?? "",
    userAgreementFile: json["userAgreementFile"] ?? "",
    stateName: json["stateName"] ?? "",
    cityName: json["cityName"] ?? "",
  );
}

class MasterInventoryModel {
  String? inventorymfrId;
  String? inventorymfrEmpid;
  String? inventorymfrMfid;
  String? inventorymfrPname;
  String? inventorymfrPPic;
  String? inventorymfrInvoiceno;
  String? inventorymfrQty;
  String? inventorymfrVqty;
  String? inventorymfrPid;
  String? inventorymfrTotalamt;
  String? inventorymfrPrice;

  MasterInventoryModel({
    this.inventorymfrId,
    this.inventorymfrEmpid,
    this.inventorymfrMfid,
    this.inventorymfrPname,
    this.inventorymfrPPic,
    this.inventorymfrInvoiceno,
    this.inventorymfrQty,
    this.inventorymfrVqty,
    this.inventorymfrPid,
    this.inventorymfrTotalamt,
    this.inventorymfrPrice,
  });

  factory MasterInventoryModel.fromJson(Map<String, dynamic> json) => MasterInventoryModel(
    inventorymfrId: json["inventorymfrID"],
    inventorymfrEmpid: json["inventorymfrEmpid"],
    inventorymfrMfid: json["inventorymfrMfid"],
    inventorymfrPname: json["inventorymfrPname"],
    inventorymfrPPic: json["inventorymfrPPic"],
    inventorymfrInvoiceno: json["inventorymfrInvoiceno"],
    inventorymfrQty: json["inventorymfrQty"],
    inventorymfrVqty: json["inventorymfrVqty"],
    inventorymfrPid: json["inventorymfrPid"],
    inventorymfrTotalamt: json["inventorymfrTotalamt"],
    inventorymfrPrice: json["inventorymfrPrice"],
  );
}

class FranchiseInventoryModel {
  String? inventoryfrID;
  String? inventoryfrEmpid;
  String? inventoryfrMfid;
  String? inventoryfrPname;
  String? inventoryfrPPic;
  String? inventoryfrInvoiceno;
  String? inventoryfrQty;
  String? inventoryfrVqty;
  String? inventoryfrPid;
  String? inventoryfrTotalamt;
  String? inventoryfrPrice;

  FranchiseInventoryModel({
    this.inventoryfrID,
    this.inventoryfrEmpid,
    this.inventoryfrMfid,
    this.inventoryfrPname,
    this.inventoryfrPPic,
    this.inventoryfrInvoiceno,
    this.inventoryfrQty,
    this.inventoryfrVqty,
    this.inventoryfrPid,
    this.inventoryfrTotalamt,
    this.inventoryfrPrice,
  });

  factory FranchiseInventoryModel.fromJson(Map<String, dynamic> json) => FranchiseInventoryModel(
    inventoryfrID: json["inventoryfrID"],
    inventoryfrEmpid: json["inventoryfrEmpid"],
    inventoryfrMfid: json["inventoryfrMfid"],
    inventoryfrPname: json["inventoryfrPname"],
    inventoryfrPPic: json["inventoryfrPPic"],
    inventoryfrInvoiceno: json["inventoryfrInvoiceno"],
    inventoryfrQty: json["inventoryfrQty"],
    inventoryfrVqty: json["inventoryfrVqty"],
    inventoryfrPid: json["inventoryfrPid"],
    inventoryfrTotalamt: json["inventoryfrTotalamt"],
    inventoryfrPrice: json["inventoryfrPrice"],
  );
}

class SubInventoryModel {
  String? inventorysfrId;
  String? inventorysfrEmpid;
  String? inventorysfrMfid;
  String? inventorysfrPname;
  String? inventorysfrPPic;
  String? inventorysfrInvoiceno;
  String? inventorysfrQty;
  String? inventorysfrVqty;
  String? inventorysfrPid;
  String? inventorysfrTotalamt;
  String? inventorysfrPrice;

  SubInventoryModel({
    this.inventorysfrId,
    this.inventorysfrEmpid,
    this.inventorysfrMfid,
    this.inventorysfrPname,
    this.inventorysfrPPic,
    this.inventorysfrInvoiceno,
    this.inventorysfrQty,
    this.inventorysfrVqty,
    this.inventorysfrPid,
    this.inventorysfrTotalamt,
    this.inventorysfrPrice,
  });

  factory SubInventoryModel.fromJson(Map<String, dynamic> json) => SubInventoryModel(
    inventorysfrId: json["inventorysfrID"],
    inventorysfrEmpid: json["inventorysfrEmpid"],
    inventorysfrMfid: json["inventorysfrMfid"],
    inventorysfrPname: json["inventorysfrPname"],
    inventorysfrPPic: json["inventorysfrPPic"],
    inventorysfrInvoiceno: json["inventorysfrInvoiceno"],
    inventorysfrQty: json["inventorysfrQty"],
    inventorysfrVqty: json["inventorysfrVqty"],
    inventorysfrPid: json["inventorysfrPid"],
    inventorysfrTotalamt: json["inventorysfrTotalamt"],
    inventorysfrPrice: json["inventorysfrPrice"],
  );
}

class FarmerInventoryModel {
  String? inventoryfmID;
  String? inventoryfmEmpid;
  String? inventoryfmMfid;
  String? inventoryfmPname;
  String? inventoryfmPPic;
  String? inventoryfmInvoiceno;
  String? inventoryfmQty;
  String? inventoryfmVqty;
  String? inventoryfmPid;
  String? inventoryfmTotalamt;
  String? inventoryfmPrice;

  FarmerInventoryModel({
    this.inventoryfmID,
    this.inventoryfmEmpid,
    this.inventoryfmMfid,
    this.inventoryfmPname,
    this.inventoryfmPPic,
    this.inventoryfmInvoiceno,
    this.inventoryfmQty,
    this.inventoryfmVqty,
    this.inventoryfmPid,
    this.inventoryfmTotalamt,
    this.inventoryfmPrice,
  });

  factory FarmerInventoryModel.fromJson(Map<String, dynamic> json) => FarmerInventoryModel(
    inventoryfmID: json["productID"],
    inventoryfmEmpid: json["inventoryfmEmpid"],
    inventoryfmMfid: json["inventoryfmMfid"],
    inventoryfmPname: json["productName"],
    inventoryfmPPic: json["productPic"],
    inventoryfmInvoiceno: json["productInvoiceno"],
    inventoryfmQty: json["productQty"],
    inventoryfmVqty: json["productVqty"],
    inventoryfmPid: json["inventoryfmPid"],
    inventoryfmTotalamt: json["productTotalamt"],
    inventoryfmPrice: json["productPrice"],
  );
}


class RequestQtyModel {
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

  RequestQtyModel({
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

  factory RequestQtyModel.fromJson(Map<String, dynamic> json) => RequestQtyModel(
    requestqtyId: json["requestqtyID"] ?? "",
    requestqtyUname: json["requestqtyUname"] ?? "",
    requestqtyPname: json["requestqtyPname"] ?? "",
    requestqtyPid: json["requestqtyPid"] ?? "",
    requestqtyQty: json["requestqtyQty"] ?? "",
    requestqtyFuid: json["requestqtyFuid"] ?? "",
    requestqtyTuid: json["requestqtyTuid"] ?? "",
    requestqtyTag: json["requestqtyTag"] ?? "",
    requestqtyStatus: json["requestqtyStatus"] ?? "",
    requestqtyDate: DateTime.parse(json["requestqtyDate"] ?? DateTime.now().toString()),
  );
}

class AssignUser {
  String? userId;
  String? userName;
  String? area;

  AssignUser({this.userId,this.userName,this.area});

  factory AssignUser.fromJson(Map<String ,dynamic> json) => AssignUser(
    userId: json['Userid'],
    userName: json['Username'],
    area: json['Area']
  );
}