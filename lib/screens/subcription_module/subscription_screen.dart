import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/models/subscription_model.dart';
import 'package:subjiwala/screens/profile_modual/subscription_detail.dart';
import 'package:subjiwala/screens/subcription_module/sub_order.dart';
import 'package:subjiwala/utils/app_config.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/app_dialogs.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';

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
        await state.getAllSubscriptionOrder();
      },
    );
    super.initState();
  }

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAllSubscriptionOrder();
    log("===>>> onRefresh");
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          appBar(context: context, title: "My Subscriptions", size: size),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: state.subsOrderList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                        itemBuilder: (context, index) {
                          Subscription data = state.subsOrderList[index];
                          return subContainer(size: size, data: data, index: index);
                        },
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget subContainer({required Size size, required Subscription data, required int index}) {
    List<String> dates = data.productDetails!.last.subscriptionorderSDate!.split('-');
    DateTime end = DateTime(int.parse(dates[2]), int.parse(dates[1]), int.parse(dates[0]));
    return GestureDetector(
      onTap: () {
        push(
            context,
            SubOrderScreen(
                vendorMobile: data.vendorMobile ?? "8956545645",
                vendorName: data.vendorName ?? "Bhavin",
                mainIndex: index,
                list: data.productDetails ?? [],
                img: AppConfig.apiUrl + (data.productDetails!.first.subscriptionPpic ?? ""),
                name: data.productDetails!.first.subscriptionorderPname ?? ""));
      },
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      child: CachedNetworkImage(
                        height: data.orderStatus == "Pending" ? size.width * 0.2 : size.width * 0.15,
                        width: data.orderStatus == "Pending" ? size.width * 0.2 : size.width * 0.15,
                        fit: BoxFit.cover,
                        imageUrl: AppConfig.apiUrl + (data.productDetails!.first.subscriptionPpic ?? ""),
                        placeholder: (context, url) => ImageLoader(
                          height: data.orderStatus == "Pending" ? size.width * 0.2 : size.width * 0.15,
                          width: data.orderStatus == "Pending" ? size.width * 0.2 : size.width * 0.15,
                          radius: 10,
                        ),
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.58,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.productDetails!.first.subscriptionorderPname ?? "bannana",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.036,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "MRP : ₹ ${data.productDetails!.first.subscriptionPPrice}.00",
                            style: GoogleFonts.poppins(
                                fontSize: size.width * 0.033, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${DateFormat('MMM d, y').format(data.orderSStartdate!)} to"
                            " ${DateFormat('MMM d, y').format(end)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: size.width * 0.03, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                /*GestureDetector(
                  onTap: () {
                    popup(
                        size: size,
                        context: context,
                        title: "Are you sure want to delete your subscription?",
                        isBack: true,
                        onYesTap: () async {
                          CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                          await state.deleteSubscription(data.orderId ?? "");
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "🗑 Delete",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: size.width * 0.035, color: Colors.black),
                    ),
                  ),
                ),*/
              ],
            ),
            if (data.orderStatus != "Pending")
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
  }

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
                      push(context, SubscriptionPlan(isRecommend: isRecommend, plan: plan));
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
