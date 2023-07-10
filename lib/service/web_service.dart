import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sub_franchisee/models/product_model.dart';

import '../helper/app_config.dart';
import '../models/enquiry.dart';
import '../models/delivery_model.dart';
import '../models/order_model.dart';
import '../models/profile_model.dart';

class WebService {
  /// get State
  Future getState() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.apiUrl + AppConfig.getState));

      if (response.statusCode == 200) {
        log("===>>> get state ${response.statusCode}");
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// get city
  Future getCity(String stateID) async {
    try {
      Map<String, dynamic> data = {"stateID": stateID};
      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getCity), body: jsonEncode(data));

      if (response.statusCode == 200) {
        log("===>>> get city ${response.statusCode}");
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// send OTP
  Future sendOtp({required String mobileNumber}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.sendOtp);

      Map data = {"userPhoneno": mobileNumber};
      log("==== send otp web service  $data");
      log("==== send otp web service url  $url");
      final response = await http.post(
        url,
        body: jsonEncode(data),
      );
      log("==== send otp web service  ");
      log("==== send otp web service  ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === catch send Otp === $e");
      return "error";
    }
  }

  /// verify Otp
  Future verifyOtp({required String userMobileno, required String otp}) async {
    try {
      Map data = {"userPhoneno": userMobileno, "otp": otp};

      // log("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.verifyOtp);

      final response = await http.post(url, body: jsonEncode(data));
      log(" ====verify otp ====${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === catch verify Otp === $e");
      return "error";
    }
  }

  /// update fcm
  Future updateFcm({
    required String userID,
    required String token,
    required String platform,
    required String lat,
    required String long,
  }) async {
    try {
      Map data = {"userID": userID, "userPlatformos": platform, "userFcmtoken": token, "userLat": lat, "userLong": long};

      log("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateFcm);

      final response = await http.post(url, body: jsonEncode(data));
      // log(" ====update otp ====${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === catch update Otp === $e");
      return "error";
    }
  }

  /// get Profile
  Future getProfile(userID) async {
    try {
      Map data = {"userID": userID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getProfile);

      final response = await http.post(url, body: jsonEncode(data));
      log(" ====getProfile ====${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === getProfile === $e");
    }
  }

  /// edit Profile api
  Future editProfile(ProfileModel profileModel) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.editProfile);

      final response = await http.post(url, body: jsonEncode(profileModel.toJson()));

      log("==>> editProfile == ${profileModel.toJson()} ${response.statusCode}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === editProfile === $e');
      return "error";
    }
  }

  /// update Profile pic
  Future updateProfilePic(String imgPath, String userID) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateProfilePic);

      http.MultipartRequest request = http.MultipartRequest("POST", url);
      log(imgPath);

      request
        ..fields['userID'] = userID
        ..files.add(await http.MultipartFile.fromPath('file', imgPath));
      var res = await request.send();
      final response = await http.Response.fromStream(res);
      log(" ==== update Profile pic ====${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === update Profile pic === $e");
    }
  }

  /// delete Account
  Future deleteAccount(userID) async {
    try {
      Map body = {"userID": userID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.deleteAccount), body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("exception$e");
    }
  }

  /// get All Work profile
  Future getAllDeliveryBoy({required String userId}) async {
    try {
      Map data = {"subFID": userId};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllDeliveryBoy);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' ===  get Delivery boy === $e');
      return "error";
    }
  }

  /// add work
  Future addDeliveryBoy({required DeliveryModel model, required String img}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addDeliveryBoy);
      http.MultipartRequest request = http.MultipartRequest('POST', url);

      request
        ..fields['deliverypersonSFID'] = model.deliverypersonSfid ?? ''
        ..fields['deliverypersonFname'] = model.deliverypersonFname ?? ''
        ..fields['deliverypersonLname'] = model.deliverypersonLname ?? ''
        ..fields['deliverypersonEmail'] = model.deliverypersonEmail ?? ''
        ..fields['deliverypersonHaddress'] = model.deliverypersonHaddress ?? ""
        ..fields['deliverypersonMobileno1'] = model.deliverypersonMobileno1 ?? ""
        ..fields['deliverypersonMobileno2'] = model.deliverypersonMobileno2 ?? ""
        ..fields['deliverypersonAadharno'] = model.deliverypersonAadharno ?? ""
        ..fields['deliverypersonPanno'] = model.deliverypersonPanno ?? ""
        ..fields['deliverypersonDrivingLicence'] = model.deliverypersonDrivingLicence ?? ""
        ..fields['deliverypersonEducationName'] = model.deliverypersonEducationName ?? ""
        ..fields['deliverypersonStateid'] = model.deliverypersonStateid ?? ""
        ..fields['deliverypersonCityid'] = model.deliverypersonCityid ?? ""
        ..fields['deliverypersonDistrict'] = model.deliverypersonDistrict ?? ""
        ..fields['deliverypersonPincode'] = model.deliverypersonPincode ?? ""
        ..fields['deliverypersonAccounthname'] = model.deliverypersonAccounthname ?? ""
        ..fields['deliverypersonBankname'] = model.deliverypersonBankname ?? ""
        ..fields['deliverypersonAccountno'] = model.deliverypersonAccountno ?? ""
        ..fields['deliverypersonIFSCcode'] = model.deliverypersonIfsCcode ?? ""
        ..fields['deliverypersonBranchaddress'] = model.deliverypersonBranchaddress ?? ""
        ..files.add(await http.MultipartFile.fromPath('profilefile', img));

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      log('++++=== add  Delivery boy ${response.statusCode}');
      log('++++=== add  Delivery boy ${request.fields}');
      if (response.statusCode == 200) {
        log('=== updateProfile == ${response.body}');
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === add  Delivery boy === $e');
      return "error";
    }
  }

  /// update Delivery Boy
  Future updateDeliveryBoy({required DeliveryModel model, String? img}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateDeliveryBoy);
      http.MultipartRequest request = http.MultipartRequest('POST', url);

      request
        ..fields['deliverypersonSFID'] = model.deliverypersonSfid ?? ''
        ..fields['deliverypersonID'] = model.deliverypersonId ?? ''
        ..fields['deliverypersonFname'] = model.deliverypersonFname ?? ''
        ..fields['deliverypersonLname'] = model.deliverypersonLname ?? ''
        ..fields['deliverypersonEmail'] = model.deliverypersonEmail ?? ''
        ..fields['deliverypersonHaddress'] = model.deliverypersonHaddress ?? ""
        ..fields['deliverypersonMobileno1'] = model.deliverypersonMobileno1 ?? ""
        ..fields['deliverypersonMobileno2'] = model.deliverypersonMobileno2 ?? ""
        ..fields['deliverypersonAadharno'] = model.deliverypersonAadharno ?? ""
        ..fields['deliverypersonPanno'] = model.deliverypersonPanno ?? ""
        ..fields['deliverypersonDrivingLicence'] = model.deliverypersonDrivingLicence ?? ""
        ..fields['deliverypersonEducationName'] = model.deliverypersonEducationName ?? ""
        ..fields['deliverypersonStateid'] = model.deliverypersonStateid ?? ""
        ..fields['deliverypersonCityid'] = model.deliverypersonCityid ?? ""
        ..fields['deliverypersonDistrict'] = model.deliverypersonDistrict ?? ""
        ..fields['deliverypersonPincode'] = model.deliverypersonPincode ?? ""
        ..fields['deliverypersonAccounthname'] = model.deliverypersonAccounthname ?? ""
        ..fields['deliverypersonBankname'] = model.deliverypersonBankname ?? ""
        ..fields['deliverypersonAccountno'] = model.deliverypersonAccountno ?? ""
        ..fields['deliverypersonIFSCcode'] = model.deliverypersonIfsCcode ?? ""
        ..fields['deliverypersonBranchaddress'] = model.deliverypersonBranchaddress ?? "";
      if (img != null) {
        request.files.add(await http.MultipartFile.fromPath('profilefile', img));
      }

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      log('++++=== edit  Delivery boy ${response.statusCode}');
      if (response.statusCode == 200) {
        // log('=== updateProfile == ${response.body}');
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === edit  Delivery boy === $e');
      return "error";
    }
  }

  /// delete Delivery Boy
  Future deleteDeliveryBoy(String visitID) async {
    try {
      Map data = {"deliverypersonID": visitID};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.deleteDeliveryBoy);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>> delete delivery ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> delete Delivery boy error <== $e");
      return "error";
    }
  }

  /// add Enquiry
  Future addEnquiry({required Enquiry enquiry}) async {
    try {
      Map data = {
        "enquiryName": enquiry.enquiryName,
        "enquiryEmail": enquiry.enquiryEmail,
        "enquiryPhoneno": enquiry.enquiryPhoneno,
        "enquirySubject": enquiry.enquirySubject,
        "enquiryMessage": enquiry.enquiryMessage,
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.enquiry);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>>  enquiry ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> Enquiry error <== $e");
      return "error";
    }
  }

  /// get inventory
  Future getInventory(String userID) async {
    try {
      Map data = {"userID": userID};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllInventory);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>>  get inventory ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get inventory error <== $e");
      return "error";
    }
  }

  /// get product details
  Future getAllProduct(String userID) async {
    try {
      Map data = {"userID": userID};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllSubFProject);

      final response = await http.post(url, body: jsonEncode(data));
      // log("==>>  get product details ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get product details error <== $e");
      return "error";
    }
  }

  /// get order
  Future getOrder(String subFrId) async {
    try {
      Map data = {"Subfrid": subFrId};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getOrder);
      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get order error <== $e");
      return "error";
    }
  }

  /// order assign
  Future orderAssign({required String orderID, required String deliveryId}) async {
    try {
      Map data = {"orderID": orderID, "Deliveryboyid": deliveryId};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.orderAssign);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>>  get assign ${response.statusCode} $data");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get assign error <== $e");
      return "error";
    }
  }

  /// cancelled Order
  Future cancelledOrder(String orderID, {String? status}) async {
    try {
      Map data = {"orderID": orderID, "orderStatus": status ?? "Cancelled", "orderType": "Order"};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.cancelledOrder);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>> cancelled Order ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> cancelled Order error <== $e");
      return "error";
    }
  }

  /// cancelled Subs Order
  Future cancelledSubsOrder(String orderID) async {
    try {
      Map data = {"subscriptionID": orderID, "subscriptionStatus": "Cancelled", "orderType": "Subscription"};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.cancelledOrder);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>> cancelled Subs Order ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> cancelled Subs Order error <== $e");
      return "error";
    }
  }

  /// offline Sell
  Future offlineSell(OfflineSell data) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.offlineSell);

      final response = await http.post(url, body: jsonEncode(data.toJson()));
      log("==>> offline Sell ${response.statusCode} ${data.toJson()}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> offline Sell error <== $e");
      return "error";
    }
  }

  /// get offline Sell
  Future getOfflineSell(String subFID) async {
    try {
      Map data = {"subFID": subFID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getOfflineSell);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>> get offline Sell ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get offline Sell error <== $e");
      return "error";
    }
  }

  /// get-all-product name
  Future getAllProductName(String id) async {
    try {
      Map data = {"subFID": id};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllProductName);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>> offline Sell ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> offline Sell error <== $e");
      return "error";
    }
  }

  /// get All Subscription
  Future getAllSubscription(String userID) async {
    try {
      Map<String, dynamic> data = {"userID": userID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getSubscription), body: jsonEncode(data));

      // log("==get all subscription ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception get All Subscription ==>> $Exception");
    }
  }

  /// delete Subscription
  Future deleteSubscription(String subsId) async {
    try {
      Map<String, dynamic> data = {"subscriptionID": subsId, "subscriptionStatus": "Cancelled", "orderType": "Subscription"};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.deleteSubscription), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception delete Subscription ==>> $Exception");
    }
  }

  /// get All Subscription order
  Future getAllSubscriptionOrder(String userID) async {
    try {
      Map<String, dynamic> data = {"subFID": userID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getSubscriptionOrder), body: jsonEncode(data));

      // log("===>>>>> get subs vendor ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception get All Subscription ==>> $Exception");
    }
  }

  /// subscription assign
  Future subscriptionAssign({required String orderID, required String deliveryId}) async {
    try {
      Map data = {"orderID": orderID, "Deliveryboyid": deliveryId};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.subscriptionAssign);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>>  get subscription assign ${response.statusCode} $data");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get subscription assign error <== $e");
      return "error";
    }
  }

  /// online sell state
  Future onlineState(String id) async {
    try {
      Map<String, dynamic> data = {"Subfrid": id};
      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.onlineState), body: jsonEncode(data));

      // log("onlineState==>> ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("onlineState ==>> $Exception");
      return "error";
    }
  }

  /// offline sell state
  Future offlineState(String id) async {
    try {
      Map<String, dynamic> data = {"Subfrid": id};
      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.offlineState), body: jsonEncode(data));

      // log("offline State==>> ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("offline State ==>> $Exception");
      return "error";
    }
  }

  /// get Units
  Future getUnits() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.apiUrl + AppConfig.getUnits));

      // log("offline State==>> ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("getUnits ==>> $Exception");
      return "error";
    }
  }

  /// get Discount
  Future getDiscount(String id) async {
    try {
      Map<String, dynamic> data = {"Subfrid": id};
      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getDiscount), body: jsonEncode(data));

      log("offline State==>> ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("get Discount ==>> $Exception");
      return "error";
    }
  }

  /// get Leave
  Future getLeave(String userID) async {
    try {
      Map data = {"Subfid": userID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getLeave);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> get leave module ${response.statusCode}");
      log("===>>> get leave module $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === get leave module === $e');
      return "error";
    }
  }

  /// delete Leave
  Future deleteLeave(String leaveID, String status) async {
    try {
      Map data = {"leavedeliveryID": leaveID, "leavedeliveryStatus": status};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.deleteLeave);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> delete leave ${response.statusCode}");
      log("===>>> delete leave $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === delete leave err=== $e');
      return "error";
    }
  }

  /// Shop on off
  Future shopOnOff(String userID, String userStatus) async {
    try {
      Map data = {"userID": userID, "userStatus": userStatus};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.shopOff);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> Shop on off ${response.statusCode}");
      log("===>>> Shop on off $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === Shop on off err=== $e');
      return "error";
    }
  }

  /// request more
  Future requestMore(RequestMore data) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.requestMore);

      final response = await http.post(url, body: jsonEncode(data.toJson()));

      log("===>>> request more ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === request more err=== $e');
      return "error";
    }
  }

  /// get request more
  Future getRequestMore(String id) async {
    try {
      Map data = {"Subfid": id};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getRequestMore);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> get request more ${response.statusCode}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === get request more err=== $e');
      return "error";
    }
  }

  /// get review
  Future getReview(String id) async {
    try {
      Map data = {"Subfid": id};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getReview);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> get review ${response.statusCode}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === get review err=== $e');
      return "error";
    }
  }

  /// update lat long
  Future updateLatLong({required String id, required String userLat, required String userLong}) async {
    try {
      Map data = {"userID": id, "userLat": userLat, "userLong": userLong};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateLatLong);

      final response = await http.post(url, body: jsonEncode(data));

      debugPrint("===>>> get review ${response.statusCode} \n data ===>>>> $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === get review err=== $e');
      return "error";
    }
  }
}
