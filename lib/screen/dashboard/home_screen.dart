import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/helper/app_image.dart';
import 'package:sub_franchisee/helper/navigations.dart';
import 'package:sub_franchisee/screen/dashboard/leave_modual/attendance_module.dart';
import 'package:sub_franchisee/screen/dashboard/offline_sell_screens/select_product.dart';
import 'package:sub_franchisee/screen/dashboard/order_history.dart';
import 'package:sub_franchisee/screen/dashboard/delivery_boy_modual/delivery_boy_list.dart';
import 'package:sub_franchisee/screen/dashboard/inventory_modual/inventory_screen.dart';
import 'package:sub_franchisee/screen/dashboard/orders_screen.dart';
import 'package:sub_franchisee/screen/dashboard/product_history.dart';
import 'package:sub_franchisee/screen/dashboard/setting_modual.dart';
import 'package:sub_franchisee/screen/dashboard/statistics_modual/statistics_screen.dart';
import 'package:sub_franchisee/screen/dashboard/subscription/subscription_screen.dart';
import 'package:sub_franchisee/service/background_service.dart';
import '../../api/app_preferences.dart';
import '../../view model/CustomViewModel.dart';
import '../sign_up_modual/signup_screen.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_widgets.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoad = false;
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await getData();
    await CustomViewModel.determinePosition();
    _refreshController.refreshCompleted();
  }

  getData() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    setState(() {
      isLoad = true;
    });
    await state.getProfile().then((value) async {
      if (value == "error") {
        await AppPreferences.clearAll().then((value) => pushReplacement(context, const SignUpScreen()));
      }
      log(Platform.version);
      await CustomViewModel.determinePosition().then((value) async {
        await state
            .updateFCM(
                userID: state.profileDetails!.userID ?? "",
                userPlatformos: Platform.isAndroid ? "Android" : "IOS",
                userFcmtoken: await FirebaseMessaging.instance.getToken() ?? "",
                lat: value.latitude.toString(),
                long: value.longitude.toString())
            .then((value) {
          if (state.profileDetails!.userStatus == "0") {
            popup(
                size: MediaQuery.of(context).size,
                context: context,
                title: "Do you want to open your Shop Today?",
                onYesTap: () async {
                  await state.shopOnOff("1");
                  await AppPreferences.setShop(true);
                  await BackgroundService.initializeService();
                });
          }
        });
      });
    });
    await state.getState();
    await state.getOrder();
    await state.getInventory();
    await state.getAllDeliveryBoy(state.profileDetails!.userID ?? "");
    if (state.profileDetails != null && state.profileDetails!.userCityid != "") {
      await state.getCity(state.profileDetails!.userStateid!);
    }
    if (await AppPreferences.getShop()) {
      await BackgroundService.initializeService();
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getData();
        await CustomViewModel.determinePosition();
      },
    );
    super.initState();
  }

  String selectedValue = "Today";
  String selectedValue1 = "Today";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        popup(
            title: "Are you sure want to exit app?",
            size: size,
            context: context,
            isBack: true,
            onYesTap: () {
              exit(1);
            });
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: isLoad ? Colors.white : AppColors.primary,
        body: isLoad
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).padding.top),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sub-Franchise",
                                  style: TextStyle(
                                    fontSize: size.width * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                CustomIconButton(
                                    size: size,
                                    icon: Icons.notifications,
                                    onTap: () {
                                      // FirebaseCrashlytics.instance.crash();
                                      push(context, const NotificationScreen());
                                    },
                                    color: Colors.white),
                              ],
                            ),
                            SizedBox(height: size.width * 0.035),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                dropContainer(
                                    desc: "Today's\ntotal Collection",
                                    size: size,
                                    onChange: (String value) {
                                      setState(() {
                                        log("===>> $value");
                                        selectedValue = value;
                                      });
                                    },
                                    price: "10000",
                                    selectedValue: selectedValue),
                                dropContainer(
                                    desc: "Today's\ntotal Profit",
                                    size: size,
                                    onChange: (String value) {
                                      setState(() {
                                        log("===>> $value");
                                        selectedValue1 = value;
                                      });
                                    },
                                    price: "2000",
                                    selectedValue: selectedValue1),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      // height: size.height * 0.72,
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                child: Text(
                                  "Franchise Dashboard",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: size.width * 0.062,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      container(
                                        isRight: false,
                                        name: "Today's Orders",
                                        icon: AppImages.orders,
                                        size: size,
                                        onTap: () {
                                          push(context, const OrderScreen());
                                        },
                                      ),
                                      const SizedBox(width: 25),
                                      container(
                                        name: "Offline Sell",
                                        icon: AppImages.selling,
                                        size: size,
                                        onTap: () {
                                          push(context, const SelectOrder());
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      container(
                                        isRight: false,
                                        name: "Subscriptions",
                                        icon: AppImages.subscribe,
                                        size: size,
                                        onTap: () {
                                          push(context, const SubscriptionScreen());
                                        },
                                      ),
                                      const SizedBox(width: 25),
                                      container(
                                        name: "Inventory",
                                        icon: AppImages.inventory,
                                        size: size,
                                        onTap: () {
                                          push(context, const InventoryScreen());
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      container(
                                        isRight: false,
                                        name: "Order History",
                                        icon: AppImages.orderHistory,
                                        size: size,
                                        onTap: () {
                                          push(context, const OrderHistory());
                                        },
                                      ),
                                      const SizedBox(width: 25),
                                      container(
                                        name: "Product History",
                                        icon: AppImages.productHistory,
                                        size: size,
                                        onTap: () {
                                          push(context, const ProductHistory());
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      container(
                                        isRight: false,
                                        name: "Statistics",
                                        icon: AppImages.statistics,
                                        size: size,
                                        onTap: () {
                                          push(context, const StatisticsScreen());
                                        },
                                      ),
                                      const SizedBox(width: 25),
                                      container(
                                        name: "Delivery boy",
                                        icon: AppImages.deliveryBoy,
                                        size: size,
                                        onTap: () {
                                          push(context, const DeliveryBoyList());
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      container(
                                        isRight: false,
                                        name: "Leave Module",
                                        icon: AppImages.statistics,
                                        size: size,
                                        onTap: () {
                                          push(context, const AttendanceModule());
                                        },
                                      ),
                                      const SizedBox(width: 25),
                                      container(
                                        name: "General Settings",
                                        icon: AppImages.settings,
                                        size: size,
                                        onTap: () {
                                          push(context, const SettingScreen());
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: MediaQuery.of(context).padding.bottom + 20)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget container(
      {required String name,
      required String icon,
      String? desc,
      required Size size,
      required Function onTap,
      bool isRight = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: isRight ? EdgeInsets.only(right: size.width * 0.05) : EdgeInsets.only(left: size.width * 0.05),
          padding: const EdgeInsets.all(15),
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                offset: const Offset(1, 1),
                blurRadius: 5,
              ),
              const BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                offset: Offset(-1, -1),
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8, bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(icon, width: size.width * 0.06),
              ),
              SizedBox(
                // width: size.width * 0.2,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.044,
                    fontWeight: FontWeight.w600,
                    // color: AppColors.primary,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dropContainer(
      {required Size size,
      required Function(String value) onChange,
      required String price,
      required String desc,
      required String selectedValue}) {
    return Container(
      height: size.width * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      width: size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            desc,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.045,
            ),
          ),
          Text(
            "₹ $price",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: size.width * 0.055,
            ),
          ),
        ],
      ),
    );
  }
}
