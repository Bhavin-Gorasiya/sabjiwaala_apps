import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../helper/app_config.dart';
import '../models/enquiry.dart';
import '../models/leave_model.dart';
import '../models/profile_model.dart';

class WebService {
  /// get State
  Future getState() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.apiUrl + AppConfig.getState));

      if (response.statusCode == 200) {
        debugPrint("===>>> get state ${response.statusCode}");
        return response;
      } else {
        return "error";
      }
    } on Exception {
      debugPrint("exception$Exception");
    }
  }

  /// get city
  Future getCity(String stateID) async {
    try {
      Map<String, dynamic> data = {"stateID": stateID};
      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getCity), body: jsonEncode(data));

      if (response.statusCode == 200) {
        debugPrint("===>>> get city ${response.statusCode}");
        return response;
      } else {
        return "error";
      }
    } on Exception {
      debugPrint("exception$Exception");
    }
  }

  /// send OTP
  Future sendOtp({required String mobileNumber}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.sendOtp);

      Map data = {"userPhoneno": mobileNumber};
      debugPrint("==== send otp web service  $data");
      debugPrint("==== send otp web service url  $url");
      final response = await http.post(
        url,
        body: jsonEncode(data),
      );
      debugPrint("==== send otp web service  ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(" === catch send Otp === $e");
      return "error";
    }
  }

  /// verify Otp
  Future verifyOtp({required String userMobileno, required String otp}) async {
    try {
      Map data = {"userPhoneno": userMobileno, "otp": otp};

      debugPrint("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.verifyOtp);

      final response = await http.post(url, body: jsonEncode(data));
      debugPrint(" ====verify otp ====${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(" === catch verify Otp === $e");
      return "error";
    }
  }

  /// update fcm
  Future updateFcm({required String userID, required String token, required String platform}) async {
    try {
      Map data = {"userID": userID, "userPlatformos": platform, "userFcmtoken": token};

      debugPrint("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateFcm);

      final response = await http.post(url, body: jsonEncode(data));
      debugPrint(" ====update otp ====${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(" === catch update Otp === $e");
      return "error";
    }
  }

  /// get Profile
  Future getProfile(userID) async {
    try {
      Map data = {"userID": userID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getProfile);

      final response = await http.post(url, body: jsonEncode(data));
      debugPrint(" ====getProfile ====${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(" === getProfile === $e");
    }
  }

  /// edit Profile api
  Future editProfile(ProfileModel profileModel) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.editProfile);

      final response = await http.post(url, body: jsonEncode(profileModel.toJson()));

      debugPrint("==>> editProfile == ${profileModel.toJson()} ${response.statusCode}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(' === editProfile === $e');
      return "error";
    }
  }

  /// update Profile pic
  Future updateProfilePic(String imgPath, String userID) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateProfilePic);

      http.MultipartRequest request = http.MultipartRequest("POST", url);
      debugPrint(imgPath);

      request
        ..fields['userID'] = userID
        ..files.add(await http.MultipartFile.fromPath('file', imgPath));
      var res = await request.send();
      final response = await http.Response.fromStream(res);
      debugPrint(" ==== update Profile pic ====${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint(" === update Profile pic === $e");
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
      debugPrint("==>>  enquiry ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      debugPrint("  ==> Enquiry error <== $e");
      return "error";
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
      debugPrint("exception$e");
    }
  }

  /// get order
  Future getOrder(userId) async {
    try {
      Map body = {"Deliveryboyid": "14"};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getOrder), body: jsonEncode(body));

      // log("==>>> get order ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("===>>> get all order error $e");
      return 'error';
    }
  }

  /// get Subscription
  Future getSubs(userId) async {
    try {
      Map body = {"Deliveryboyid": "14"};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getSubsOrder), body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("===>>> get all Subscription error $e");
      return 'error';
    }
  }

  /// change status
  Future changeStatus({required String id, required String status, required String type}) async {
    try {
      Map body = type == "Order"
          ? {"orderID": id, "orderStatus": status, "orderType": type}
          : {"subscriptionorderID": id, "subscriptionorderStatus": status, "orderType": type};

      log("==>> change status $body");

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.changeStatus), body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("===>>> get all Subscription error $e");
      return 'error';
    }
  }

  /// get Leave
  Future getLeave(String userID) async {
    try {
      Map data = {"leavedeliveryDbid": userID};

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
  Future deleteLeave(String leaveID) async {
    try {
      Map data = {"leavedeliveryID": leaveID};

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

  /// edit Leave
  Future editLeave(EditLeave data) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.editLeave);

      final response = await http.post(url, body: jsonEncode(data.toJson()));

      log("===>>> edit leave ${response.statusCode}");
      log("===>>> edit leave ${data.toJson()}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === edit leave err=== $e');
      return "error";
    }
  }

  /// add Leave
  Future addLeave(AddLeaveModel data) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addLeave);

      final response = await http.post(url, body: jsonEncode(data.toJson()));

      log("===>>> add leave ${data.toJson()}");
      // log("===>>> add leave $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === add leave err=== $e');
      return "error";
    }
  }
}
