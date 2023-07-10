import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:subjiwala/Widgets/shimmer_loader/image_loader.dart';
import 'package:subjiwala/models/order_place.dart';
import '../../View Models/CustomViewModel.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/helper.dart';
import 'order_details.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getAllOrder(state.customerDetail.first.customerId ?? "1");
        state.filterOrder("pending");
      },
    );
    super.initState();
  }

  onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAllOrder(state.customerDetail.first.customerId ?? "1");
    state.filterOrder(selectedTab.toLowerCase());
    _controller.refreshCompleted();
  }

  String selectedTab = 'Pending';

  final RefreshController _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  // gradient: LinearGradient(colors: [
                  //   AppColors.primary.withOpacity(0.6),
                  //   AppColors.primary,
                  // ]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, bottom: 25),
                      child: Text(
                        "My Orders",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tabContainer(name: "Pending", size: size),
                        tabContainer(name: "Completed", size: size),
                        tabContainer(name: "Cancelled", size: size),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: GestureDetector(
                  onTap: () {
                    pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: size.width * 0.05),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
              ),
              /* Positioned(
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sort by",
                                  style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                sortText(text: "Price High to Low", size: size),
                                sortText(text: "Price Low to High", size: size),
                                sortText(text: "Ascending by Time", size: size),
                                sortText(text: "Descending by Time", size: size),
                                SizedBox(height: MediaQuery.of(context).padding.bottom + 15),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: size.width * 0.05),
                      child: Image.asset("assets/sort.png", height: size.width * 0.06, color: Colors.white),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SmartRefresher(
              controller: _controller,
              onRefresh: onRefresh,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filterOrderList.isEmpty
                      ? const Center(child: Text("No data found."))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                          itemCount: state.filterOrderList.length,
                          itemBuilder: (context, index) {
                            MyOrder order = state.filterOrderList[index];
                            int qty = 0;
                            for (Orderdetail data in order.orderdetails ?? []) {
                              qty = qty + int.parse(data.orderdetailsQnty ?? "0");
                            }
                            log("===>>> ${order.orderStatus!.toLowerCase()}");
                            return GestureDetector(
                              onTap: () {
                                push(
                                    context,
                                    OrderDetails(
                                      order: order,
                                      isHistory: selectedTab == "Pending" ? false : true,
                                      isDelivered: selectedTab == "Completed" ? true : false,
                                    ));
                              },
                              child: CustomContainer(
                                horPad: 12,
                                vertPad: 12,
                                size: size,
                                boxShadow: selectedTab == "Cancelled"
                                    ? AppColors.red.withOpacity(0.3)
                                    : selectedTab == "Completed"
                                        ? AppColors.primary.withOpacity(0.3)
                                        : Colors.black12,
                                rad: 8,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        width: size.width * 0.15,
                                        height: size.width * 0.15,
                                        fit: BoxFit.cover,
                                        imageUrl: AppConfig.apiUrl + (order.orderdetails!.first.orderdetailsPpic ?? ""),
                                        placeholder: (context, url) => ImageLoader(
                                            width: size.width * 0.15, height: size.width * 0.15, radius: 10),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.image_not_supported_outlined),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    SizedBox(
                                      width: size.width * 0.62,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dualText(
                                              title: "Order ID: ",
                                              desc: "${order.orderdetails!.first.orderdetailsGeneratedid}",
                                              size: size),
                                          const SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              dualText(title: "Price: ", desc: "₹ ${order.orderTotalamt}", size: size),
                                              dualText(title: "Qty: ", desc: qty.toString(), size: size),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          dualText(
                                              title: "Payment Type: ",
                                              desc: order.orderPaymentStatus ?? "",
                                              size: size),
                                          if (selectedTab != "Pending") const SizedBox(height: 5),
                                          if (selectedTab != "Pending")
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      selectedTab == "Completed" ? AppColors.primary : AppColors.red,
                                                  radius: size.width * 0.02,
                                                  child: Icon(
                                                    selectedTab == "Completed" ? Icons.check : Icons.close,
                                                    size: size.width * 0.035,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(selectedTab)
                                              ],
                                            )
                                          else if (order.orderStatus != "Pending")
                                            Text(
                                              order.orderStatus ?? "",
                                              style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w600),
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
          )
        ],
      );
    });
  }

  Widget tabContainer({required String name, required Size size}) {
    return GestureDetector(
      onTap: () {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        state.filterOrder(name.toLowerCase());
        setState(() {
          selectedTab = name;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 2.5,
              width: size.width / 3 - 14,
              color: selectedTab == name ? Colors.white : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget sortText({required String text, required Size size}) {
    return GestureDetector(
      onTap: () {
        pop(context);
      },
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Text(
          text,
          style: TextStyle(fontSize: size.width * .04),
        ),
      ),
    );
  }
}

dualText({required String title, required String desc, required Size size}) {
  return Row(
    children: [
      Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: size.width * 0.035,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        desc,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: size.width * 0.035, color: Colors.black.withOpacity(0.7)),
      ),
    ],
  );
}

class CustomContainer extends StatelessWidget {
  final Size size;
  final double rad;
  final Widget child;
  final double? margin;
  final double? vertPad;
  final double? horPad;
  final Color? boxShadow;

  const CustomContainer({
    Key? key,
    required this.size,
    required this.rad,
    required this.child,
    this.margin,
    this.vertPad,
    this.horPad,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: margin ?? 15),
      padding: EdgeInsets.symmetric(horizontal: horPad ?? size.width * 0.05, vertical: vertPad ?? 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rad),
        boxShadow: [
          BoxShadow(color: boxShadow ?? Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }
}
