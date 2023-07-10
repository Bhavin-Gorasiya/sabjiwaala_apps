import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../api/app_preferences.dart';
import '../helper/navigations.dart';
import '../models/enquiry.dart';
import '../models/leave_model.dart';
import '../models/order_model.dart';
import '../models/profile_model.dart';
import '../models/state_city_model.dart';
import '../service/web_service.dart';

class CustomViewModel extends ChangeNotifier {
  int bottomNavIndex = 0;

  ProfileModel? profileDetails;

  List<OrderModel> orderList = [];

  changeList(String status) {
    if (status == "Pending") {
      orderList = pendingOrders;
    } else if (status == "Out for Delivery") {
      orderList = outDeliveryOrders;
    } else if (status == "Completed") {
      orderList = completedOrders;
    } else {
      orderList = cancelledOrders;
    }
    notifyListeners();
  }

  ///change bottom nav index
  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;
    notifyListeners();
  }

  WebService webService = WebService();
  String? camImg;

  bool isLoading = false;
  bool attendance = false;
  String totalProduct = '0';
  String totalAmount = '0';

  changeLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // ProfileModel? profileDetails;

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
          debugPrint('not register');
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
          // profileDetails = ProfileModel.fromJson(responseDecoded['data'][0]);

          AppPreferences.setLoggedin(responseDecoded['data'][0]['deliverypersonID']);

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
          // debugPrint("==>> city list ${cityNameList.length}");
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

  /// get Profile
  Future getProfile() async {
    profileDetails = null;

    var userID = await AppPreferences.getLoggedin();
    notifyListeners();
    debugPrint("==== >>>  user id $userID");

    final response = await webService.getProfile(userID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      // debugPrint("==== >>>  attendance ${responseDecoded['data']}");
      if (responseDecoded['data'] != null && responseDecoded['status'] != "false") {
        profileDetails = ProfileModel.fromJson(responseDecoded['data'][0]);
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
      // debugPrint("==>> update profile ${response.body}");
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
  Future updateFCM() async {
    final response = await webService.updateFcm(
        userID: profileDetails!.userID ?? "",
        token: await FirebaseMessaging.instance.getToken() ?? "",
        platform: Platform.isAndroid ? "Android" : "IOS");

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

  /// get all order
  List<OrderModel> pendingOrders = [];
  List<OrderModel> outDeliveryOrders = [];
  List<OrderModel> completedOrders = [];
  List<OrderModel> cancelledOrders = [];
  List<OrderModel> totalOrderList = [];

  /// order
  Future getOrder() async {
    pendingOrders = [];
    outDeliveryOrders = [];
    completedOrders = [];
    cancelledOrders = [];
    totalOrderList = [];
    filterOrderList = [];
    changeLoading(true);
    final response = await webService.getOrder(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] != "false") {
        if (responseDecoded['today'] != null) {
          OrderModel? order;
          for (var data in responseDecoded['today']) {
            order = OrderModel(
              orderCustomerid: data['orderCustomerid'],
              orderDeliveryboyid: data['orderDeliveryboyid'],
              orderGeneratedid: data['orderGeneratedid'],
              orderId: data['orderID'],
              orderPaymentStatus: data['orderPaymentStatus'],
              orderRazorpayid: data['orderRazorpayid'],
              orderStatus: data['orderStatus'],
              orderSubfrid: data['orderSubfrid'],
              orderSubscriptionType: "",
              orderSubtotal: data['orderSubtotal'],
              orderType: data['orderType'],
              subscriptionorderSDate: data['orderCreateDate'],
              userDetails: UserDetails(
                addressesAddress: data['userAddress'][0]['addressesAddress'],
                addressesLandmark: data['userAddress'][0]['addressesLandmark'],
                addressesLat: data['userAddress'][0]['addressesLat'],
                addressesLong: data['userAddress'][0]['addressesLong'],
                customerFirstname: data['userDetails'][0]['customerFirstname'],
                customerLastname: data['userDetails'][0]['customerLastname'],
                customerId: data['userDetails'][0]['customerId'],
                customerPhoneno: data['userDetails'][0]['customerPhoneno'],
                customerPic: data['userDetails'][0]['customerPic'],
              ),
              products: data["detailsToday"] == null
                  ? []
                  : List<Product>.from(
                      data["detailsToday"]!.map((x) => Product(
                          productsubQty: x['orderdetailsQnty'],
                          productsubName: x['orderdetailsPname'],
                          productsubPrice: x['orderdetailsTotalamt'],
                          productsubUnit: x['orderdetailsUnit'],
                          productsubWeight: x['orderdetailsQnty'])),
                    ),
            );

            if (order.orderStatus == "Pending") {
              pendingOrders.add(order);
            } else if (order.orderStatus == "Out for Delivery") {
              outDeliveryOrders.add(order);
            } else if (order.orderStatus == "Completed") {
              totalOrderList.add(order);
              filterOrderList.add(order);
              completedOrders.add(order);
            } else {
              totalOrderList.add(order);
              filterOrderList.add(order);
              cancelledOrders.add(order);
            }
          }

          log("===>>>>> order list ${pendingOrders.length}");
        }
        if (responseDecoded['previous'] != null) {
          OrderModel? order;
          for (var data in responseDecoded['previous']) {
            order = OrderModel(
              orderCustomerid: data['orderCustomerid'],
              orderDeliveryboyid: data['orderDeliveryboyid'],
              orderGeneratedid: data['orderGeneratedid'],
              orderId: data['orderID'],
              orderPaymentStatus: data['orderPaymentStatus'],
              orderRazorpayid: data['orderRazorpayid'],
              orderStatus: data['orderStatus'],
              orderSubfrid: data['orderSubfrid'],
              orderSubscriptionType: "",
              orderSubtotal: data['orderSubtotal'],
              orderType: data['orderType'],
              subscriptionorderSDate: data['orderCreateDate'],
              userDetails: UserDetails(
                addressesAddress: data['userAddress'][0]['addressesAddress'],
                addressesLandmark: data['userAddress'][0]['addressesLandmark'],
                addressesLat: data['userAddress'][0]['addressesLat'],
                addressesLong: data['userAddress'][0]['addressesLong'],
                customerFirstname: data['userDetails'][0]['customerFirstname'],
                customerLastname: data['userDetails'][0]['customerLastname'],
                customerId: data['userDetails'][0]['customerId'],
                customerPhoneno: data['userDetails'][0]['customerPhoneno'],
                customerPic: data['userDetails'][0]['customerPic'],
              ),
              products: data["detailsPrevious"] == null
                  ? []
                  : List<Product>.from(
                      data["detailsPrevious"]!.map((x) => Product(
                          productsubQty: x['orderdetailsQnty'],
                          productsubName: x['orderdetailsPname'],
                          productsubPrice: x['orderdetailsTotalamt'],
                          productsubUnit: x['orderdetailsUnit'],
                          productsubWeight: x['orderdetailsQnty'])),
                    ),
            );

            if (order.orderStatus == "Pending") {
              pendingOrders.add(order);
            } else if (order.orderStatus == "Out for Delivery") {
              outDeliveryOrders.add(order);
            } else if (order.orderStatus == "Completed") {
              totalOrderList.add(order);
              filterOrderList.add(order);
              completedOrders.add(order);
            } else {
              totalOrderList.add(order);
              filterOrderList.add(order);
              cancelledOrders.add(order);
            }
          }

          log("===>>>>> order list ${pendingOrders.length}");
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

  /// Subscription
  Future getSubs() async {
    changeLoading(true);
    final response = await webService.getSubs(profileDetails!.userID ?? "");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        OrderModel order = OrderModel();
        for (var data in responseDecoded['data']) {
          for (var product in data['productdetails']) {
            if (product['subscriptionorderSDate'] == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
              order = OrderModel(
                orderCustomerid: data['orderCustomerid'],
                orderDeliveryboyid: data['orderDeliveryboyid'],
                orderGeneratedid: data['orderGeneratedid'],
                orderId: product['subscriptionorderID'],
                orderPaymentStatus: data['orderPaymentStatus'],
                orderRazorpayid: data['orderRazorpayid'],
                orderStatus: product['subscriptionorderStatus'],
                orderSubfrid: data['orderSubfrid'],
                orderSubscriptionType: data['orderSubscriptionType'],
                orderSubtotal: data['orderSubtotal'],
                orderType: data['orderType'],
                subscriptionorderSDate: product['subscriptionorderSDate'],
                userDetails: UserDetails(
                  addressesAddress: data['userAddress'][0]['addressesAddress'],
                  addressesLandmark: data['userAddress'][0]['addressesLandmark'],
                  addressesLat: data['userAddress'][0]['addressesLat'],
                  addressesLong: data['userAddress'][0]['addressesLong'],
                  customerFirstname: data['userDetails'][0]['customerFirstname'],
                  customerLastname: data['userDetails'][0]['customerLastname'],
                  customerId: data['userDetails'][0]['customerId'],
                  customerPhoneno: data['userDetails'][0]['customerPhoneno'],
                  customerPic: data['userDetails'][0]['customerPic'],
                ),
                products: product["products"] == null
                    ? []
                    : List<Product>.from(
                        product["products"]!.map((x) => Product(
                            productsubQty: "1",
                            productsubName: x['productsubName'],
                            productsubPrice: x['productsubPrice'],
                            productsubWeight: x['productsubWeight'],
                            productsubUnit: x['productsubUnit'])),
                      ),
              );
              if (order.orderStatus == "Pending") {
                pendingOrders.add(order);
              } else if (order.orderStatus == "Out for Delivery") {
                outDeliveryOrders.add(order);
              } else if (order.orderStatus == "Completed") {
                totalOrderList.add(order);
                filterOrderList.add(order);
                completedOrders.add(order);
              } else {
                totalOrderList.add(order);
                filterOrderList.add(order);
                cancelledOrders.add(order);
              }
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

  /// change status
  Future changeStatus({required String id, required String status, required String type}) async {
    changeLoading(true);
    final response = await webService.changeStatus(id: id, status: status, type: type);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        await getOrder();
        await getSubs();
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

  /// filter history
  List<OrderModel> filterOrderList = [];

  ///
  filter({String? status, String? time, DateTime? start, DateTime? end}) {
    filterOrderList = totalOrderList;
    notifyListeners();
    if (status != null) {
      filterOrderList = filterOrderList.where((element) => element.orderStatus == status).toList();
    }
    if (time != null) {
      if (time == "Today") {
        filterOrderList = filterOrderList
            .where((element) => element.subscriptionorderSDate == DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .toList();
      } else if (time == "Last week") {
        List<OrderModel> dummy = [];
        for (OrderModel data in filterOrderList) {
          DateTime date =
              DateTime.parse(data.subscriptionorderSDate ?? DateFormat("yyyy-MM-dd").format(DateTime.now()));
          if (date.difference(DateTime.now().subtract(const Duration(days: 1))).inDays < 0) {
            if (date.difference(DateTime.now().subtract(const Duration(days: 8))).inDays >= 0) {
              dummy.add(data);
            }
          }
        }
        filterOrderList = dummy;
      } else {
        List<OrderModel> dummy = [];
        for (OrderModel data in filterOrderList) {
          DateTime date =
              DateTime.parse(data.subscriptionorderSDate ?? DateFormat("yyyy-MM-dd").format(DateTime.now()));
          if (date.difference(DateTime.now().subtract(const Duration(days: 1))).inDays < 0) {
            if (date.difference(DateTime.now().subtract(const Duration(days: 31))).inDays >= 0) {
              dummy.add(data);
            }
          }
        }
        filterOrderList = dummy;
      }
    }
    if (start != null && end != null) {
      List<OrderModel> dummy = [];
      for (OrderModel data in filterOrderList) {
        DateTime date = DateTime.parse(data.subscriptionorderSDate ?? DateFormat("yyyy-MM-dd").format(DateTime.now()));
        log("==>>${date.difference(start).inDays}"
            "\n"
            "==>>${date.difference(end).inDays}");
        if (date.difference(start).inDays >= 0) {
          if (date.difference(end).inDays <= 0) {
            dummy.add(data);
          }
        }
      }
      filterOrderList = dummy;
    }
    if (status != null && time != null && start != null && end != null) {
      filterOrderList = totalOrderList;
    }
    notifyListeners();
  }

  /// leave module
  List<Leave> leaveList = [];
  List<Leave> filterLeaveList = [];

  ///
  Future getLeave(String userID) async {
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
