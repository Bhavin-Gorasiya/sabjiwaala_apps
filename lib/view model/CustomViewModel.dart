import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:employee_app/models/attendance_model.dart';
import 'package:employee_app/models/enquiry_model.dart';
import 'package:employee_app/models/lead_model.dart';
import 'package:employee_app/models/profile_model.dart';
import 'package:employee_app/models/training_model.dart';
import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import '../api/app_preferences.dart';
import '../models/state_city_model.dart';
import '../models/work_model.dart';
import '../service/web_service.dart';

class CustomViewModel extends ChangeNotifier {
  WebService webService = WebService();
  String? camImg;

  changeCamImg(String? img) {
    camImg = img;
    notifyListeners();
  }

  bool isLoading = false;
  bool attendance = false;
  List<WorkModel> workList = [];
  List<WorkModel> filterWorkList = [];
  List<WorkModel> todayWork = [];
  List<LeadModel> leadList = [];
  List<LeadModel> filterLeadList = [];
  List<UserTypeModel> userList = [];

  changeLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  ProfileModel? profileDetails;

  /// state city data
  List<StateModel> stateList = [];
  List stateNameList = [];
  String stateID = "";
  List<CityModel> cityList = [];
  List cityNameList = [];
  String cityID = "";
  bool cityLoad = false;

  void changeCityId(String cityId) {
    cityID = cityId;
    notifyListeners();
  }

  /// get state
  Future getState() async {
    stateList = [];
    final response = await webService.getState();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          StateModel stateModel = StateModel.fromJson(data);
          stateList.add(stateModel);
          stateNameList.add(stateModel.stateName ?? "State");
        }
        return "success";
      } else {
        return "error";
      }
    } else {
      return "error";
    }
  }

  /// get city
  Future getCity(String stateID) async {
    cityLoad = true;
    cityList = [];
    cityNameList = [];
    this.stateID = stateID;
    notifyListeners();
    final response = await webService.getCity(stateID);
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          CityModel cityModel = CityModel.fromJson(data);
          cityList.add(cityModel);
          cityNameList.add(cityModel.locationCity ?? "city");
          log("==>> city list ${cityNameList.length}");
        }
        cityLoad = false;
        notifyListeners();
        return "success";
      } else {
        cityLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      cityLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// send otp
  Future sendOtp(mobile, bool otp, BuildContext context) async {
    if (!otp) isLoading = true;
    notifyListeners();

    final response = await webService.sendOtp(mobileNumber: mobile);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        if (responseDecoded['data'] == "Account does not exists") {
          snackBar(context, "Account does not exists");
          isLoading = false;
          notifyListeners();

          return "error";
        } else {
          isLoading = false;
          notifyListeners();

          return "success";
        }
      } else {
        isLoading = false;
        snackBar(context, "Enable to Generate OTP");
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      snackBar(context, "Enable to Generate OTP");
      notifyListeners();
      return "error";
    }
  }

  /// verify otp
  Future verifyOtp(userMobileno, otp) async {
    isLoading = true;
    notifyListeners();

    final response = await webService.verifyOtp(userMobileno: userMobileno, otp: otp);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        if (responseDecoded['data'] == "Account does not exists") {
          isLoading = false;
          notifyListeners();
          log('not register');
          return "not register";
        } else if (responseDecoded['data'] == "Invalid data") {
          isLoading = false;
          notifyListeners();
          return "error";
        } else if (responseDecoded['data'] == "Mobile no. not found") {
          isLoading = false;
          notifyListeners();
          return "mobile error";
        } else if (responseDecoded['data'] == "OTP not match" ||
            responseDecoded['data'] == "Max limit reached for this otp verification") {
          isLoading = false;
          notifyListeners();
          return "otp error";
        } else {
          profileDetails = ProfileModel.fromJson(responseDecoded['data'][0]);

          AppPreferences.setLoggedin(responseDecoded['data'][0]['userID']);

          isLoading = false;
          notifyListeners();
          return "register";
        }
      } else {
        isLoading = false;
        notifyListeners();
        return "otp error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// get Profile
  ///
  String totalMF = '0';
  String totalF = '0';
  String totalSF = '0';
  String totalFM = '0';

  Future getProfile() async {
    profileDetails = null;

    var userID = await AppPreferences.getLoggedin();
    bool attendances = await AppPreferences.getAttendance();
    attendance = attendances;
    notifyListeners();
    log("==== >>>  user id $userID");
    log("==== >>>  attendance $attendance");

    final response = await webService.getProfile(userID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      // log("==== >>>  attendance ${responseDecoded['data']}");

      if (responseDecoded['status'] != "false") {
        profileDetails = ProfileModel.fromJson(responseDecoded['data'][0]);
        totalMF = responseDecoded['TotalMF'].toString();
        totalF = responseDecoded['TotalF'].toString();
        totalSF = responseDecoded['TotalSF'].toString();
        totalFM = responseDecoded['TotalFM'].toString();
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      notifyListeners();
      return "error";
    }
  }

  /// update Profile
  Future updateProfile(ProfileModel model) async {
    changeLoading(true);
    final response = await webService.editProfile(model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null) {
        await getProfile();
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// update Profile Pic
  Future updateProfilePic(String imgPath, String userID) async {
    final response = await webService.updateProfilePic(imgPath, userID);

    if (response != "error") {
      // log("==>> update profile ${response.body}");
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null) {
        return "success";
      } else {
        return "error";
      }
    } else {
      return "error";
    }
  }

  /// update fcm
  Future updateFCM(String fcm) async {
    final response = await webService.updateFcm(
        userID: profileDetails!.userID ?? "", token: fcm, platform: Platform.isAndroid ? "Android" : "IOS");

    if (response != "error") {
      // log("==>> update profile ${response.body}");
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null) {
        return "success";
      } else {
        return "error";
      }
    } else {
      return "error";
    }
  }

  /// delete account
  Future deleteAccount() async {
    changeLoading(true);
    var userID = await AppPreferences.getLoggedin();

    final response = await webService.deleteAccount(userID);

    if (response != "error" && response != null) {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var status = responseDecoded['status'];

      if (status == "true") {
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "Could not delete, Try again after sometime";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// get Work
  Future getWork(String userId) async {
    workList = [];
    todayWork = [];
    filterWorkList = [];
    changeLoading(true);
    final response = await webService.getAllWork(userId: userId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      log('===>> get work $responseDecoded');
      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var data in responseDecoded['data']) {
          DateTime today = DateTime.now();
          WorkModel workModel = WorkModel.fromJson(data);
          DateTime workTime = workModel.workhistoryDate!;
          if (workTime.year == today.year &&
              workTime.month == today.month &&
              workTime.day == today.day /*workModel.workhistoryDate!.difference(time).inDays < 1*/) {
            todayWork.add(workModel);
          }
          workList.add(workModel);
          filterWorkList.add(workModel);
        }
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// filter work list
  filterWork({required DateTime start, required DateTime end}) {
    filterWorkList = [];
    for (WorkModel data in workList) {
      if (data.workhistoryDate!.difference(start).inDays > 0) {
        if (data.workhistoryDate!.difference(end).inDays <= 0) {
          filterWorkList.add(data);
        }
      }
    }
    notifyListeners();
  }

  /// add Work
  Future addWork({required WorkModel model, required String img}) async {
    changeLoading(true);
    final response = await webService.addWork(model: model, img: img);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        WorkModel workModel = WorkModel.fromJson(responseDecoded['data'][0]);
        workList.add(workModel);
        todayWork.add(workModel);
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// edit Work
  Future editWork({required WorkModel model, String? img}) async {
    changeLoading(true);
    final response = await webService.editWork(model: model, img: img);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        await getWork(model.workhistoryUid!);
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// get Lead
  Future getLead(String leadId, {String? id}) async {
    leadList = [];
    changeLoading(true);
    final response = await webService.getAllLead(leadID: leadId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var data in responseDecoded['data']) {
          LeadModel leadModel = LeadModel.fromJson(data);
          leadList.add(leadModel);
          filterLead(id ?? "2");
        }
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// filter lead
  filterLead(String id) {
    filterLeadList = [];
    for (LeadModel data in leadList) {
      if (data.leadType == id) {
        filterLeadList.add(data);
      }
    }
    notifyListeners();
  }

  /// add Lead
  Future addLead({required LeadModel model}) async {
    changeLoading(true);
    final response = await webService.addLead(model: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        LeadModel leadModel = LeadModel.fromJson(responseDecoded['data'][0]);
        leadList.add(leadModel);
        filterLeadList.add(leadModel);
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// edit Lead
  Future editLead({required LeadModel model}) async {
    changeLoading(true);
    final response = await webService.editLead(model: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        await getLead(model.leadUid!, id: model.leadType);
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// delete Lead
  Future deleteLead(String leadID) async {
    changeLoading(true);
    final response = await webService.deleteLead(leadID);

    if (response != "error" && response != null) {
      var responseDecoded = jsonDecode(response.body);
      var status = responseDecoded['status'];

      if (status == "true") {
        filterLeadList.removeWhere((element) => element.leadId == leadID);
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        notifyListeners();
        return "Could not delete, Try again after sometime";
      }
    } else {
      changeLoading(false);
      notifyListeners();
      return "error";
    }
  }

  /// get user
  Future getUser() async {
    userList = [];
    changeLoading(true);
    final response = await webService.getAllUser();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        for (var data in responseDecoded['data']) {
          UserTypeModel userModel = UserTypeModel.fromJson(data);
          userList.add(userModel);
        }
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// attendance
  changeAttendance(bool value) {
    attendance = value;
    notifyListeners();
  }

  Future setAttendance({required Attendance model}) async {
    changeLoading(true);
    final response = await webService.attendance(attendance: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        attendance = !attendance;
        if (model.type == "checkin") {
          await AppPreferences.setAttendance(true);
        } else {
          await AppPreferences.setAttendance(false);
        }
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// add enquiry
  Future addEnquiry({required Enquiry model}) async {
    changeLoading(true);
    final response = await webService.addEnquiry(enquiry: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  ///
  /// get all Master details
  ///

  List<UserModel> masterData = [];
  List<UserModel> franchiseData = [];
  List<UserModel> subFranchiseData = [];
  List<UserModel> farmerData = [];

  List<UserModel> searchMasterData = [];
  List<UserModel> searchFranchiseData = [];
  List<UserModel> searchSubFranchiseData = [];
  List<UserModel> searchFarmerData = [];

  Future getMasterDetails({required String empid, required String empType, String? upperId}) async {
    log("==>> emp type $empType  emp Id =$empid  upper id= $upperId");
    if (empType == "2") {
      masterData = [];
      searchMasterData = [];
    } else if (empType == "3") {
      franchiseData = [];
      searchFranchiseData = [];
    } else if (empType == "4") {
      subFranchiseData = [];
      searchSubFranchiseData = [];
    } else {
      farmerData = [];
      searchFarmerData = [];
    }
    changeLoading(true);
    final response = await webService.getMasterDetails(empid: empid, empType: empType, upperId: upperId ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null) {
        if (responseDecoded['data'] != "No Details Found!") {
          for (var data in responseDecoded['data']) {
            UserModel master = UserModel.fromJson(data);
            if (empType == "2") {
              masterData.add(master);
              searchMasterData.add(master);
              log('====>>>> masterData data ${masterData.length}');
            } else if (empType == "3") {
              franchiseData.add(master);
              searchFranchiseData.add(master);
              log('====>>>> franchiseData data ${franchiseData.length}');
            } else if (empType == "4") {
              subFranchiseData.add(master);
              searchSubFranchiseData.add(master);
              log('====>>>> subFranchiseData data ${subFranchiseData.length}');
            } else {
              farmerData.add(master);
              searchFarmerData.add(master);
              log('====>>>> farmerData data ${farmerData.length}');
            }
          }
          changeLoading(false);
          return "success";
        } else {
          changeLoading(false);
          return "error";
        }
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  ///
  /// search user
  ///
  void searchUser(String search, String userType) {
    if (search == "") {
      searchMasterData = masterData;
      searchFranchiseData = franchiseData;
      searchSubFranchiseData = subFranchiseData;
      searchFarmerData = farmerData;
      notifyListeners();
    } else {
      searchMasterData = [];
      searchFranchiseData = [];
      searchSubFranchiseData = [];
      searchFarmerData = [];
      notifyListeners();
    }
    if (userType == "2") {
      searchMasterData = common(masterData, search);
    } else if (userType == "3") {
      searchFranchiseData = common(franchiseData, search);
    } else if (userType == "4") {
      searchSubFranchiseData = common(subFranchiseData, search);
    } else {
      searchFarmerData = common(farmerData, search);
    }
  }

  List<UserModel> common(List<UserModel> list, String search) {
    List<UserModel> dummy = [];
    for (UserModel data in list) {
      String name = "${data.userFname!.toLowerCase()} ${data.userLname!.toLowerCase()}";
      if (name.contains(search) || data.userMobileno1!.toLowerCase().contains(search)) {
        dummy.add(data);
        notifyListeners();
      }
    }
    return dummy;
  }

  ///
  /// get all Inventory details
  ///
  List<MasterInventoryModel> masterInventory = [];
  List<FranchiseInventoryModel> franchiseInventory = [];
  List<SubInventoryModel> subFranchiseInventory = [];
  List<FarmerInventoryModel> farmerInventory = [];

  List<RequestQtyModel> masterReqInventory = [];
  List<RequestQtyModel> franchiseReqInventory = [];
  List<RequestQtyModel> subFranchiseReqInventory = [];
  List<RequestQtyModel> farmerReqInventory = [];

  Future getInventoryDetails({required String userID, required String userType}) async {
    log("==>> userType type $userType  id= $userID");
    if (userType == "2") {
      masterInventory = [];
      masterReqInventory = [];
    } else if (userType == "3") {
      franchiseInventory = [];
      franchiseReqInventory = [];
    } else if (userType == "4") {
      subFranchiseInventory = [];
      subFranchiseReqInventory = [];
    } else {
      farmerInventory = [];
      farmerReqInventory = [];
    }
    changeLoading(true);
    final response = await webService.getInventoryDetails(userID: userID, userType: userType);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null) {
        // log("==>> inventory data ${responseDecoded['data'][0]['mfinventory']}");
        for (var data in responseDecoded['data'][0]['mfinventory']) {
          if (userType == "2") {
            MasterInventoryModel master = MasterInventoryModel.fromJson(data);
            masterInventory.add(master);
            // log('====>>>> master Inventory ${masterInventory.length}');
          } else if (userType == "3") {
            FranchiseInventoryModel master = FranchiseInventoryModel.fromJson(data);
            franchiseInventory.add(master);
            // log('====>>>> franchise Inventory ${franchiseInventory.length}');
          } else if (userType == "4") {
            SubInventoryModel master = SubInventoryModel.fromJson(data);
            subFranchiseInventory.add(master);
            // log('====>>>> subFranchise Inventory ${subFranchiseInventory.length}');
          } else {
            FarmerInventoryModel master = FarmerInventoryModel.fromJson(data);
            farmerInventory.add(master);
            // log('====>>>> farmer Inventory ${farmerInventory.length}');
          }
        }
        if (userType != "5") {
          for (var data in responseDecoded['data'][0]['Requestqty']) {
            RequestQtyModel master = RequestQtyModel.fromJson(data);
            if (userType == "2") {
              masterReqInventory.add(master);
              // log('====>>>> masterReq Inventory ${masterReqInventory.length}');
            } else if (userType == "3") {
              franchiseReqInventory.add(master);
              // log('====>>>> franchiseReq Inventory ${franchiseReqInventory.length}');
            } else if (userType == "4") {
              subFranchiseReqInventory.add(master);
              // log('====>>>> subFranchiseReq Inventory ${subFranchiseReqInventory.length}');
            } else {
              farmerReqInventory.add(master);
              // log('====>>>> farmerReq Inventory ${farmerReqInventory.length}');
            }
          }
        }
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// filter req qty list
  List<RequestQtyModel> filterMasterReqInventory = [];
  List<RequestQtyModel> filterFranchiseReqInventory = [];
  List<RequestQtyModel> filterSubFranchiseReqInventory = [];
  List<RequestQtyModel> filterFarmerReqInventory = [];

  ///
  filterReqQty({required DateTime start, required DateTime end}) {
    filterWorkList = [];
    for (WorkModel data in workList) {
      if (data.workhistoryDate!.difference(start).inDays > 0) {
        if (data.workhistoryDate!.difference(end).inDays <= 0) {
          filterWorkList.add(data);
        }
      }
    }
    notifyListeners();
  }

  /// get Assign User
  List<AssignUser> mFUser = [];
  List<AssignUser> fUser = [];
  List<AssignUser> sFUser = [];

  ///
  Future getAssignUser({required String empId}) async {
    mFUser = [];
    fUser = [];
    sFUser = [];
    changeLoading(true);
    final response = await webService.getAssignUser(empId: empId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        for (var data in responseDecoded['MF']) {
          AssignUser user = AssignUser.fromJson(data);
          mFUser.add(user);
        }
        for (var data in responseDecoded['F']) {
          AssignUser user = AssignUser.fromJson(data);
          fUser.add(user);
        }
        for (var data in responseDecoded['SF']) {
          AssignUser user = AssignUser.fromJson(data);
          sFUser.add(user);
        }
        log("===>> get assign user ${mFUser.length}");
        changeLoading(false);
        notifyListeners();
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// make client
  Future makeClient(
      {required String empId, required String leadId, String? assignId, String? pass, required String leadType}) async {
    changeLoading(true);
    final response = await webService.makeClient(empId: empId, leadId: leadId, assignId: assignId, pass: pass);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        await getLead(leadId, id: leadType);
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// get Enquiry
  List<EnquiryModel> enquiryList = [];

  ///
  Future getEnquiry({required String enquiryEmp, required String enquiryUtype}) async {
    enquiryList = [];
    changeLoading(true);
    final response = await webService.getEnquiry(enquiryEmp: enquiryEmp, enquiryUtype: enquiryUtype);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null && responseDecoded['data'] != "No Details Found!") {
        for (var data in responseDecoded['data']) {
          EnquiryModel enquiry = EnquiryModel.fromJson(data);
          enquiryList.add(enquiry);
        }
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// get Enquiry by id
  List<EnquiryModel> enquiryListById = [];
  bool enqLoad = false;

  changeEnqLoading(bool value) {
    enqLoad = value;
    notifyListeners();
  }

  ///
  Future getEnquiryById({required String enquiryEmp, required String enquiryUid, required String enquiryUtype}) async {
    enquiryListById = [];
    changeEnqLoading(true);
    final response =
        await webService.getEnquiryById(enquiryEmp: enquiryEmp, enquiryUid: enquiryUid, enquiryUtype: enquiryUtype);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null && responseDecoded['data'] != "No Details Found!") {
        for (var data in responseDecoded['data']) {
          EnquiryModel enquiry = EnquiryModel.fromJson(data);
          enquiryListById.add(enquiry);
        }
        changeEnqLoading(false);
        return "success";
      } else {
        changeEnqLoading(false);
        return "error";
      }
    } else {
      changeEnqLoading(false);
      return "error";
    }
  }

  /// accept Req
  Future acceptReq({
    required String productID,
    required String Qty,
    required String empID,
    required String userID,
    required String userType,
    required String requestqtyID,
  }) async {
    changeLoading(true);
    final response = await webService.acceptReq(
        productID: productID, Qty: Qty, empID: empID, userID: userID, requestqtyID: requestqtyID);

    log(userType);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        getInventoryDetails(userID: userID, userType: userType);
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// decline Req
  Future declineReq({
    required String requestqtyID,
    required String userID,
    required String userType,
  }) async {
    changeLoading(true);
    final response = await webService.declineReq(requestqtyID: requestqtyID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        getInventoryDetails(userID: userID, userType: userType);
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// training module
  List<Training> trainingList = [];

  ///
  Future getTraining() async {
    trainingList = [];
    changeLoading(true);
    final response = await webService.getTraining();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        for (var data in responseDecoded['data']) {
          Training enquiry = Training.fromJson(data);
          trainingList.add(enquiry);
        }
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// leave module
  List<Leave> leaveList = [];
  List<Leave> filterLeaveList = [];

  ///
  Future getLeave(String userID) async {
    leaveList = [];
    filterLeaveList = [];
    changeLoading(true);
    final response = await webService.getLeave(userID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        for (var data in responseDecoded['data']) {
          Leave enquiry = Leave.fromJson(data);
          leaveList.add(enquiry);
          filterLeaveList.add(enquiry);
        }
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// filter leave list
  filterLeave({required DateTime start, required DateTime end}) {
    filterLeaveList = [];
    for (Leave data in leaveList) {
      if (data.leaveTodate == null) {
        if (data.leaveFromdate!.difference(start).inDays > 0) {
          if (data.leaveFromdate!.difference(end).inDays <= 0) {
            filterLeaveList.add(data);
          }
        }
      } else {
        log("===>>> from ${data.leaveFromdate}  to ${data.leaveTodate} ");
        log("===>>> from to start ${start.difference(data.leaveFromdate!).inDays}");
        if (start.difference(data.leaveFromdate!).inDays > 0) {
          log("===>>> leave to start ${start.difference(data.leaveTodate!).inDays}");
          if (start.difference(data.leaveTodate!).inDays <= 0) {
            filterLeaveList.add(data);
          }
        }
        log("===>>> from to end ${end.difference(data.leaveFromdate!).inDays}");
        if (end.difference(data.leaveFromdate!).inDays > 0) {
          log("===>>> leave to end ${end.difference(data.leaveTodate!).inDays}");
          if (end.difference(data.leaveTodate!).inDays <= 0) {
            if (filterLeaveList.isEmpty) {
              filterLeaveList.add(data);
            } else {
              if (filterLeaveList.last.leaveId != data.leaveId) {
                filterLeaveList.add(data);
              }
            }
          }
        }
      }
    }
    notifyListeners();
  }

  /// delete leave
  Future deleteLeave({required String leaveID, required String userID}) async {
    changeLoading(true);
    final response = await webService.deleteLeave(leaveID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        await getLeave(userID);
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// edit leave
  Future editLeave({required EditLeave data, required String userID}) async {
    changeLoading(true);
    final response = await webService.editLeave(data);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        await getLeave(userID);
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }

  /// add leave
  Future addLeave({required AddLeaveModel data, required String userID}) async {
    changeLoading(true);
    final response = await webService.addLeave(data);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        await getLeave(userID);
        changeLoading(false);
        return "success";
      } else {
        changeLoading(false);
        return "error";
      }
    } else {
      changeLoading(false);
      return "error";
    }
  }
}
