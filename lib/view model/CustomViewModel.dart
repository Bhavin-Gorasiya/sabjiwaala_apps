import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sub_franchisee/models/order_model.dart';
import 'package:sub_franchisee/models/product_model.dart';
import '../api/app_preferences.dart';
import '../helper/navigations.dart';
import '../models/delivery_model.dart';
import '../models/enquiry.dart';
import '../models/leave_model.dart';
import '../models/profile_model.dart';
import '../models/state_city_model.dart';
import '../models/subscription_model.dart';
import '../service/web_service.dart';

class CustomViewModel extends ChangeNotifier {
  WebService webService = WebService();
  String? camImg;

  int bottomNavIndex = 0;

  ///change bottom nav index
  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;
    notifyListeners();
  }

  changeCamImg(String? img) {
    camImg = img;
    notifyListeners();
  }

  bool isLoading = false;
  bool attendance = false;
  String totalProduct = '0';
  String totalAmount = '0';
  double userPercentage = 0.35;
  List<DeliveryModel> deliveryBoyList = [];
  List<DeliveryModel> todayWork = [];

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

  /// get location
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openAppSettings();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    log('==== current position ${await Geolocator.getCurrentPosition()}');
    return await Geolocator.getCurrentPosition();
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
        if (responseDecoded['data'] == "User Not Found") {
          // ignore: use_build_context_synchronously
          snackBar(context, "User Not Found");
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
        // ignore: use_build_context_synchronously
        snackBar(context, "Enable to Generate OTP");
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      // ignore: use_build_context_synchronously
      snackBar(context, "Enable to Generate OTP");
      notifyListeners();
      return "error";
    }
  }

  /// verify otp
  Future verifyOtp(userMobileNo, otp) async {
    isLoading = true;
    notifyListeners();

    final response = await webService.verifyOtp(userMobileno: userMobileNo, otp: otp);

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
        } else if (responseDecoded['data'] == "OTP not match" || responseDecoded['data'] == "Max limit reached for this otp verification") {
          isLoading = false;
          notifyListeners();
          return "otp error";
        } else {
          profileDetails = ProfileModel.fromJson(responseDecoded['data'][0]);

          AppPreferences.setLoggedin(responseDecoded['data'][0]['userID']);
          userPercentage = int.parse(profileDetails!.userPercentage ?? "0") / 100;

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
  Future getProfile() async {
    profileDetails = null;

    var userID = await AppPreferences.getLoggedin();
    notifyListeners();
    log("==== >>>  user id $userID");

    final response = await webService.getProfile(userID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      // log("==== >>>  attendance ${responseDecoded}");
      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        profileDetails = ProfileModel.fromJson(responseDecoded['data'][0]);
        userPercentage = int.parse(profileDetails!.userPercentage ?? "0") / 100;
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
    log("==>>. update profile ${response.body}");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
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
      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
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

  /// get All Delivery Boy
  Future getAllDeliveryBoy(String userId) async {
    deliveryBoyList = [];
    changeLoading(true);
    final response = await webService.getAllDeliveryBoy(userId: userId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var data in responseDecoded['data']) {
          DeliveryModel deliveryModel = DeliveryModel.fromJson(data);
          deliveryBoyList.add(deliveryModel);
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

  /// add Delivery Boy
  Future addDeliveryBoy({required DeliveryModel model, required String img}) async {
    changeLoading(true);
    final response = await webService.addDeliveryBoy(model: model, img: img);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        DeliveryModel deliveryModel = DeliveryModel.fromJson(responseDecoded['data'][0]);
        deliveryBoyList.add(deliveryModel);
        todayWork.add(deliveryModel);
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

  /// update Delivery Boy
  Future updateDeliveryBoy({required DeliveryModel model, String? img}) async {
    changeLoading(true);
    final response = await webService.updateDeliveryBoy(model: model, img: img);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        await getAllDeliveryBoy(model.deliverypersonSfid!);
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

  /// delete Delivery Boy
  Future deleteDeliveryBoy(String leadID) async {
    changeLoading(true);
    final response = await webService.deleteDeliveryBoy(leadID);

    if (response != "error" && response != null) {
      var responseDecoded = jsonDecode(response.body);
      var status = responseDecoded['status'];

      if (status == "true") {
        await getAllDeliveryBoy(profileDetails!.userID ?? "");
        // filterLeadList.removeWhere((element) => element.leadId == leadID);
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

  /// add enquiry
  Future addEnquiry({required Enquiry model}) async {
    changeLoading(true);
    final response = await webService.addEnquiry(enquiry: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
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
  Future updateFCM({
    required String userID,
    required String userPlatformos,
    required String userFcmtoken,
    required String lat,
    required String long,
  }) async {
    changeLoading(true);
    final response = await webService.updateFcm(userID: userID, token: userFcmtoken, platform: userPlatformos, lat: lat, long: long);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
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

  /// get inventory
  List<InventoryModel> inventoryData = [];

  Future getInventory() async {
    inventoryData = [];
    changeLoading(true);
    final response = await webService.getAllProduct(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var data in responseDecoded['data']) {
          InventoryModel inventory = InventoryModel.fromJson(data);
          inventoryData.add(inventory);
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

  /// get product history
  List<ProductModel> productData = [];
  List<ProductModel> filterProductData = [];

  Future getProduct() async {
    productData = [];
    filterProductData = [];
    changeLoading(true);
    final response = await webService.getInventory(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var data in responseDecoded['data']) {
          ProductModel inventory = ProductModel.fromJson(data);
          productData.add(inventory);
          filterProductData.add(inventory);
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

  /// filter product history
  filterProductHistory({required DateTime start, required DateTime end}) {
    filterProductData = [];
    for (ProductModel data in productData) {
      if (data.inventorysfrDate!.difference(start).inDays > 0) {
        if (data.inventorysfrDate!.difference(end).inDays <= 0) {
          filterProductData.add(data);
        }
      }
    }
  }

  /// get order
  List<OrderModel> todayPOrderList = [];
  List<OrderModel> todayCOrderList = [];
  List<OrderModel> todayCacOrderList = [];
  List<OrderModel> orderList = [];
  List<OrderModel> filterOrderList = [];

  Future getOrder() async {
    changeLoading(true);
    final response = await webService.getOrder(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      // log("==>> get all order $responseDecoded");

      if (responseDecoded['status'] != "false") {
        orderList = [];
        todayPOrderList = [];
        filterOrderList = [];
        todayCOrderList = [];
        todayCacOrderList = [];
        for (var data in responseDecoded['today']) {
          OrderModel inventory = OrderModel.fromJson(data);
          if (inventory.orderStatus == "Completed") {
            todayCOrderList.add(inventory);
          } else if (inventory.orderStatus == "Cancelled") {
            todayCOrderList.add(inventory);
          } else {
            todayPOrderList.add(inventory);
          }
        }
        for (var data in responseDecoded['previous']) {
          OrderModel inventory = OrderModel.fromJson(data);
          orderList.add(inventory);
          filterOrderList.add(inventory);
        }
        // log("===>> order list ${todayOrderList.length}");
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

  /// filter order list
  filterOrder({required DateTime start, required DateTime end}) {
    filterOrderList = [];
    for (OrderModel data in orderList) {
      if (data.orderDate!.difference(start).inDays > 0) {
        if (data.orderDate!.difference(end).inDays <= 0) {
          filterOrderList.add(data);
        }
      }
    }
  }

  /// assign order
  Future assignOrder({required String orderID, required String deliveryId}) async {
    changeLoading(true);
    final response = await webService.orderAssign(orderID: orderID, deliveryId: deliveryId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        await getOrder();
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

  /// cancelled order
  Future cancelledOrder(String orderID, {String? status}) async {
    changeLoading(true);
    final response = await webService.cancelledOrder(orderID, status: status);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        await getOrder();
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

  /// cancelled subs order
  Future cancelledSubsOrder(String orderID) async {
    changeLoading(true);
    final response = await webService.cancelledSubsOrder(orderID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
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

  /// offline sell
  bool sellLoading = false;

  ///
  Future offlineSell(OfflineSell data) async {
    sellLoading = true;
    notifyListeners();
    final response = await webService.offlineSell(data);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        await getOfflineSell();
        sellLoading = false;
        notifyListeners();
        return "success";
      } else {
        sellLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      sellLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// get offline sell
  List<OfflineSellList> offlineSellList = [];
  List<OfflineSellList> filterOfflineSellList = [];

  ///
  Future getOfflineSell() async {
    offlineSellList = [];
    filterOfflineSellList = [];
    changeLoading(true);
    final response = await webService.getOfflineSell(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var data in responseDecoded['data']) {
          offlineSellList.add(OfflineSellList.fromJson(data));
          filterOfflineSellList.add(OfflineSellList.fromJson(data));
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

  /// filter offline sell list
  filterOfflineSell({required DateTime start, required DateTime end}) {
    filterOfflineSellList = [];
    for (OfflineSellList data in offlineSellList) {
      if (data.offlineorderorderDate!.difference(start).inDays > 0) {
        if (data.offlineorderorderDate!.difference(end).inDays <= 0) {
          filterOfflineSellList.add(data);
        }
      }
    }
  }

  /// get All Product Name
  List<ProductName> nameList = [];

  ///
  Future getAllProductName() async {
    nameList = [];
    changeLoading(true);
    final response = await webService.getAllProductName(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        for (var name in responseDecoded['data']) {
          nameList.add(ProductName.fromJson(name));
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

/*  /// add product for offline sell
  List<Productdatum> offlineSellItem = [];

  ///
  addProductName(Productdatum data) {
    offlineSellItem.add(data);
    notifyListeners();
  }

  removeProductName(Productdatum data) {
    offlineSellItem.remove(data);
    notifyListeners();
  }

  clearProductName() {
    offlineSellItem = [];
    notifyListeners();
  }*/

  /// get All Subscription
  List<VendorSubscription> subscriptionList = [];

  /// get All Subscription
  Future getAllSubscription() async {
    subscriptionList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getAllSubscription(profileDetails!.userID ?? "1");
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          VendorSubscription order = VendorSubscription.fromJson(data);
          subscriptionList.add(order);
        }
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return 'error';
    }
  }

  /// delete Subscription
  Future deleteSubscription({required String subscriptionID, required int index, required int mainIndex}) async {
    isLoading = true;
    final response = await webService.deleteSubscription(subscriptionID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      // log("===>>> get category $responseDecodedStatus");
      if (responseDecodedStatus == "true") {
        // subscriptionList[mainIndex].subscriptiondata![index].subscriptionStatus = "";
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// get All Subscription order
  List<Subscription> subsOrderList = [];

  Future getAllSubscriptionOrder() async {
    subsOrderList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getAllSubscriptionOrder(profileDetails!.userID ?? "1");
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          Subscription order = Subscription.fromJson(data);
          subsOrderList.add(order);
        }
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return 'error';
    }
  }

  /// assign Subscription
  Future assignSubscription({required String orderID, required String deliveryId}) async {
    changeLoading(true);
    final response = await webService.subscriptionAssign(orderID: orderID, deliveryId: deliveryId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        await getAllSubscriptionOrder();
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

  /// online sell state
  List<OnlineSellStats> onlineSellStats = [];
  List<OnlineSellStats> filterOnlineSellStats = [];

  ///
  Future onlineState() async {
    onlineSellStats = [];
    filterOnlineSellStats = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.onlineState(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          onlineSellStats.add(OnlineSellStats.fromJson(data));
          filterOnlineSellStats.add(OnlineSellStats.fromJson(data));
        }
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// filter statistics list
  filterStatsList(String type) {
    filterOfflineSellStats = [];
    filterOnlineSellStats = [];
    if (type == "Today") {
      for (OfflineSellStats data in offlineSellStats) {
        // log("==>>> ${data.offlinesaleDate} ${data.offlinesaleDate!.difference(DateTime.now()).inDays == 0}");
        if (data.offlinesaleDate!.difference(DateTime.now()).inDays == 0) {
          filterOfflineSellStats.add(data);
          // log("==>>> offline sell today");
        }
      }
      for (OnlineSellStats data in onlineSellStats) {
        if (data.orderdetailsDate!.difference(DateTime.now()).inDays == 0) {
          filterOnlineSellStats.add(data);
          // log("==>>> online sell today");
        }
      }
    } else if (type == "Weekly") {
      for (OfflineSellStats data in offlineSellStats) {
        if (data.offlinesaleDate!.difference(DateTime.now()).inDays >= -7) {
          if (data.offlinesaleDate!.difference(DateTime.now()).inDays <= 0) {
            filterOfflineSellStats.add(data);
            // log("==>>> offline sell weekly");
          }
        }
      }
      for (OnlineSellStats data in onlineSellStats) {
        if (data.orderdetailsDate!.difference(DateTime.now()).inDays >= -7) {
          if (data.orderdetailsDate!.difference(DateTime.now()).inDays <= 0) {
            filterOnlineSellStats.add(data);
            // log("==>>> online sell weekly");
          }
        }
      }
    } else if (type == "Monthly") {
      for (OfflineSellStats data in offlineSellStats) {
        if (data.offlinesaleDate!.difference(DateTime.now()).inDays >= -30) {
          if (data.offlinesaleDate!.difference(DateTime.now()).inDays <= 0) {
            filterOfflineSellStats.add(data);
            // log("==>>> offline sell Monthly");
          }
        }
      }
      for (OnlineSellStats data in onlineSellStats) {
        if (data.orderdetailsDate!.difference(DateTime.now()).inDays >= -30) {
          if (data.orderdetailsDate!.difference(DateTime.now()).inDays <= 0) {
            filterOnlineSellStats.add(data);
            // log("==>>> online sell Monthly");
          }
        }
      }
    } else {
      for (OfflineSellStats data in offlineSellStats) {
        if (data.offlinesaleDate!.difference(DateTime.now()).inDays >= -365) {
          if (data.offlinesaleDate!.difference(DateTime.now()).inDays <= 0) {
            filterOfflineSellStats.add(data);
            // log("==>>> offline sell yearly");
          }
        }
      }
      for (OnlineSellStats data in onlineSellStats) {
        if (data.orderdetailsDate!.difference(DateTime.now()).inDays >= -365) {
          if (data.orderdetailsDate!.difference(DateTime.now()).inDays <= 0) {
            filterOnlineSellStats.add(data);
            // log("==>>> online sell yearly");
          }
        }
      }
    }
    notifyListeners();
    calculate();
  }

  /// price and qty calculate
  int offlineRevenue = 0;
  double offlineQty = 0;
  int onlineRevenue = 0;
  double onlineQty = 0;

  calculate() {
    offlineRevenue = 0;
    offlineQty = 0;
    onlineRevenue = 0;
    onlineQty = 0;
    for (OfflineSellStats data in filterOfflineSellStats) {
      // log("==>>> value1 ${data.totalAmt}");
      offlineRevenue += (int.parse(data.totalAmt ?? "0") * userPercentage).toInt();
      offlineQty += double.parse(data.totalQty ?? "0");
    }
    for (OnlineSellStats data in filterOnlineSellStats) {
      onlineRevenue += (int.parse(data.totalAmt ?? "0") * userPercentage).toInt();
      onlineQty += double.parse(data.totalQty ?? "0");
    }
    // log("==>>> value ${filterOfflineSellStats.length} ${filterOnlineSellStats.length}");
    notifyListeners();
  }

  /// offline sell state
  List<OfflineSellStats> offlineSellStats = [];
  List<OfflineSellStats> filterOfflineSellStats = [];

  ///
  Future offlineState() async {
    offlineSellStats = [];
    filterOfflineSellStats = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.offlineState(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          offlineSellStats.add(OfflineSellStats.fromJson(data));
          filterOfflineSellStats.add(OfflineSellStats.fromJson(data));
        }
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// get Units
  List<UnitModel> unitList = [];

  ///
  Future getUnits() async {
    unitList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getUnits();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          unitList.add(UnitModel.fromJson(data));
        }
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// get Units
  List<Discount> discountList = [];

  ///
  Future getDiscount() async {
    discountList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getDiscount(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          discountList.add(Discount.fromJson(data));
        }
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// leave module
  List<Leave> leaveList = [];
  List<Leave> filterLeaveList = [];

  ///
  Future getLeave() async {
    leaveList = [];
    filterLeaveList = [];
    changeLoading(true);
    final response = await webService.getLeave(profileDetails!.userID ?? "");

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
      if (data.leavedeliveryTodate == null) {
        if (data.leavedeliveryFromdate!.difference(start).inDays > 0) {
          if (data.leavedeliveryFromdate!.difference(end).inDays <= 0) {
            filterLeaveList.add(data);
          }
        }
      } else {
        log("===>>> from ${data.leavedeliveryFromdate}  to ${data.leavedeliveryTodate} ");
        log("===>>> from to start ${start.difference(data.leavedeliveryFromdate!).inDays}");
        if (start.difference(data.leavedeliveryFromdate!).inDays > 0) {
          log("===>>> leave to start ${start.difference(data.leavedeliveryTodate!).inDays}");
          if (start.difference(data.leavedeliveryTodate!).inDays <= 0) {
            filterLeaveList.add(data);
          }
        }
        log("===>>> from to end ${end.difference(data.leavedeliveryFromdate!).inDays}");
        if (end.difference(data.leavedeliveryFromdate!).inDays > 0) {
          log("===>>> leave to end ${end.difference(data.leavedeliveryTodate!).inDays}");
          if (end.difference(data.leavedeliveryTodate!).inDays <= 0) {
            if (filterLeaveList.isEmpty) {
              filterLeaveList.add(data);
            } else {
              if (filterLeaveList.last.leavedeliveryID != data.leavedeliveryID) {
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
  Future deleteLeave(String leaveID, String status) async {
    changeLoading(true);
    final response = await webService.deleteLeave(leaveID, status);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        await getLeave();
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

  /// shop on off
  Future shopOnOff(String userStatus) async {
    changeLoading(true);
    final response = await webService.shopOnOff(profileDetails!.userID ?? "", userStatus);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        profileDetails!.userStatus = userStatus;
        notifyListeners();
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

  /// request More
  Future requestMore(RequestMore data) async {
    changeLoading(true);
    final response = await webService.requestMore(data);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
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

  /// get request More
  List<GetRequestMore> requestHistory = [];
  List<GetRequestMore> filterRequestHistory = [];

  ///
  Future getRequestMore() async {
    requestHistory = [];
    filterRequestHistory = [];
    changeLoading(true);
    final response = await webService.getRequestMore(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        for (var data in responseDecoded['data']) {
          requestHistory.add(GetRequestMore.fromJson(data));
          filterRequestHistory.add(GetRequestMore.fromJson(data));
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

  /// filter Request More list
  filterRequestMore({required DateTime start, required DateTime end}) {
    filterRequestHistory = [];
    for (GetRequestMore data in requestHistory) {
      if (data.requestqtyDate!.difference(start).inDays > 0) {
        if (data.requestqtyDate!.difference(end).inDays <= 0) {
          filterRequestHistory.add(data);
        }
      }
    }
    notifyListeners();
  }

  /// get review More
  List<Review> getReviewList = [];
  List<Review> filterGetReview = [];

  ///
  Future getReview() async {
    getReviewList = [];
    filterGetReview = [];
    changeLoading(true);
    final response = await webService.getReview(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        for (var data in responseDecoded['data']) {
          getReviewList.add(Review.fromJson(data));
          filterGetReview.add(Review.fromJson(data));
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

  /// filter review list
  filterReviewList(String name) {
    if (name == "All") {
      filterGetReview = getReviewList;
    } else {
      filterGetReview = getReviewList.where((element) => element.productName == name).toList();
    }
    notifyListeners();
  }

  /// update lat long
  Future updateLatLong({required String userLat, required String userLong, required String id}) async {
    await webService.updateLatLong(id: id, userLat: userLat, userLong: userLong);
  }
}
