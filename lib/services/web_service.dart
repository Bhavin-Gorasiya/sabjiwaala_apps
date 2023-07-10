import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:subjiwala_farmer/Models/ProductListParser.dart';
import 'package:subjiwala_farmer/Models/edit_profile_model.dart';

import '../Models/ProfileDetailsParser.dart';
import '../utils/app_config.dart';

class WebService {
  /// send OTP
  Future sendOtp({required String mobileNumber}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.sendOtpApi);
      log(AppConfig.apiUrl + AppConfig.sendOtpApi);
      Map data = {"userPhoneno": mobileNumber};
      final response = await http.post(
        url,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === send Otp === $e");
    }
  }

  /// verify Otp
  Future verifyOtp({required String userMobileno, required String otp}) async {
    try {
      Map data = {"userPhoneno": userMobileno, "otp": otp};

      log("=====$data");

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.verifyAPi);

      final response = await http.post(url, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === verify Otp === $e");
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

  /// update Profile
  Future updateProfile(EditProfileModel editProfileModel) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateProfile);

      final response = await http.post(url, body: jsonEncode(editProfileModel.toJson()));
      log(" ==== update Profile ====${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === update Profile === $e");
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

  /// delete Account
  Future deleteAccount(userID) async {
    try {
      Map body = {"userID": userID};

      final response = await http.post(Uri.parse(AppConfig.deleteAccount), body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log("exception$e");
    }
  }

  /// get app version
  Future getAppVersion() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.appVersion));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// add product
  Future addProduct({required AddProductModel data}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.addProducts);

      http.MultipartRequest request = http.MultipartRequest("POST", url);

      request
        ..fields['productFarmerid'] = data.productFarmerid ?? ""
        ..fields['productSubcatid'] = data.productSubcatid ?? ""
        ..fields['productCatid'] = data.productCatid ?? ""
        ..fields['productName'] = data.productName ?? ""
        ..fields['productPrice'] = data.productPrice ?? ""
        ..fields['productDescription'] = data.productDescription ?? ""
        ..fields['productTotalamt'] = data.productTotalamt ?? ""
        ..fields['productQty'] = data.productQty ?? ""
        ..fields['productHarvestFrom'] = data.productHarvestFrom ?? ""
        ..fields['productHarvestTo'] = data.productHarvestTo ?? ""
        ..fields['nutritiondata'] = json.encode(data.nutritiondata!);
      if (data.productPic != null) {
        request.files.add(await http.MultipartFile.fromPath('productPic', data.productPic!));
      }

      log('===>> nutrition ${data.nutritiondata}');
      log('===>> nutrition ${request.fields}');
      var res = await request.send();
      final response = await http.Response.fromStream(res);

      log("==>> add product ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === add product === error $e");
    }
  }

  /// update product
  Future updateProduct({required EditProductModel data}) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.updateProducts);

      http.MultipartRequest request = http.MultipartRequest("POST", url);
      log('==>>> update product === ${data.nutritiondata}');

      request
        ..fields['productID'] = data.productID!
        ..fields['productFarmerid'] = data.productFarmerid!
        ..fields['productCatid'] = data.productCatid!
        ..fields['productSubcatid'] = data.productSubcatid!
        ..fields['productName'] = data.productName!
        ..fields['productPrice'] = data.productPrice!
        ..fields['productDescription'] = data.productDescription!
        ..fields['productTotalamt'] = data.productTotalamt!
        ..fields['productQty'] = data.productQty!
        ..fields['productHarvestFrom'] = data.productHarvestFrom!
        ..fields['productHarvestTo'] = data.productHarvestTo!
        ..fields['nutritiondata'] = json.encode(data.nutritiondata!);
      if (data.productPic != null) {
        request.files.add(await http.MultipartFile.fromPath('productPic', data.productPic!));
      }

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      log('==>>> update product === ${response.statusCode}');
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === update product err === $e");
    }
  }

  /// delete product
  Future deleteProduct(String productID) async {
    try {
      final url = Uri.parse(AppConfig.apiUrl + AppConfig.deleteProducts);
      Map body = {"productID": productID};

      final response = await http.post(url, body: jsonEncode(body));

      log('==>>> delete product === ${response.statusCode}');
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === update product === $e");
    }
  }

  /// get All Products
  Future getAllProducts(userID) async {
    try {
      Map data = {"userID": userID};

      final url = Uri.parse(AppConfig.apiUrl + AppConfig.getAllProducts);

      final response = await http.post(url, body: jsonEncode(data));
      log(" ====getAllProducts ====${response.statusCode}");
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      log(" === getAllProducts === $e");
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

  /// get State
  Future getState() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.apiUrl + AppConfig.getState));

      if (response.statusCode == 200) {
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
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// get enquiry
  Future getEnquiry() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.apiUrl + AppConfig.getEnquiry));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// add Enquiry
  Future addEnquiry({required Enquiry enquiry}) async {
    try {
      Map data = {
        "enquiryName": enquiry.enquiryName,
        "enquiryEmp": enquiry.enquiryEmp,
        "enquiryUid": enquiry.enquiryUid,
        "enquiryUtype": enquiry.enquiryUtype,
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

  /// get Order
  Future getOrder(String userId) async {
    try {
      Map<String, dynamic> data = {"farmerID": userId};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getOrder), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// get Transaction History
  Future getTransactionHistory(String userId) async {
    try {
      Map<String, dynamic> data = {"farmerID": userId};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getTransaction), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// get Transaction List
  Future getTransactionList(String userId) async {
    try {
      Map<String, dynamic> data = {"farmerID": userId};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.transactionList), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception$Exception");
    }
  }

  /// get review
  Future getReview({required String farmerID, required String productID}) async {
    try {
      Map<String, dynamic> data = {"farmerID": farmerID, "productID": productID};

      final response = await http.post(Uri.parse(AppConfig.apiUrl + AppConfig.getReview), body: jsonEncode(data));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } on Exception {
      log("exception getReview $Exception");
    }
  }

  /// training module
  Future getTraining() async {
    try {
      Map data = {"userType": "5"};

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
}
