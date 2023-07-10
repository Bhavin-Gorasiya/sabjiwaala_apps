import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import '../../helper/app_config.dart';
import '../../helper/navigations.dart';
import '../../models/order_model.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_widgets.dart';
import 'order_details.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getOrder();

    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getOrder();
      },
    );
    super.initState();
  }

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMMM');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Order history"),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      width: size.width,
                      margin: EdgeInsets.only(right: size.width * 0.05),
                      height: 40,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        icon: const Icon(Icons.date_range_rounded),
                        label: Text(
                          startDate == null
                              ? "Select Date"
                              : startDate!.day == endDate!.day
                                  ? format.format(startDate!)
                                  : "${format.format(startDate!)} - ${format.format(endDate!)}",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await _showDatePicker();
                        },
                      ),
                    ),
                    Consumer<CustomViewModel>(builder: (context, state, child) {
                      return state.filterOrderList.isEmpty
                          ? Container(
                              height: size.height * 0.7,
                              width: size.width,
                              alignment: Alignment.center,
                              child: state.isLoading
                                  ? const CircularProgressIndicator(color: AppColors.primary)
                                  : const Text("No Data found"),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.filterOrderList.length,
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                              itemBuilder: (context, index) {
                                OrderModel data = state.filterOrderList[index];
                                int price = 0;
                                int qty = 0;
                                for (Orderdetail order in data.detailsPrevious!) {
                                  price += int.parse(order.orderdetailsMrp ?? "0");
                                  qty += int.parse(order.orderdetailsQnty ?? "0");
                                }
                                return GestureDetector(
                                  onTap: () {
                                    push(
                                        context,
                                        OrderDetails(
                                          isHistory: data.orderStatus == "Pending" ? false : true,
                                          isDelivered: data.orderStatus == "Completed" ? true : false,
                                          isHistoryScreen: true,
                                          data: data,
                                        ));
                                  },
                                  child: CustomContainer(
                                    horPad: 12,
                                    vertPad: 12,
                                    size: size,
                                    boxShadow: data.orderStatus == "Pending"
                                        ? Colors.black12
                                        : data.orderStatus == "Completed"
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
                                            imageUrl: "${AppConfig.apiUrl}"
                                                "${data.detailsPrevious!.first.orderdetailsPpic ?? ""}",
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
                                                  title: "Payment Type: ",
                                                  desc: data.orderPaymentStatus ?? "",
                                                  size: size),
                                              const SizedBox(height: 5),
                                              if (data.orderStatus != "Pending")
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: data.orderStatus == "Completed"
                                                          ? AppColors.primary
                                                          : AppColors.red,
                                                      radius: size.width * 0.02,
                                                      child: Icon(
                                                        data.orderStatus == "Completed" ? Icons.check : Icons.close,
                                                        size: size.width * 0.035,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(data.orderStatus ?? "")
                                                  ],
                                                )
                                              else if(data.orderPaymentStatus != "Pickup")
                                                Text(
                                                  data.orderDeliveryboyid == "" ? "Not Assign" : "Assign",
                                                  style: TextStyle(
                                                    color: data.orderDeliveryboyid == ""
                                                        ? AppColors.red
                                                        : AppColors.primary,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    final DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: Colors.grey,
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onSurface: Colors.grey,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate.start;
        endDate = pickedDate.end;
        state.filterOrder(start: startDate!, end: endDate!);
        int diff = endDate!.difference(startDate!).inDays;
        log(endDate!.difference(startDate!).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }
}
/* GestureDetector(
                      onTap: () {
                        push(context, EnquiryDetailScreen());
                      },
                      child: CustomContainer(
                        size: size,
                        rad: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Customer Name",
                                  style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "subject : ",
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.58,
                                      child: Text(
                                        "Ask for 25 lakh in exchange of 5% equity of Subjiwaala",
                                        style: TextStyle(
                                            fontSize: size.width * 0.035,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.6)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: size.width * 0.05,
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    );*/
