import 'dart:developer';

import 'package:delivery_app/helper/navigations.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/provider/custom_view_model.dart';
import 'package:delivery_app/screens/home_modual/order_details.dart';
import 'package:delivery_app/screens/widgets/custom_appbar.dart';
import 'package:delivery_app/screens/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../helper/app_colors.dart';
import '../widgets/custom_widgets.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.filter();
    _refreshController.refreshCompleted();
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              CustomAppBar(
                size: size,
                widget: Text(
                  "Order History",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return FilterSheet(size: size);
                    },
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: size.width * 0.05),
                  child: const Icon(Icons.filter_alt, color: Colors.white),
                ),
              )
            ],
          ),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                  itemCount: state.filterOrderList.length,
                  itemBuilder: (context, index) {
                    OrderModel data = state.filterOrderList[index];
                    return GestureDetector(
                      onTap: () {
                        push(
                            context,
                            OrderDetails(
                              data: data,
                              isHistory: true,
                              isDelivered: data.orderStatus == "Completed",
                            ));
                      },
                      child: CustomContainer(
                        horPad: 12,
                        vertPad: 12,
                        size: size,
                        boxShadow: data.orderStatus != "Completed"
                            ? AppColors.red.withOpacity(0.3)
                            : AppColors.primary.withOpacity(0.3),
                        rad: 8,
                        child: Row(
                          children: [
                            Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primary.withOpacity(0.4),
                              ),
                              child: Image.asset(
                                "assets/bg.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dualText(title: "Order ID: ", desc: "#${data.orderGeneratedid}", size: size),
                                const SizedBox(height: 2),
                                dualText(title: "Price: ", desc: "₹ ${data.orderSubtotal}", size: size),
                                const SizedBox(height: 2),
                                dualText(title: "Payment Type: ", desc: data.orderPaymentStatus ?? "", size: size),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          data.orderStatus == "Completed" ? AppColors.primary : AppColors.red,
                                      radius: size.width * 0.02,
                                      child: Icon(
                                        data.orderStatus == "Completed" ? Icons.check : Icons.close,
                                        size: size.width * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    Text(data.orderStatus == "Completed" ? "Delivered" : "Not Delivered"),
                                  ],
                                ),
                              ],
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
          /*Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            width: size.width,
            height: 50,
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dualText(
                  title: "Total Orders : ",
                  desc: "100",
                  size: size,
                  color: Colors.white,
                  titleSize: size.width * 0.04,
                  descSize: size.width * 0.04,
                ),
                dualText(
                  title: "Total Earnings : ",
                  desc: "₹100 /-",
                  size: size,
                  color: Colors.white,
                  titleSize: size.width * 0.04,
                  descSize: size.width * 0.04,
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}

class FilterSheet extends StatefulWidget {
  final Size size;

  const FilterSheet({Key? key, required this.size}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool isDelivered = false;
  bool isCancelled = false;
  bool today = false;
  bool lastWeek = false;
  bool lastMonth = false;
  String? status;
  String? time;
  DateTime? start;
  DateTime? end;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05, vertical: 15),
      child: Consumer<CustomViewModel>(builder: (context, state, child) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter previous orders",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: widget.size.width * 0.055,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "By Delivery Status",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: widget.size.width * 0.043),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        checkBox(
                            name: "Delivered",
                            value: isDelivered,
                            onTap: () {
                              setState(() {
                                isDelivered = !isDelivered;
                                isCancelled = false;
                                if (isDelivered) {
                                  status = "Completed";
                                } else {
                                  status = null;
                                }
                                state.filter(status: status, time: time, end: end, start: start);
                              });
                            }),
                        checkBox(
                            name: "Cancelled",
                            value: isCancelled,
                            onTap: () {
                              setState(() {
                                isCancelled = !isCancelled;
                                isDelivered = false;
                                if (isCancelled) {
                                  status = "Cancelled";
                                } else {
                                  status = null;
                                }
                                state.filter(status: status, time: time, end: end, start: start);
                              });
                            }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "By Time",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: widget.size.width * 0.043),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        checkBox(
                            name: "Today",
                            value: today,
                            onTap: () {
                              setState(() {
                                start = null;
                                end = null;
                                today = !today;
                                lastWeek = false;
                                lastMonth = false;
                                if (today) {
                                  time = "Today";
                                } else {
                                  time = null;
                                }
                                state.filter(time: time, status: status);
                              });
                            }),
                        checkBox(
                            name: "Last week",
                            value: lastWeek,
                            onTap: () {
                              setState(() {
                                start = null;
                                end = null;
                                lastWeek = !lastWeek;
                                lastMonth = false;
                                today = false;
                                if (lastWeek) {
                                  time = "Last week";
                                } else {
                                  time = null;
                                }
                                state.filter(time: time, status: status);
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        checkBox(
                            name: "Last month",
                            value: lastMonth,
                            onTap: () {
                              setState(() {
                                start = null;
                                end = null;
                                lastMonth = !lastMonth;
                                today = false;
                                lastWeek = false;
                                if (lastMonth) {
                                  time = "Last month";
                                } else {
                                  time = null;
                                }
                                state.filter(time: time, status: status);
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: widget.size.width * 0.3,
                          height: 35,
                          child: const Divider(color: Colors.black26, thickness: 1),
                        ),
                        const Text("OR"),
                        SizedBox(
                          width: widget.size.width * 0.3,
                          child: const Divider(color: Colors.black26, thickness: 1),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        datePicker(
                            initial: start ?? DateTime.now(),
                            title: "From",
                            date: start == null
                                ? "Select date"
                                    ""
                                : convertToYMDFormat(start ?? DateTime.now()),
                            onTap: (value) {
                              setState(() {
                                today = false;
                                lastWeek = false;
                                lastMonth = false;
                                start = value;
                                state.filter(start: start, end: end, status: status);
                              });
                            },
                            size: widget.size),
                        datePicker(
                            initial: end ?? DateTime.now(),
                            title: "To",
                            date: end == null
                                ? "Select date"
                                    ""
                                : convertToYMDFormat(end ?? DateTime.now()),
                            onTap: (value) {
                              setState(() {
                                today = false;
                                lastWeek = false;
                                lastMonth = false;
                                end = value;
                                state.filter(start: start, end: end, status: status);
                              });
                            },
                            size: widget.size),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8, top: 8),
              child: CustomBtn(
                size: widget.size,
                title: "Show ${state.filterOrderList.length} results",
                onTap: () {
                  pop(context);
                },
                btnColor: AppColors.primary,
                radius: 10,
              ),
            )
          ],
        );
      }),
    );
  }

  Widget checkBox({required String name, required bool value, required Function onTap}) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (values) {
            onTap();
          },
          activeColor: AppColors.primary,
        ),
        Text(
          name,
          style: TextStyle(fontSize: widget.size.width * 0.04),
        ),
      ],
    );
  }

  Widget datePicker({
    required String title,
    required String date,
    required Function(DateTime?) onTap,
    required DateTime initial,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title :',
          style: TextStyle(fontSize: widget.size.width * 0.038, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            await showDatePicker(
                    context: context, initialDate: initial, firstDate: DateTime(200), lastDate: DateTime.now())
                .then((value) {
              if (value != null) {
                onTap(value);
              }
            });
          },
          child: Row(
            children: [
              Container(
                height: widget.size.width * 0.1,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: const Icon(Icons.timer, color: Colors.white),
              ),
              Container(
                alignment: Alignment.center,
                height: widget.size.width * 0.1,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  date,
                  style: TextStyle(fontSize: widget.size.width * 0.035, color: Colors.black54),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

String convertToYMDFormat(DateTime time) {
  String date = "${time.day < 10 ? '0${time.day}' : '${time.day}'}-"
      "${time.month < 10 ? '0${time.month}' : '${time.month}'}-"
      "${time.year}";
  return date;
}
