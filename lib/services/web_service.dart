import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:subjiwala/models/order_place.dart';
import 'package:subjiwala/models/register_model.dart';
import 'package:subjiwala/models/subscription_model.dart';
import 'package:subjiwala/utils/app_config.dart';

import '../models/review_model.dart';

class WebService {
  /// send OTP
  Future sendOtp({required String mobileNumber}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.sendOtpApi);

      Map data = {"customerPhoneno": mobileNumber};
      log("==== send otp web service  $data");
      log("==== send otp web service url  $url");
      final response = await http.post(
        url,
        body: jsonEncode(data),
      );
      log("==== send otp web service  $response");
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
      Map data = {"customerPhoneno": userMobileno, "otp": otp};

      log("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.verifyAPi);

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

  /// register api
  Future register({required RegisterRequiredModel model}) async {
    try {
      Map data = {
        "customerPhoneno": model.customerPhoneno,
        "customerFirstname": model.customerFirstname,
        "customerLastname": model.customerLastname,
        "customerEmail": model.customerEmail,
        "customerLat": model.customerLat,
        "customerLong": model.customerLong,
        "customerAddress": model.customerAddress,
        "customerState": model.customerState,
        "customerCity": model.customerCity,
        "customerBoi": model.customerBoi,
        "Platform_os": model.platformOs,
        "customerWallet_amount": model.customerWalletAmount,
        "customerFcmtoken": model.customerFcmtoken,
        "customerReferCode": model.customerReferCode,
        "customerReferByCode": model.customerReferByCode,
        "customerDob": model.customerDob,
        "customerGender": model.customerGender
      };

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.registerApi);

      final response = await http.post(url, body: jsonEncode(data));

      log("==>> register == $data ====>>>>\n===>>>> ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === register === $e');
      return "error";
    }
  }

  /// update profile
  Future updateProfile({required RegisterRequiredModel model, required var customerID, String? imagePath}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateCustomerProfile);
      MultipartRequest request = http.MultipartRequest('POST', url);

      if (imagePath != null) {
        request
          ..fields['customerID'] = customerID
          ..fields['customerPhoneno'] = model.customerPhoneno ?? ''
          ..fields['customerFirstname'] = model.customerFirstname ?? ''
          ..fields['customerGender'] = model.customerGender ?? ''
          ..fields['customerLastname'] = model.customerLastname ?? ''
          ..fields['customerDob'] = model.customerDob ?? ''
          ..fields['customerPic'] = model.customerPic ?? ''
          ..fields['customerEmail'] = model.customerEmail ?? ''
          ..fields['customerLat'] = model.customerLat ?? ''
          ..fields['customerLong'] = model.customerLong ?? ''
          ..fields['customerAddress'] = model.customerAddress ?? ''
          ..fields['customerState'] = 'Surat'
          ..fields['customerReferByCode'] = model.customerReferByCode ?? ''
          ..fields['Platform_os'] = model.platformOs ?? ''
          ..fields['customerFcmtoken'] = model.customerFcmtoken ?? ''
          ..fields['customerBoi'] = model.customerBoi ?? ''
          ..files.add(await http.MultipartFile.fromPath('file', imagePath));
      } else {
        log("===>> here ${model.customerPic}");
        request
          ..fields['customerID'] = customerID
          ..fields['customerPhoneno'] = model.customerPhoneno ?? ''
          ..fields['customerFirstname'] = model.customerFirstname ?? ''
          ..fields['customerGender'] = model.customerGender ?? ''
          ..fields['customerLastname'] = model.customerLastname ?? ''
          ..fields['customerDob'] = model.customerDob ?? ''
          ..fields['customerPic'] = model.customerPic ?? ''
          ..fields['customerEmail'] = model.customerEmail ?? ''
          ..fields['customerLat'] = model.customerLat ?? ''
          ..fields['customerLong'] = model.customerLong ?? ''
          ..fields['customerAddress'] = model.customerAddress ?? ''
          ..fields['customerState'] = 'surat'
          ..fields['customerReferByCode'] = model.customerReferByCode ?? ''
          ..fields['Platform_os'] = model.platformOs ?? ''
          ..fields['customerFcmtoken'] = model.customerFcmtoken ?? ''
          ..fields['customerBoi'] = model.customerBoi ?? '';
      }

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      // log('++++=== ${response.body}');
      if (response.statusCode == 200) {
        // log('=== updateProfile == ${response.body}');
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === register === $e');
      return "error";
    }
  }

  /// get customer profile
  Future getCustomerProfile({required String userId}) async {
    try {
      Map data = {"customerID": userId};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getCustomerProfile);

      final response = await http.post(url, body: jsonEncode(data));
      log("==>> profile ${response.statusCode}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(' === register === $e');
      return "error";
    }
  }

  /// update fcm
  Future updateFcm(
      {required String userID,
      required String token,
      required String platform,
      required double lat,
      required double long}) async {
    try {
      Map data = {
        "customerID": userID,
        "Platform_os": platform,
        "customerFcmtoken": token,
        "customerLat": lat,
        "customerLong": long,
      };

      log("===== update fcm $data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateFcm);

      final response = await http.post(url, body: jsonEncode(data));
      log(" ====update fcm ====${response.statusCode}===>>>${response.body}");
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

  /// delete Account
  Future deleteAccount(userID) async {
    try {
      Map body = {"customerID": userID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.deleteAcc), body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("exception$e");
    }
  }

  /// get banner api
  Future getAllBanner() async {
    log("==>> get product inini");

    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllBanner);

      final response = await http.post(url);
      // log("==>> get product ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all banner error <== $e");
      return "error";
    }
  }

  /// get popular product
  Future getPopularProduct(String userId) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getProduct);

      Map<String, dynamic> data = {"userID": userId};

      final response = await http.post(url, body: json.encode(data));

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all banner error <== $e");
      return "error";
    }
  }

  /// get popular product
  Future getVendor() async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllVendor);

      final response = await http.post(url);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all banner error <== $e");
      return "error";
    }
  }

  /// get Main Category
  Future getMainCategory() async {
    try {
      final url = Uri.parse("https://sabjiwaala.radarsofttech.in/farmerapi/${AppConfig.getMainCategory}");

      final response = await http.post(url);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all banner error <== $e");
      return "error";
    }
  }

  /// get Sub Category
  Future getSubCategory() async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getSubCategory);

      final response = await http.post(url);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all banner error <== $e");
      return "error";
    }
  }

  /// get user address
  Future getAddress({required String userId}) async {
    try {
      log("=== userId ===$userId");
      Map data = {"customerID": userId};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAddress);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200 || response.statusCode == 400) {
        // log("=== get address ${response.body}");
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all banner error <== $e");
      return "error";
    }
  }

  /// get delete address
  Future deleteAddress({required String addressesID}) async {
    try {
      log("=== addressesID ===$addressesID");
      Map data = {"addressesID": addressesID};
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.deleteAddress);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200 || response.statusCode == 400) {
        log("=== delete address ${response.body}");
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> delete all address error <== $e");
      return "error";
    }
  }

  /// get add address
  Future addAddress({
    required String customerID,
    required String address,
    required String landmark,
    required String addressesLat,
    required String addressesLong,
    required String tag,
  }) async {
    try {
      Map data = {
        "customerID": customerID,
        "address": address,
        "landmark": landmark,
        "addressesLat": addressesLat,
        "addressesLong": addressesLong,
        "tag": tag
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addAddress);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200 || response.statusCode == 400) {
        log("=== add address ${response.body}");
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> add all address error <== $e");
      return "error";
    }
  }

  /// update address
  Future updateAddress({
    required String addressID,
    required String address,
    required String landmark,
    required String addressesLat,
    required String addressesLong,
    required String tag,
  }) async {
    try {
      Map data = {
        "addressesID": addressID,
        "address": address,
        "landmark": landmark,
        "addressesLat": addressesLat,
        "addressesLong": addressesLong,
        "tag": tag
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateAddress);

      final response = await http.post(url, body: jsonEncode(data));

      if (response.statusCode == 200 || response.statusCode == 400) {
        log("=== update address ${response.body}");
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> update all address error <== $e");
      return "error";
    }
  }

  /// add to cart
  Future addToCart({
    required String customerID,
    required String vendorID,
    required String productID,
    required String qty,
  }) async {
    try {
      Map data = {
        "customerID": customerID,
        "vendorID": vendorID,
        "productID": productID,
        "QTY": qty,
      };
      log(" === data $data");
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addToCart);

      final response = await http.post(url, body: jsonEncode(data));

      log("=== add to cart ${response.statusCode}");
      log("=== add to cart ${response.body}");
      if (response.statusCode == 200 || jsonDecode(response.body)['status'] == "true") {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> add to cart error <== $e");
      return "error";
    }
  }

  /// update or delete cart
  Future updateCart({
    required String cartID,
    required String qty,
  }) async {
    try {
      Map data = {
        "cartID": cartID,
        "QTY": qty,
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateCart);

      final response = await http.post(url, body: jsonEncode(data));

      log("=== add to cart ${response.body}");
      if (response.statusCode == 200 || jsonDecode(response.body)['status'] == "true") {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> add to cart error <== $e");
      return "error";
    }
  }

  /// get all cart
  Future getAllCart({required String customerID}) async {
    try {
      Map data = {
        "customerID": customerID,
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllCart);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all cart error <== $e");
      return "error";
    }
  }

  /// delete all cart
  Future deleteAllCart({required String customerID}) async {
    try {
      Map data = {
        "userID": customerID,
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.deleteAllCart);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get all cart error <== $e");
      return "error";
    }
  }

  /// get Product By Id
  Future getProductById({required String productId, required String vendorId}) async {
    try {
      Map data = {
        "PID": productId,
        "VID": vendorId,
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getProductById);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get Product By Id error <== $e");
      return "error";
    }
  }

  /// get Product review
  Future getProductReview({required String productId, required String vendorId}) async {
    try {
      Map data = {
        "PID": productId,
        "VID": vendorId,
      };
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.productReview);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get Product review error <== $e");
      return "error";
    }
  }

  /// get Data From QR
  Future getDataFromQR({required String farmerID, required String productID}) async {
    try {
      Map data = {
        "farmerID": farmerID,
        "productID": productID,
      };
      final url = Uri.parse("${AppConfig.apiUrl}qrcodescan.php");

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("  ==> get Product review error <== $e");
      return "error";
    }
  }

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

  /// order place
  Future orderPlace(OrderPlace orderPlace) async {
    try {
      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.orderPlace), body: jsonEncode(orderPlace.toJson()));

      if (response.statusCode == 200) {
        log("===>>> orderPlace ${orderPlace.toJson()} \n ${response.body}");
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception ==>> $Exception");
    }
  }

  /// get All Order
  Future getAllOrder(String userID) async {
    try {
      Map<String, dynamic> data = {"userID": userID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getAllOrder), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception ==>> $Exception");
    }
  }

  /// delete Order
  Future deleteOrder(String orderID) async {
    try {
      Map<String, dynamic> data = {"orderID": orderID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.deleteOrder), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception ==>> $Exception");
    }
  }

  /// get All Main Category
  Future getAllMainCategory() async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllMainCategory);

      final response = await http.post(url);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === getAllProducts === $e");
    }
  }

  /// Subscription place
  Future placeSubscription(AddSubscriptionModel subscriptionModel) async {
    try {
      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.placeSubscription),
          body: jsonEncode(subscriptionModel.toJson()));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception Subscription place ==>> $Exception");
    }
  }

  /// get All Subscription order
  Future getAllSubscriptionOrder(String userID) async {
    try {
      Map<String, dynamic> data = {"userID": userID};

      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getSubscriptionOrder), body: jsonEncode(data));

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

  /// getVendorSubscription
  Future getVendorSubscription(String userID) async {
    try {
      Map<String, dynamic> data = {"subFID": userID};

      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getVendorSubscription), body: jsonEncode(data));

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
  Future deleteSubscription(String orderID) async {
    try {
      Map<String, dynamic> data = {"orderID": orderID};

      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.deleteSubscription), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception delete Subscription ==>> $Exception");
    }
  }

  /// delete Subscription by day
  Future deleteSubscriptionByDay(String subscriptionID) async {
    try {
      Map<String, dynamic> data = {"subscriptionID": subscriptionID};

      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.deleteSubscriptionByDay), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception delete Subscription by day ==>> $Exception");
    }
  }

  /// add review
  Future addReview(ReviewModel data) async {
    try {
      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.addReview), body: jsonEncode(data.toJson()));

      log("add review==>> ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("add review ==>> $Exception");
      return "error";
    }
  }

  /// get vendor location
  Future getLocation(String id) async {
    try {
      Map<String, dynamic> data = {"subfID": id};

      final response =
          await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getVendorLocation), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("add review ==>> $Exception");
      return "error";
    }
  }
}
