import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/models/order_model.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_config.dart';
import '../../helper/navigations.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_widgets.dart';
import 'order_details.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final RefreshController _refreshController = RefreshController();

  int price = 0;

  getPrice(CustomViewModel state) {
    price = 0;
    for (OrderModel data in state.todayPOrderList) {
      price += (int.parse(data.detailsToday!.first.orderdetailsMrp ?? "0") *
          int.parse(data.detailsToday!.first.orderdetailsQnty ?? "0"));
    }
    setState(() {});
  }

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getOrder();
    setState(() {
      if (selectedTab == "Completed") {
        list = state.todayCOrderList;
      } else if (selectedTab == "Cancelled") {
        list = state.todayCOrderList;
      } else {
        list = state.todayPOrderList;
      }
    });
    getPrice(state);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getOrder();
        list = state.todayPOrderList;
        getPrice(state);
      },
    );
    super.initState();
  }

  String selectedTab = 'Pending';
  List<OrderModel> list = [];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
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
                        "Today's Order",
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
                        tabContainer(name: "Pending", size: size, state: state),
                        tabContainer(name: "Completed", size: size, state: state),
                        tabContainer(name: "Cancelled", size: size, state: state),
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
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: list.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: size.height * 0.6,
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: AppColors.primary)
                            : Text("No $selectedTab Order found!"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          OrderModel data = list[index];
                          int price = 0;
                          int qty = 0;
                          for (Orderdetail order in data.detailsToday!) {
                            price += int.parse(order.orderdetailsMrp ?? "0");
                            qty += int.parse(order.orderdetailsQnty ?? "0");
                          }
                          // log("=== ${state.todayOrderList.length} $index ===${data.orderID} ${data.orderStatus}");
                          return GestureDetector(
                            onTap: () {
                              push(
                                  context,
                                  OrderDetails(
                                    isHistory: selectedTab == "Pending" ? false : true,
                                    isDelivered: selectedTab == "Completed" ? true : false,
                                    data: data,
                                  ));
                            },
                            child: CustomContainer(
                              horPad: 12,
                              vertPad: 12,
                              size: size,
                              boxShadow: selectedTab == "Pending"
                                  ? Colors.black12
                                  : selectedTab == "Completed"
                                      ? AppColors.primary.withOpacity(0.3)
                                      : AppColors.red.withOpacity(0.3),
                              rad: 8,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      width: size.width * 0.15,
                                      height: size.width * 0.15,
                                      imageUrl: "${AppConfig.apiUrl}${data.detailsToday!.first.orderdetailsPpic ?? ""}",
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Image(image: AssetImage("assets/bg.png")),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.03),
                                  SizedBox(
                                    width: size.width * 0.62,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        dualText(title: "Order ID: ", desc: "#${data.orderID}", size: size),
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            dualText(title: "Price: ", desc: "₹ $price", size: size),
                                            dualText(title: "Qty: ", desc: "$qty", size: size),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        dualText(
                                            title: "Payment Type: ", desc: data.orderPaymentStatus ?? "", size: size),
                                        const SizedBox(height: 5),
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
                                        else if (data.orderPaymentStatus != "Pickup")
                                          Text(
                                            data.orderDeliveryboyid == ""
                                                ? "Not Assign"
                                                : data.orderStatus == "Out for Delivery"
                                                    ? "Out for Delivery"
                                                    : "Assign",
                                            style: TextStyle(
                                                color:
                                                    data.orderDeliveryboyid == "" ? AppColors.red : AppColors.primary,
                                                fontWeight: FontWeight.w600),
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
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.only(
              right: size.width * 0.05,
              left: size.width * 0.05,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                columnText(title: "Total Collection", number: "$price", size: size),
                columnText(title: "Total Revenue", number: "${(price * state.userPercentage).toInt()}", size: size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget columnText({required String title, required String number, required Size size}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          number,
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget tabContainer({required String name, required Size size, required CustomViewModel state}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = name;
          if (name == "Completed") {
            list = state.todayCOrderList;
          } else if (name == "Cancelled") {
            list = state.todayCOrderList;
          } else {
            list = state.todayPOrderList;
          }
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
}
