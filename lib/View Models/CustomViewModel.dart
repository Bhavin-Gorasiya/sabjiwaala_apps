import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/Models/app_detail_model.dart';
import 'package:subjiwala_farmer/Models/edit_profile_model.dart';
import 'package:subjiwala_farmer/Models/order_model.dart';
import 'package:subjiwala_farmer/Models/state_city_model.dart';
import 'package:subjiwala_farmer/Models/transaction_model.dart';
import '../Models/MainCategoryListParser.dart';
import '../Models/ProductListParser.dart';
import '../Models/ProfileDetailsParser.dart';
import '../Models/training_model.dart';
import '../api/app_preferences.dart';
import '../services/web_service.dart';

class CustomViewModel extends ChangeNotifier {
  WebService webService = WebService();

  String language = 'en';

  changeLanguage(String lan) {
    language = lan;
    notifyListeners();
  }

  bool isLoading = false;
  String totalProduct = '0';
  String totalAmount = '0';

  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  ProfileDetailsParser? profileDetails;
  AppDetailModel? appDetailModel;

  List<ProductListParser> productList = [];
  List<ProductListParser> filterProductList = [];
  List<OrderModel> orderList = [];
  List<Subcategory> filterSubCategoryList = [];

  TransactionModel transactionModel = TransactionModel();
  List<TransactionList> transactionList = [];
  List<TransactionList> filtertransactionList = [];

  /// change category index
  int categoryIndex = 0;

  void changeIndex(int index) {
    categoryIndex = index;
    notifyListeners();
  }

  /// change categoryTab index
  String categoryTab = "In Stock";

  void changeCategoryTab(String tab) {
    categoryTab = tab;
    notifyListeners();
  }

  /// get App Version
  Future getAppVersion() async {
    appDetailModel = null;
    final response = await webService.getAppVersion();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      appDetailModel = AppDetailModel.fromJson(responseDecoded);

      notifyListeners();
      return "success";
    } else {
      notifyListeners();
      return "error";
    }
  }

  AppDetailModel? get getappVersionParser => appDetailModel;

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
          cityNameList.add(cityModel.locationCity ?? "City");
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
  Future sendOtp(mobile, bool otp) async {
    if (!otp) isLoading = true;
    notifyListeners();

    final response = await webService.sendOtp(mobileNumber: mobile);
    log("==>>. send otp ${response.body}");

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
          profileDetails = ProfileDetailsParser.fromJson(responseDecoded['data'][0]);

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
  bool isContractFull = false;

  ///
  Future getProfile() async {
    profileDetails = null;

    var userID = await AppPreferences.getLoggedin();

    final response = await webService.getProfile(userID);
    // log("==== >>> getProfile ${response.body}");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] != "false") {
        profileDetails = ProfileDetailsParser.fromJson(responseDecoded['data'][0]);
        isContractFull = profileDetails!.userContracttype == "1";
        // totalProduct = responseDecoded['allproduct'];
        totalAmount = responseDecoded['TotalAmt'];
        stateID = profileDetails!.userStateid!;
        cityID = profileDetails!.userCityid!;
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

  /// delete account
  Future deleteAccount() async {
    var userID = await AppPreferences.getLoggedin();

    final response = await webService.deleteAccount(userID);

    if (response != "error" && response != null) {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var status = responseDecoded['status'];

      if (status == "true") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "Could not delete, Try again after sometime";
      }
    } else {
      notifyListeners();
      return "error";
    }
  }

  /// update Profile
  Future updateProfile(EditProfileModel model) async {
    changeLoading();
    final response = await webService.updateProfile(model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseDecoded['data'] != null) {
        await getProfile();
        changeLoading();
        notifyListeners();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// update Profile Pic
  Future updateProfilePic(String imgPath, String userID) async {
    final response = await webService.updateProfilePic(imgPath, userID);

    if (response != "error") {
      log("==>> update profile ${response.body}");
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

  /// add product
  Future addProduct({required AddProductModel model}) async {
    changeLoading();
    final response = await webService.addProduct(data: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);

      if (responseDecoded['data'] != null) {
        ProductListParser product = ProductListParser.fromJson(responseDecoded['data'][0]);
        debugPrint("==>>> add product id ${product.productId} == farm id ${product.productFarmerid}");
        productList.add(product);
        changeLoading();
        notifyListeners();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// update product
  Future updateProduct({required EditProductModel model}) async {
    changeLoading();
    final response = await webService.updateProduct(data: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        await getAllProducts();
        changeLoading();
        notifyListeners();
        return "success";
      } else {
        changeLoading();
        notifyListeners();
        return "error";
      }
    } else {
      changeLoading();
      notifyListeners();
      return "error";
    }
  }

  /// delete Product
  Future deleteProduct(String productID) async {
    changeLoading();
    final response = await webService.deleteProduct(productID);

    if (response != "error" && response != null) {
      var responseDecoded = jsonDecode(response.body);
      var status = responseDecoded['status'];

      if (status == "true") {
        await getAllProducts();
        filterProduct(catId: categoryId ?? "0", subCatId: subCategoryId ?? "0");
        changeLoading();
        notifyListeners();
        return "success";
      } else {
        changeLoading();
        notifyListeners();
        return "Could not delete, Try again after sometime";
      }
    } else {
      changeLoading();
      notifyListeners();
      return "error";
    }
  }

  /// get all product
  Future getAllProducts() async {
    productList.clear();
    var userID = await AppPreferences.getLoggedin();

    final response = await webService.getAllProducts(userID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "false") {
        notifyListeners();
        return "error";
      } else if (responseDecodedStatus == "true") {
        final data = responseDecoded['data'];

        if (data != null) {
          for (var i in data) {
            productList.add(ProductListParser.fromJson(i));
          }
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

  /// filter product
  clearSubCategory() {
    filterSubCategoryList.clear();
  }

  String? categoryId;
  String? subCategoryId;

  changeCatId(String id) {
    log("===>>> change cat id $id");
    categoryId = id;
    notifyListeners();
  }

  changeSubCatId(String id) {
    log("===>>> change sub cat id $id");
    subCategoryId = id;
    notifyListeners();
  }

  ///
  filterProduct({required String catId, required String subCatId}) {
    log("===>>> cat Id $catId sub cat is $subCatId");
    filterProductList = [];
    notifyListeners();
    for (ProductListParser filterProduct in productList) {
      if (filterProduct.productCatid.toString() == catId) {
        if (filterProduct.productSubcatid.toString() == subCatId) {
          filterProductList.add(filterProduct);
          // log("==== filterProductList length ${filterProduct.productCatid} == $catId ${filterProductList.length}");
        }
      }
    }
    notifyListeners();
  }

  Future filterSubCatList(String catId) async {
    filterSubCategoryList = [];
    notifyListeners();
    for (Subcategory data in subCategoryList) {
      if (data.categoryId == catId) {
        filterSubCategoryList.add(data);
      }
    }
    log("===>>> sub cat list ${filterSubCategoryList.length} $catId");
  }

  /// get all category
  List<CategoryModel> categoryList = [];
  List<Subcategory> subCategoryList = [];

  Future getAllMainCategory() async {
    categoryList = [];
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
        // final data = responseDecoded['data'];

        GetCategory category = GetCategory.fromJson(responseDecoded);
        categoryList.addAll(category.category ?? []);
        // debugPrinrt
        if (categoryList.isNotEmpty) changeCatId(categoryList.first.categoryId ?? "1");
        subCategoryList.addAll(category.subcategory ?? []);
        if (subCategoryList.isNotEmpty) {
          changeSubCatId(
              subCategoryList.where((element) => element.categoryId == categoryId).first.subcategoryId ?? "1");
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

  /// get Order
  Future getOrder() async {
    orderList = [];
    changeLoading();
    final response = await webService.getOrder(profileDetails!.userID ?? "0");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      var responseDecodedStatus = responseDecoded['status'];

      if (responseDecodedStatus == "false") {
        changeLoading();
        return "error";
      } else if (responseDecodedStatus == "true") {
        final data = responseDecoded['data'];

        if (data != null) {
          for (var i in data) {
            orderList.add(OrderModel.fromJson(i));
          }
          totalProduct = orderList.length.toString();
        }
        changeLoading();

        notifyListeners();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// add enquiry
  Future addEnquiry({required Enquiry model}) async {
    changeLoading();
    final response = await webService.addEnquiry(enquiry: model);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['data'] != null) {
        changeLoading();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// get Transaction History
  Future getTransactionHistory() async {
    changeLoading();
    final response = await webService.getTransactionHistory(profileDetails!.userID ?? "0");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      // log("==>> getTransactionHistory $responseDecoded");
      if (responseDecoded != null) {
        transactionModel = TransactionModel.fromJson(responseDecoded);
        changeLoading();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// get Transaction List
  Future getTransactionList() async {
    transactionList = [];
    filtertransactionList = [];
    changeLoading();
    final response = await webService.getTransactionList(profileDetails!.userID ?? "0");

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      // log("==>> getTransactionHistory ${responseDecoded['Data']}");
      if (responseDecoded['Data'] != null) {
        for (var transaction in responseDecoded['Data']) {
          TransactionList data = TransactionList.fromJson(transaction);
          transactionList.add(data);
          filtertransactionList.add(data);
        }
        changeLoading();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// filter transaction list
  filterWork({required DateTime start, required DateTime end}) {
    filtertransactionList = [];
    for (TransactionList data in transactionList) {
      if (data.transactionsDate!.difference(start).inDays > 0) {
        if (data.transactionsDate!.difference(end).inDays <= 0) {
          filtertransactionList.add(data);
        }
      }
    }
    notifyListeners();
  }

  /// get review
  List<Review> reviewList = [];

  ///
  Future getReview({required String farmerID, required String productID}) async {
    reviewList = [];
    changeLoading();
    final response = await webService.getReview(farmerID: farmerID, productID: productID);

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      log("==>> getReview ${responseDecoded['data']}");
      if (responseDecoded['data'] != null) {
        for (var review in responseDecoded['data']) {
          Review data = Review.fromJson(review);
          reviewList.add(data);
        }
        changeLoading();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }

  /// training module
  List<Training> trainingList = [];

  ///
  Future getTraining() async {
    trainingList = [];
    changeLoading();
    final response = await webService.getTraining();

    if (response != "error") {
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseDecoded['status'] == "true") {
        for (var data in responseDecoded['data']) {
          Training enquiry = Training.fromJson(data);
          trainingList.add(enquiry);
        }
        changeLoading();
        return "success";
      } else {
        changeLoading();
        return "error";
      }
    } else {
      changeLoading();
      return "error";
    }
  }
}
