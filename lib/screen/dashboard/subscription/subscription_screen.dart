import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/screen/dashboard/subscription/sub_order.dart';
import 'package:sub_franchisee/screen/dashboard/subscription/subscribe_screen.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/screen/widgets/custom_btn.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/app_config.dart';
import '../../../helper/navigations.dart';
import '../../../models/order_model.dart';
import '../../../view model/CustomViewModel.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getAllSubscription();
      },
    );
    super.initState();
  }

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAllSubscription();
    log("===>>> onRefresh");
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "My Subscriptions"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : state.subscriptionList.isEmpty
                        ? const Center(child: Text("No data found."))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.subscriptionList.length,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: size.width * 0.05),
                            itemBuilder: (context, index) {
                              VendorSubscription data = state.subscriptionList[index];
                              return GestureDetector(
                                onTap: () {
                                  push(
                                      context, SubscribeScreen(isWeek: data.subscriptionPtype == "Weekly", data: data));
                                },
                                child: CustomContainer(
                                  size: size,
                                  rad: 10,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: size.width * 0.15,
                                          width: size.width * 0.15,
                                          fit: BoxFit.cover,
                                          imageUrl: AppConfig.apiUrl + (data.subscriptionproductPpic ?? ""),
                                          // placeholder: (context, url) => ImageLoader(
                                          //   height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                          //   width: SizeConfig.screenWidth! / 2.2 / 2.2,
                                          //   radius: 10,
                                          // ),
                                          errorWidget: (context, url, error) => const SizedBox(),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: size.width * 0.55,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.subscriptionproductPname ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width * 0.04,
                                              ),
                                            ),
                                            Text(
                                              data.subscriptionproductSdesc ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: size.width * 0.03,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "₹ ${data.subscriptionproductDprice}",
                                                  style: TextStyle(
                                                    fontSize: size.width * 0.033,
                                                    decoration: TextDecoration.lineThrough,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  " ₹ ${data.subscriptionproductPrice} / month",
                                                  style: TextStyle(
                                                    fontSize: size.width * 0.033,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black.withOpacity(0.7),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(
                right: size.width * 0.05,
                left: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom + 5,
                top: 5),
            child: CustomBtn(
              size: size,
              title: "My Subscription Order",
              onTap: () {
                push(context, const SubscriptionOrderScreen());
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          )
        ],
      ),
    );
  }

/*  Widget subContainer({required Size size, required VendorSubscription data, required int index}) {
    // log("====>>> img ${data.subscriptiondata} ");
    return GestureDetector(
      onTap: () {
        // push(
        //     context,
        //     SubOrderScreen(
        //         mainIndex: index,
        //         data: data,
        //         list: data.subscriptiondata ?? [],
        //         img: AppConfig.apiUrl + (data.orderdata!.first.userproductPPic ?? ""),
        //         price: data.orderdata!.first.orderdetailsMrp ?? ""));
      },
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                if (data.subscriptionproductStatus == "Pending")
                  Row(
                    children: [
                      Text(
                        "subscription : ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: size.width * 0.035, color: Colors.black.withOpacity(0.7)),
                      ),
                      Text(
                        data.subscriptionPtype ?? "Daily",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                if (data.subscriptionproductStatus == "Pending")
                  Container(height: 1, color: Colors.black12, margin: const EdgeInsets.symmetric(vertical: 10)),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      child: CachedNetworkImage(
                        height: data.subscriptionproductStatus == "Pending" ? size.width * 0.2 : size.width * 0.15,
                        width: data.subscriptionproductStatus == "Pending" ? size.width * 0.2 : size.width * 0.15,
                        fit: BoxFit.cover,
                        imageUrl: AppConfig.apiUrl + (*/ /*data.subscriptiondata!.first.subscriptionPpic ??*/ /* ""),
                        errorWidget: (context, url, error) => const Image(image: AssetImage("assets/bg.png")),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.58,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.subscriptionproductPname ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: size.width * 0.036,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.subscriptionproductSdesc ?? "",
                            style: TextStyle(fontSize: size.width * 0.03, color: Colors.black),
                          ),
                          Text(
                            "MRP : ₹ ${data.subscriptionproductPrice}.00",
                            style: TextStyle(
                                fontSize: size.width * 0.033, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${DateFormat('MMM d, y').format(data.subscriptionproductDate!)} to"
                            " ${DateFormat('MMM d, y').format(data.subscriptionproductDate!)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: size.width * 0.03, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (data.subscriptionproductStatus == "Pending")
                  if (data.subscriptionproductId == "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isDismissible: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return AssignDeliverySheet(size: size, id: data.subscriptionproductId ?? "0");
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primary),
                            child: const Text(
                              "Assign Delivery Boy",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
              ],
            ),
            if (data.subscriptionproductStatus != "Pending")
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.primary,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const Text("Completed",
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
              )
          ],
        ),
      ),
    );
  }*/

  Widget subscriptionPlan({
    required String plan,
    required Size size,
    required String weight,
    required String totalVeg,
    bool isRecommend = false,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: isRecommend ? AppColors.primary : Colors.black54, width: isRecommend ? 2 : 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width < 380 ? size.width * 0.55 : size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan,
                          maxLines: 2,
                          style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Total weight : $weight Kg.",
                          style: TextStyle(fontSize: size.width * 0.035),
                        ),
                        Text(
                          "Total no. of Vegetables : $totalVeg",
                          style: TextStyle(fontSize: size.width * 0.035),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // push(context, SubscriptionPlan(isRecommend: isRecommend, plan: plan));
                    },
                    child: Text(
                      "Details",
                      style: TextStyle(fontSize: size.width * 0.045),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isRecommend)
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.05 + 15),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primary),
              child: Text(
                "Recommend",
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }
}
