import 'dart:developer';

import 'package:delivery_app/api/app_preferences.dart';
import 'package:delivery_app/helper/navigations.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/screens/home_modual/notification_screen.dart';
import 'package:delivery_app/screens/home_modual/order_details.dart';
import 'package:delivery_app/screens/home_modual/profile_modual/view_profile.dart';
import 'package:delivery_app/screens/widgets/custom_appbar.dart';
import 'package:delivery_app/screens/widgets/custom_icon_button.dart';
import 'package:delivery_app/screens/widgets/loading.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../helper/app_colors.dart';
import '../../provider/custom_view_model.dart';
import '../sign_up_modual/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoad = false;
  bool isLoad1 = false;
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    setState(() {
      isLoad1 = true;
    });
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getOrder();
    await state.getSubs();
    await state.updateFCM();
    setState(() {
      isLoad1 = false;
    });
    state.changeList(selectedTab);
    _refreshController.refreshCompleted();
  }

  getData() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    if (state.profileDetails == null) {
      setState(() {
        isLoad = true;
      });
      await state.getProfile().then((value) async {
        if (value == "error") {
          await AppPreferences.clearAll().then((value) => pushReplacement(context, const SignUpScreen()));
        }
      });
      await state.getState();
      await state.getOrder();
      await state.getSubs();
      await state.updateFCM();
      if (state.profileDetails!.userCityid != "") {
        await state.getCity(state.profileDetails!.userStateid!);
      }
      state.changeList(selectedTab);
      setState(() {
        isLoad = false;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getData();
      },
    );
    super.initState();
  }

  String selectedTab = "Pending";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoad
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(
                size: size,
                widget: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hello  Mr. Gentleman",
                          style: TextStyle(
                            fontSize: size.width * 0.048,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        CustomIconButton(
                            size: size,
                            icon: Icons.notifications,
                            onTap: () {
                              // FirebaseCrashlytics.instance.crash();
                              push(context, const NotificationScreen());
                            },
                            color: Colors.white),
                        const SizedBox(width: 10),
                        CustomIconButton(
                            size: size,
                            icon: Icons.person,
                            onTap: () {
                              push(context, const ViewProfile());
                            },
                            color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              Consumer<CustomViewModel>(builder: (context, state, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textColumn(
                          title: state.pendingOrders.length.toString(), desc: "Pending", size: size, state: state),
                      textColumn(
                          title: state.outDeliveryOrders.length.toString(),
                          desc: "Out for Delivery",
                          size: size,
                          state: state),
                      textColumn(
                          title: state.completedOrders.length.toString(), desc: "Completed", size: size, state: state),
                      textColumn(
                          title: state.cancelledOrders.length.toString(), desc: "Cancelled", size: size, state: state),
                    ],
                  ),
                );
              }),
              Consumer<CustomViewModel>(builder: (context, state, child) {
                return Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: Stack(
                      children: [
                        isLoad1
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: size.width * 0.05),
                                      child: Text(
                                        "$selectedTab Orders",
                                        style: TextStyle(
                                          fontSize: size.width * 0.05,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    state.orderList.isEmpty
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: size.height * 0.55,
                                            child: const Text("No Order Found"),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                                            itemCount: state.orderList.length,
                                            itemBuilder: (context, index) {
                                              OrderModel data = state.orderList[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  if (selectedTab == "Completed" || selectedTab == "Cancelled") {
                                                    push(
                                                        context,
                                                        OrderDetails(
                                                          isDelivered: selectedTab == "Completed",
                                                          isHistory: true,
                                                          data: data,
                                                        ));
                                                  }
                                                },
                                                child: CustomContainer(
                                                  size: size,
                                                  rad: size.width * 0.05,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          orderText(
                                                              title: "Order ID",
                                                              desc: "#${data.orderGeneratedid}",
                                                              size: size,
                                                              width: size.width * 0.3),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                            decoration: BoxDecoration(
                                                              color: selectedTab == "Pending"
                                                                  ? Colors.grey
                                                                  : selectedTab == "Out for Delivery"
                                                                      ? AppColors.primary.withOpacity(0.5)
                                                                      : selectedTab == "Completed"
                                                                          ? Colors.green
                                                                          : Colors.red,
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                            child: Text(
                                                              data.orderStatus ?? "",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: size.width * 0.03,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      orderText(
                                                          width: size.width * 0.6,
                                                          title: "Name",
                                                          desc: "${data.userDetails!.customerFirstname} "
                                                              "${data.userDetails!.customerLastname}",
                                                          size: size),
                                                      orderText(
                                                        width: size.width * 0.6,
                                                        title: "Location",
                                                        desc: data.userDetails!.addressesAddress ?? "",
                                                        size: size,
                                                      ),
                                                      if (selectedTab != "Completed" && selectedTab != "Cancelled")
                                                        const SizedBox(height: 8),
                                                      if (selectedTab != "Completed" && selectedTab != "Cancelled")
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                push(
                                                                    context,
                                                                    OrderDetails(
                                                                        isPending: selectedTab == "Pending",
                                                                        data: data));
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                width: size.width * 0.35,
                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    border: Border.all(color: AppColors.primary)),
                                                                child: Text(
                                                                  "View Details",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: size.width * 0.038,
                                                                      color: AppColors.primary),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (selectedTab == "Pending") {
                                                                  await state
                                                                      .changeStatus(
                                                                          id: data.orderId ?? "",
                                                                          status: "Out for Delivery",
                                                                          type: data.orderType ?? "")
                                                                      .then((value) {
                                                                    state.changeList("Pending");
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                width: size.width * 0.35,
                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(colors: [
                                                                    AppColors.primary.withOpacity(0.6),
                                                                    AppColors.primary,
                                                                  ]),
                                                                  borderRadius: BorderRadius.circular(100),
                                                                ),
                                                                child: Text(
                                                                  selectedTab == "Pending"
                                                                      ? "Out for delivery"
                                                                      : "Direction",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: size.width * 0.038,
                                                                      color: Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                  ],
                                ),
                              ),
                        if (state.isLoading) const Loading()
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
  }

  Widget orderText({required String title, required String desc, required Size size, double? width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: width,
            child: Text(
              desc,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: size.width * 0.038),
            ),
          ),
        ],
      ),
    );
  }

  Widget textColumn({required String title, required String desc, required Size size, required CustomViewModel state}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = desc;
          state.changeList(desc);
        });
      },
      child: Container(
        width: size.width * 0.22,
        height: size.width * 0.18,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: desc == selectedTab ? Colors.green.withOpacity(0.6) : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.w700,
                color: desc == selectedTab ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              desc,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.w500,
                color: desc == selectedTab ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
