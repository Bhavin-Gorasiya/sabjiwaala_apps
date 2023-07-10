import 'dart:developer';
import 'dart:convert';
import 'package:employee_app/models/attendance_model.dart';
import 'package:employee_app/models/lead_model.dart';
import 'package:employee_app/models/profile_model.dart';
import 'package:employee_app/models/training_model.dart';
import 'package:employee_app/models/work_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../helper/app_config.dart';

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

      log("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.verifyOtp);

      final response = await http.post(url, body: jsonEncode(data));
      log(" ====verify otp ====${response.statusCode}");
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
  Future updateFcm({required String userID, required String token, required String platform}) async {
    try {
      Map data = {"userID": userID, "userPlatformos": platform, "userFcmtoken": token};

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

  /// add work
  Future addWork({required WorkModel model, required String img}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addWork);
      http.MultipartRequest request = http.MultipartRequest('POST', url);

      request
        ..fields['workhistoryUid'] = model.workhistoryUid ?? ''
        ..fields['workhistoryTfrom'] = model.workhistoryTfrom ?? ''
        ..fields['workhistoryTto'] = model.workhistoryTto ?? ''
        ..fields['workhistorySubject'] = model.workhistorySubject ?? ''
        ..fields['workhistoryMsg'] = model.workhistoryMsg ?? ""
        ..files.add(await http.MultipartFile.fromPath('file', img));

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      log('++++=== add Work ${response.body} $img');
      if (response.statusCode == 200) {
        // log('=== updateProfile == ${response.body}');
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === add Work === $e');
      return "error";
    }
  }

  /// edit work
  Future editWork({required WorkModel model, String? img}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.editWork);
      http.MultipartRequest request = http.MultipartRequest('POST', url);

      request
        ..fields['workhistoryID'] = model.workhistoryId ?? ''
        ..fields['workhistoryUid'] = model.workhistoryUid ?? ''
        ..fields['workhistoryTfrom'] = model.workhistoryTfrom ?? ''
        ..fields['workhistoryTto'] = model.workhistoryTto ?? ''
        ..fields['workhistorySubject'] = model.workhistorySubject ?? ''
        ..fields['workhistoryMsg'] = model.workhistoryMsg ?? "";
      if (img != null) {
        request.files.add(await http.MultipartFile.fromPath('file', img));
      }

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      log('++++=== edit Work ${response.statusCode}');
      if (response.statusCode == 200) {
        // log('=== updateProfile == ${response.body}');
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === edit Work === $e');
      return "error";
    }
  }

  /// get All Work profile
  Future getAllWork({required String userId}) async {
    try {
      Map data = {"userID": userId};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllWork);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === getAllWork === $e');
      return "error";
    }
  }

  /// add Lead
  Future addLead({required LeadModel model}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addLead);

      final response = await http.post(url, body: jsonEncode(model.toJson()));

      log("==>> add lead == ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === add lead === $e');
      return "error";
    }
  }

  /// update Lead
  Future editLead({required LeadModel model}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateLead);

      final response = await http.post(url, body: jsonEncode(model.toJson()));

      log("==>> update lead == ${response.statusCode}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === update lead === $e');
      return "error";
    }
  }

  /// delete Lead
  Future deleteLead(String visitID) async {
    try {
      Map data = {"VistID": visitID};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.deleteLead);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> delete Lead error <== $e");
      return "error";
    }
  }

  /// get All Work profile
  Future getAllLead({required String leadID}) async {
    try {
      Map data = {"EmpID": leadID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllLead);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === getAllLead === $e');
      return "error";
    }
  }

  /// get all user
  Future getAllUser() async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAccessType);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === getAllUser === $e');
      return "error";
    }
  }

  /// attendance
  Future attendance({required Attendance attendance}) async {
    try {
      Map? data;
      if (attendance.type == "checkin") {
        data = {
          "attendanceDates": attendance.attendanceUid,
          "attendanceIP": attendance.attendanceIp,
          "attendanceUid": attendance.attendanceUid,
          "attendanceStime": attendance.attendanceStime,
          "type": attendance.type
        };
      } else {
        data = {
          "attendanceDates": attendance.attendanceUid,
          "attendanceUid": attendance.attendanceUid,
          "attendanceEtime": attendance.attendanceEtime,
          "type": attendance.type
        };
      }
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.attendance);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> attendance error <== $e");
      return "error";
    }
  }

  /// add Enquiry
  Future addEnquiry({required Enquiry enquiry}) async {
    try {
      Map data = {
        "enquiryEmp": enquiry.enquiryEmp,
        "enquiryUid": enquiry.enquiryUid,
        "enquiryUtype": enquiry.enquiryUtype,
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

  /// get all Master details
  Future getMasterDetails({required String empid, required String empType, String? upperId}) async {
    try {
      Map data = {"Empid": empid, "Emptype": empType, "Uperid": upperId ?? ""};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getMasterDetails);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>>  get all Master details ${response.statusCode} \n $data");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all Master details error <== $e");
      return "error";
    }
  }

  /// get all inventory details
  Future getInventoryDetails({required String userID, required String userType}) async {
    try {
      Map data = {"userID": userID, "userType": userType};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getInventoryDetails);

      log("==>>> get inventory body $data");

      final response = await http.post(url, body: jsonEncode(data));
      log("==>>  get all inventory details ${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all inventory details error <== $e");
      return "error";
    }
  }

  /// get Assign User
  Future getAssignUser({required String empId}) async {
    try {
      Map data = {"Empid": empId};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAssignUser);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === getAssignUser === $e');
      return "error";
    }
  }

  /// make Client
  Future makeClient({required String empId, required String leadId, String? assignId, String? pass}) async {
    try {
      Map data = {"LeadID": leadId, "userEmpid": empId, "userUid": assignId ?? "0", "userPassword": pass ?? "0"};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.makeClient);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === make Client === $e');
      return "error";
    }
  }

  /// get enquiry
  Future getEnquiry({required String enquiryEmp, required String enquiryUtype}) async {
    try {
      Map data = {"enquiryEmp": enquiryEmp, "enquiryUtype": enquiryUtype};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getEnquiry);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === get enquiry === $e');
      return "error";
    }
  }

  /// get enquiry by id
  Future getEnquiryById({required String enquiryEmp, required String enquiryUid, required String enquiryUtype}) async {
    try {
      Map data = {"enquiryEmp": enquiryEmp, "enquiryUid": enquiryUid, "enquiryUtype": enquiryUtype};

      log("===>>> get enquiry by id $data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getEnquiryById);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === getEnquiryById === $e');
      return "error";
    }
  }

  /// accept Req
  Future acceptReq({
    required String productID,
    required String Qty,
    required String empID,
    required String userID,
    required String requestqtyID,
  }) async {
    try {
      Map data = {"productID": productID, "Qty": Qty, "empID": empID, "userID": userID, "requestqtyID": requestqtyID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.acceptQty);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> get enquiry by id ${response.statusCode}");
      log("===>>> get enquiry by id ${data}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === accept Req === $e');
      return "error";
    }
  }

  /// decline Req
  Future declineReq({required String requestqtyID}) async {
    try {
      Map data = {"requestqtyID": requestqtyID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.declineQty);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> get enquiry by id ${response.body}");
      log("===>>> get enquiry by id $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === decline Req === $e');
      return "error";
    }
  }

  /// training module
  Future getTraining() async {
    try {
      Map data = {"userType": "1"};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.training);

      final response = await http.post(url, body: jsonEncode(data));

      log("===>>> training module ${response.statusCode}");
      log("===>>> training module $data");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === training module === $e');
      return "error";
    }
  }

  /// get Leave
  Future getLeave(String userID) async {
    try {
      Map data = {"userID": userID};

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
      Map data = {"leaveID": leaveID};

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

      log("===>>> add leave ${response.statusCode}");
      log("===>>> add leave $data");

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
