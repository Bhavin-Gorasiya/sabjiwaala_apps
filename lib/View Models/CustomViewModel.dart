import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:subjiwala/models/cart_model.dart';
import 'package:subjiwala/models/category_model.dart';
import 'package:subjiwala/models/customer_detail_model.dart';
import 'package:subjiwala/models/order_place.dart';
import 'package:subjiwala/models/product_models.dart';
import 'package:subjiwala/models/product_review_model.dart';
import 'package:subjiwala/models/register_model.dart';
import 'package:subjiwala/models/subscription_model.dart';
import 'package:subjiwala/services/web_service.dart';

import '../models/MainCategoryListParser.dart';
import '../models/get_banner_model.dart';
import '../models/review_model.dart';
import '../models/scan_produc_model.dart';
import '../models/state_city_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';

import '../shared_prefe/app_preferences.dart';

class CustomViewModel extends ChangeNotifier {
  WebService webService = WebService();
  String? isLoggedIn = '';
  String uid = '';
  int categoryIndex = 0;
  int bottomNavIndex = 0;

  ///change category index
  void changeCategoryIndex({required int index}) {
    categoryIndex = index;
    notifyListeners();
  }

  ///change bottom nav index
  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;
    notifyListeners();
  }

  /// loading bool
  bool isLoading = false;
  bool isBannerLoad = false;
  bool isTrendingLoad = false;
  bool isPopularLoad = false;
  bool isCategoryLoad = false;
  bool isVendorLoad = false;
  bool isMainCategoryLoad = false;
  bool isSubCategoryLoad = false;
  bool isCartLoad = false;

  /// data lists
  List<CustomerDetailModel> customerDetail = [];
  List<GetBannerModel> bannerList = [];
  List<ProductModel> popularProduct = [];
  List<VendorProfile> vendorList = [];
  List<VendorProfile> searchVendorList = [];
  List<VendorProfile> categoryVendorList = [];

  // List<MainCategoryModel> mainCategory = [];
  // List<SubCategoryModel> subCategory = [];
  List<SubCategoryModel> dummySubCategory = [];
  List<AddressModel> addressList = [];
  List<AddCartResponseModel> cartProductList = [];
  List<ProductReviewModel> productReviewList = [];

/*  /// change sub category list

  void changeSubCategoryList({required id}) {
    dummySubCategory.clear();
    // log(" =====  id ==== $id");
    for (int i = 0; i < subCategory.length; i++) {
      if (subCategory[i].categoryId == id) {
        dummySubCategory.add(subCategory[i]);
        // log(" =====  dummy list ==== $dummySubCategory");
      }
    }
    subCategory.map((e) {
      // log(" =====  categoryId ==== ${e.categoryId}");
      if (e.categoryId == id) {}
      notifyListeners();
    });
  }*/

  /// send otp
  Future sendOtp(mobile) async {
    final response = await webService.sendOtp(mobileNumber: mobile);
    log("==== send otp $response");
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        isLoading = false;
        notifyListeners();
        log(" === ${responseDecoded['data']}");
        return "success";
      } else {
        isLoading = false;
        log("${responseDecoded['data']}");
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      notifyListeners();
      return "error";
    }
  }

  /// verify otp
  Future verifyOtp(userMobileno, otp) async {
    isLoading = true;
    notifyListeners();
    final response = await webService.verifyOtp(userMobileno: userMobileno, otp: otp);
    log("==== verify otp $response");
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
        } else if (responseDecoded['data'] == "OTP not match") {
          isLoading = false;
          notifyListeners();
          return "otp error";
        } else {
          CustomerDetailModel data = CustomerDetailModel.fromJson(responseDecoded['data'][0]);
          customerDetail.add(data);
          uid = data.customerId ?? "";
          isLoading = false;
          AppPreferences.setLoggedin(data.customerId ?? '');
          notifyListeners();
          return "register";
        }
      } else if (responseDecodedStatus == "false") {
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

  /// register User
  Future registerUser({required RegisterRequiredModel model}) async {
    final response = await webService.register(model: model);

    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        CustomerDetailModel data = CustomerDetailModel.fromJson(responseDecoded['data'][0]);
        customerDetail.add(data);
        uid = data.customerId ?? "";
        isLoading = false;
        AppPreferences.setLoggedin(data.customerId ?? '');
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        notifyListeners();
        return "Fail";
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

  /// register User
  Future updateProfile({required RegisterRequiredModel model, String? imagePath}) async {
    EasyLoading.show();
    log('customerDob ${model.customerDob}');
    final response = await webService.updateProfile(
        model: model, customerID: customerDetail.first.customerId!, imagePath: imagePath);
    EasyLoading.dismiss();
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        CustomerDetailModel data = CustomerDetailModel.fromJson(responseDecoded['data'][0]);
        log("======${responseDecoded['data']}");
        customerDetail = [data];
        isLoading = false;
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        notifyListeners();
        return "Fail";
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

  /// get Customer Profile
  Future getCustomerProfile({required String userId}) async {
    customerDetail.clear();
    // EasyLoading.show();
    final response = await webService.getCustomerProfile(userId: userId);
    // log("==>> profile ${response.body}");

    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        CustomerDetailModel data = CustomerDetailModel.fromJson(responseDecoded['data'][0]);
        customerDetail.add(data);
        isLoading = false;
        AppPreferences.setLoggedin(data.customerId ?? '');
        // EasyLoading.dismiss();
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "Fail";
      } else {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      // EasyLoading.dismiss();
      notifyListeners();
      return "error";
    }
  }

  /// update fcm
  Future updateFCM({required String fcm, required double lat, required double long}) async {
    final response = await webService.updateFcm(
      userID: customerDetail.first.customerId ?? "",
      token: fcm,
      platform: Platform.isAndroid ? "Android" : "IOS",
      lat: lat,
      long: long,
    );

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
    isLoading = true;
    var userID = await AppPreferences.getLoggedin();

    final response = await webService.deleteAccount(userID);

    if (response != "error" && response != null) {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var status = responseDecoded['status'];

      if (status == "true") {
        isLoading = false;
        return "success";
      } else {
        isLoading = false;
        return "Could not delete, Try again after sometime";
      }
    } else {
      isLoading = false;
      return "error";
    }
  }

  /// get address
  Future getAddress() async {
    isLoading = true;
    addressList.clear();
    // EasyLoading.show();
    final response = await webService.getAddress(userId: uid);

    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        for (var element in responseDecoded['data']) {
          AddressModel data = AddressModel.fromJson(element);
          addressList.add(data);
        }
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "Fail";
      } else {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      // EasyLoading.dismiss();
      notifyListeners();
      return "error";
    }
  }

  /// delete address
  Future deleteAddress({required String addressesID}) async {
    isLoading = true;
    // EasyLoading.show();
    final response = await webService.deleteAddress(addressesID: addressesID);

    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        isLoading = false;
        getAddress();
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        notifyListeners();
        return "Fail";
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

  /// add address
  Future addAddress({
    required String customerID,
    required String address,
    required String landmark,
    required String addressesLat,
    required String addressesLong,
    required String tag,
  }) async {
    isLoading = true;
    notifyListeners();
    // EasyLoading.show();
    final response = await webService.addAddress(
      address: address,
      addressesLat: addressesLat,
      addressesLong: addressesLong,
      customerID: customerID,
      landmark: landmark,
      tag: tag,
    );

    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        for (var element in responseDecoded['data']) {
          AddressModel data = AddressModel.fromJson(element);
          addressList.add(data);
          isLoading = false;
        }
        // EasyLoading.dismiss();
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "Fail";
      } else {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      // EasyLoading.dismiss();
      notifyListeners();
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
    isLoading = true;
    notifyListeners();
    // EasyLoading.show();
    final response = await webService.updateAddress(
      address: address,
      addressesLat: addressesLat,
      addressesLong: addressesLong,
      addressID: addressID,
      landmark: landmark,
      tag: tag,
    );

    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        getAddress();
        isLoading = false;
        notifyListeners();
        return "Success";
      } else if (responseDecodedStatus == "false") {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "Fail";
      } else {
        isLoading = false;
        // EasyLoading.dismiss();
        notifyListeners();
        return "error";
      }
    } else {
      isLoading = false;
      // EasyLoading.dismiss();
      notifyListeners();
      return "error";
    }
  }

  /// get all banner
  Future getAllBanner() async {
    isBannerLoad = true;
    bannerList.clear();
    final response = await webService.getAllBanner();
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var e in responseDecoded['data']) {
          GetBannerModel data = GetBannerModel.fromJson(e);
          bannerList.add(data);
        }
        isBannerLoad = false;
        notifyListeners();
        log(" == banner list length == ${bannerList.length}");
      } else if (responseDecodedStatus == "false") {
        isBannerLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isBannerLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// get all Product
  Future getProduct(String userId) async {
    isPopularLoad = true;
    popularProduct.clear();
    notifyListeners();
    final response = await webService.getPopularProduct(userId);
    // log("===>> get product ${response.body}");
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var e in responseDecoded['data']) {
          ProductModel data = ProductModel.fromJson(e);
          popularProduct.add(data);
        }
        isPopularLoad = false;
        notifyListeners();
        log(" == popular list length == ${popularProduct.length}");
      } else if (responseDecodedStatus == "false") {
        isPopularLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isPopularLoad = false;
      notifyListeners();
      return "error";
    }
  }

/*  /// get main category
  Future getMainCategory() async {
    isMainCategoryLoad = true;
    mainCategory.clear();
    // notifyListeners();
    final response = await webService.getMainCategory();
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var e in responseDecoded['data']) {
          MainCategoryModel data = MainCategoryModel.fromJson(e);
          mainCategory.add(data);
        }
        isMainCategoryLoad = false;
        notifyListeners();
        log(" == main category list length == ${mainCategory.length}");
      } else if (responseDecodedStatus == "false") {
        isMainCategoryLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isMainCategoryLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// get sub category
  Future getSubCategory() async {
    isSubCategoryLoad = true;
    subCategory.clear();
    // notifyListeners();
    final response = await webService.getSubCategory();
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var e in responseDecoded['data']) {
          SubCategoryModel data = SubCategoryModel.fromJson(e);
          subCategory.add(data);
        }
        isSubCategoryLoad = false;
        notifyListeners();
        log(" == main category list length == ${subCategory.length}");
      } else if (responseDecodedStatus == "false") {
        isSubCategoryLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isMainCategoryLoad = false;
      notifyListeners();
      return "error";
    }
  }*/

  /// add to cart
  Future addToCart({
    required String customerID,
    required String vendorID,
    required String productID,
    required String qty,
  }) async {
    isCartLoad = true;
    notifyListeners();

    final response =
        await webService.addToCart(customerID: customerID, vendorID: vendorID, productID: productID, qty: qty);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      log(" === add to cart status $responseDecodedStatus ${cartProductList.length}");
      if (responseDecodedStatus == "true") {
        popularProduct.where((element) => element.userproductId == productID).first.isCart = true;
        for (AddCartResponseModel data in cartProductList) {
          if (data.cartVid != vendorID) {
            updateCart(cartID: data.cartId ?? "", qty: "0");
          }
        }
        cartProductList.clear();
        await getAllCart();
        isCartLoad = false;
        notifyListeners();
      } else if (responseDecodedStatus == "false") {
        isCartLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isCartLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// update or delete cart
  Future updateCart({
    required String cartID,
    required String qty,
  }) async {
    isCartLoad = true;
    notifyListeners();

    ///
    final response = await webService.updateCart(cartID: cartID, qty: qty);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        if (qty != "0") {
          cartProductList.where((element) => element.cartId == cartID).first.cartQty = qty;
        } else {
          AddCartResponseModel data = cartProductList.where((element) => element.cartId == cartID).first;
          Iterable<ProductModel> product =
              popularProduct.where((element) => element.userproductId == data.userproductID);
          if (product.isNotEmpty) product.first.isCart = false;
          cartProductList.remove(data);
        }
        isCartLoad = false;
        notifyListeners();
      } else if (responseDecodedStatus == "false") {
        isCartLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isCartLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// get all cart
  Future getAllCart() async {
    cartProductList.clear();
    isLoading = true;

    ///
    final response = await webService.getAllCart(customerID: uid);
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      // log("  cart data ${responseDecoded['data']}");
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var e in responseDecoded['data']) {
          AddCartResponseModel data = AddCartResponseModel.fromJson(e);
          // ProductModel productModel = await getProductById(productId: data.cartPid, vendorId: data.cartVid);
          cartProductList.add(data);
        }
        // log(" == cart Product List length == ${cartProductList.length}");
        isLoading = false;
        notifyListeners();
      } else if (responseDecodedStatus == "false") {
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

  /// delete all cart
  Future deleteAllCart({required String customerID}) async {
    isOrder = true;

    final response = await webService.deleteAllCart(customerID: customerID);
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        cartProductList.clear();
        isOrder = false;
        notifyListeners();
      } else if (responseDecodedStatus == "false") {
        isOrder = false;
        notifyListeners();
        return "error";
      }
    } else {
      isOrder = false;
      notifyListeners();
      return "error";
    }
  }

  /// get Product By Id
  Future getProductById({required String productId, required String vendorId}) async {
    isCartLoad = true;

    ///
    final response = await webService.getProductById(productId: productId, vendorId: vendorId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        ProductModel productModel = ProductModel.fromJson(responseDecoded['data'][0]);
        isCartLoad = false;
        notifyListeners();
        return productModel;
      } else if (responseDecodedStatus == "false") {
        isCartLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isCartLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// get Product review
  Future getProductReview({required String productId, required String vendorId}) async {
    productReviewList.clear();
    isCartLoad = true;

    ///
    final response = await webService.getProductReview(productId: productId, vendorId: vendorId);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        if (responseDecoded['data'] != null) {
          for (var e in responseDecoded['data']) {
            ProductReviewModel productModel = ProductReviewModel.fromJson(e);
            productReviewList.add(productModel);
          }
          isCartLoad = false;
          notifyListeners();
          log("==== review list length  ${productReviewList.length}");
          return "true";
        } else {
          isCartLoad = false;
          notifyListeners();
          return "false";
        }
      } else if (responseDecodedStatus == "false") {
        isCartLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isCartLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// get all Product
  Future getAllProduct() async {
    // if (bannerList.isEmpty) {
    await getAllBanner();
    // }
    // if (vendorList.isEmpty) {
    await getVendor();
    // }
    // if (subCategoryList.isEmpty) {
    await getAllMainCategory();
    // }
    if (customerDetail.isNotEmpty) {
      await getAllCart();
    }
  }

  /// get Data From QR
  Farmer farmerDetail = Farmer();
  ProductDetail productDetail = ProductDetail();

  ///
  Future getDataFromQR({required String farmerID, required String productID}) async {
    isLoading = true;
    final response = await webService.getDataFromQR(farmerID: farmerID, productID: productID);
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        ScanProduct data = ScanProduct.fromJson(responseDecoded);
        // log("data == $responseDecoded}");
        farmerDetail = data.farmerdetails != null ? data.farmerdetails!.first : Farmer();
        productDetail = data.productdetail != null ? data.productdetail!.first : ProductDetail();
        log("===>>> scan product ${responseDecoded['productdetail']}");
        isLoading = false;
        notifyListeners();
        // log(" == main category list length == ${subCategory.length}");
      } else if (responseDecodedStatus == "false") {
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

  /// order place
  bool isOrder = false;

  Future orderPlace(OrderPlace orderPlace) async {
    isOrder = true;
    notifyListeners();
    final response = await webService.orderPlace(orderPlace);
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        isOrder = false;
        notifyListeners();
        return "success";
      } else {
        isOrder = false;
        notifyListeners();
        return "error";
      }
    } else {
      isOrder = false;
      notifyListeners();
      return 'error';
    }
  }

  /// get All Order
  List<MyOrder> orderList = [];
  List<MyOrder> filterOrderList = [];

  /// get All Order
  Future getAllOrder(String userID) async {
    orderList = [];
    filterOrderList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getAllOrder(userID);
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          MyOrder order = MyOrder.fromJson(data);
          orderList.add(order);
          filterOrderList.add(order);
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

  /// filter order
  filterOrder(String status) {
    filterOrderList = [];
    notifyListeners();
    for (MyOrder data in orderList) {
      // if (data.orderStatus == "Out for Delivery") {
      //   filterOrderList.add(data);
      // }
      if (data.orderStatus!.toLowerCase() == status) {
        filterOrderList.add(data);
      } else if (status == "pending" && data.orderStatus == "Out for Delivery") {
        filterOrderList.add(data);
      }
    }
    notifyListeners();
  }

  /// delete order
  Future deleteOrder(String id) async {
    isLoading = true;
    final response = await webService.deleteOrder(id);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      log("===>>> get category $responseDecodedStatus");
      if (responseDecodedStatus == "true") {
        await getAllOrder(customerDetail.first.customerId ?? "1");
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

  /// get all vendor
  Future getVendor() async {
    isTrendingLoad = true;
    vendorList.clear();
    // notifyListeners();
    final response = await webService.getVendor();
    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var e in responseDecoded['data']) {
          VendorProfile data = VendorProfile.fromJson(e);
          vendorList.add(data);
          searchVendorList.add(data);
        }
        isTrendingLoad = false;
        notifyListeners();
        log(" == vendor list length == ${vendorList.length}");
      } else if (responseDecodedStatus == "false") {
        isTrendingLoad = false;
        notifyListeners();
        return "error";
      }
    } else {
      isTrendingLoad = false;
      notifyListeners();
      return "error";
    }
  }

  /// filter vendor
  String? subCategoryId;

  changeSubCatId(String id) {
    log("===>>> change sub cat id $id");
    subCategoryId = id;
    notifyListeners();
  }

  ///
  filterVendor({required String catId, required String subCatId}) {
    log("===>>> filter vendor cat Id $catId sub cat is $subCatId");
    categoryVendorList = [];
    notifyListeners();
    for (VendorProfile filterProduct in vendorList) {
      for (Categories category in filterProduct.category ?? []) {
        if (category.catid.toString() == catId) {
          // log("1st ==== condition==${category.catid.toString()} == $catId");
          if (category.subcatid.toString() == subCatId) {
            // log("2nd ==== condition==${category.subcatid.toString()} == $subCatId");
            categoryVendorList.add(filterProduct);
          }
        }
      }
    }
    log("==== categoryVendorList length ${categoryVendorList.length}");
    notifyListeners();
  }

  /// search vendor
  searchVendor(String name) {
    if (name == '' || name.isEmpty) {
      searchVendorList = vendorList;
      notifyListeners();
    } else {
      searchVendorList = [];
      for (var i in vendorList.sublist(1)) {
        if ((i.userFname ?? "").toLowerCase().contains(name.toLowerCase()) ||
            (i.userLname ?? "").toLowerCase().contains(name.toLowerCase())) {
          searchVendorList.add(i);
          debugPrint(name);
        }
      }
      notifyListeners();
    }
  }

  /// get all category
  // List<CategoryModel> categoryList = [];
  List<Subcategory> subCategoryList = [];

  Future getAllMainCategory() async {
    // categoryVendorList = [];
    subCategoryList = [];

    final response = await webService.getAllMainCategory();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      log("===>>> get category $responseDecodedStatus");
      if (responseDecodedStatus == "false") {
        notifyListeners();
        return "error";
      } else if (responseDecodedStatus == "true") {
        GetCategory category = GetCategory.fromJson(responseDecoded);
        subCategoryList.addAll(category.subcategory ?? []);
        filterVendor(
            subCatId: subCategoryList.first.subcategoryId ?? "", catId: subCategoryList.first.categoryId ?? "");
        log("====>>> 1filter done ");
        if (subCategoryList.isNotEmpty) {
          changeSubCatId(subCategoryList.first.subcategoryId ?? "1");
        }

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

  String address = "Loading...";

  Future<bool> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        address = "Please give location permission";
        return false;
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      address = "Please turn on location";
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied, we cannot request permissions.');
      address = "Please give location permission";
      return false;
    }
    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    address = "${placemarks.first.name}, "
        "${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, "
        "${placemarks.first.country}, ${placemarks.first.postalCode}.";

    await updateFCM(
        fcm: await FirebaseMessaging.instance.getToken() ?? "", lat: position.latitude, long: position.longitude);

    notifyListeners();

    return true;
  }

  /// order place
  bool isSubscription = false;

  Future placeSubscription(AddSubscriptionModel subscriptionModel) async {
    isSubscription = true;
    notifyListeners();

    // log("==>>> subs model ${subscriptionModel.toJson()}");

    final response = await webService.placeSubscription(subscriptionModel);
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        isSubscription = false;
        notifyListeners();
        return "success";
      } else {
        isSubscription = false;
        notifyListeners();
        return "error";
      }
    } else {
      isSubscription = false;
      notifyListeners();
      return 'error';
    }
  }

  /// get All Subscription order
  List<Subscription> subsOrderList = [];

  Future getAllSubscriptionOrder() async {
    subsOrderList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getAllSubscriptionOrder(customerDetail.first.customerId ?? "1");
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

  /// getAllSubscription
  List<VendorSubscription> vendorSubsList = [];

  ///
  Future getVendorSubscription(String vendorID) async {
    vendorSubsList = [];
    isLoading = true;
    notifyListeners();
    final response = await webService.getVendorSubscription(vendorID);
    if (response != 'error') {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];
      if (responseDecodedStatus == "true") {
        for (var data in responseDecoded['data']) {
          VendorSubscription order = VendorSubscription.fromJson(data);
          vendorSubsList.add(order);
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
  Future deleteSubscription(String id) async {
    isLoading = true;
    final response = await webService.deleteSubscription(id);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      // log("===>>> get category $responseDecodedStatus");
      if (responseDecodedStatus == "true") {
        await getAllSubscriptionOrder();
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

  /// delete Subscription by day
  Future deleteSubscriptionByDay({required String subscriptionID, required int index, required int mainIndex}) async {
    isLoading = true;
    final response = await webService.deleteSubscriptionByDay(subscriptionID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      log("===>>> get category $responseDecoded $subscriptionID");
      if (responseDecodedStatus == "true") {
        subsOrderList[mainIndex].productDetails!.removeAt(index);
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

  /// add review
  Future addReview(ReviewModel data) async {
    isLoading = true;
    final response = await webService.addReview(data);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
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

  /// get vendor location
  Future getLocation(String id, int index) async {
    isLoading = true;
    final response = await webService.getLocation(id);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "true") {
        isLoading = false;
        if (responseDecoded['data'].isNotEmpty) {
          Map<String, dynamic> data = responseDecoded['data'][0];
          vendorList[index].userLong = data['userLong'];
          vendorList[index].userLat = data['userLat'];
        }
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
}
