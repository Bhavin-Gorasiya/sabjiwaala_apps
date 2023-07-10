import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';

import '../../../helper/app_colors.dart';
import '../../../helper/app_config.dart';
import '../../../models/order_model.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_widgets.dart';

class OfflineSellHistory extends StatefulWidget {
  const OfflineSellHistory({Key? key}) : super(key: key);

  @override
  State<OfflineSellHistory> createState() => _OfflineSellHistoryState();
}

class _OfflineSellHistoryState extends State<OfflineSellHistory> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getOfflineSell();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getOfflineSell();
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
          CustomAppBar(size: size, title: "History"),
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
                      return state.filterOfflineSellList.isEmpty
                          ? Container(
                              height: size.height * 0.7,
                              width: size.width,
                              alignment: Alignment.center,
                              child: state.isLoading
                                  ? const CircularProgressIndicator(color: AppColors.primary)
                                  : const Text("No Sell Data found"),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.filterOfflineSellList.length,
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                              itemBuilder: (context, index) {
                                OfflineSellList data = state.filterOfflineSellList[index];
                                return CustomContainer(
                                  size: size,
                                  rad: 8,
                                  child: ExpansionTile(
                                    childrenPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            dualText(
                                                title: "Order Id: ",
                                                desc: data.offlineorderGeneratedid ?? "ORDERID",
                                                size: size),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Amount: ",
                                                  style: TextStyle(
                                                      fontSize: size.width * 0.034,
                                                      color: Colors.black.withOpacity(0.7)),
                                                ),
                                                if (data.offlineorderDiscountamt != "0")
                                                  Text(
                                                    "₹ ${data.offlineorderSubtotal}",
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.034,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.lineThrough,
                                                        color: Colors.black.withOpacity(0.4)),
                                                  ),
                                                if (data.offlineorderDiscountamt != "0") const SizedBox(width: 5),
                                                Text(
                                                  "₹ ${data.offlineorderTotalamt}.00",
                                                  style: TextStyle(
                                                      fontSize: size.width * 0.034,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black.withOpacity(0.8)),
                                                ),
                                              ],
                                            ),
                                            dualText(
                                                title: "Discount: ",
                                                desc: "${data.offlineorderDiscountid} %",
                                                size: size),
                                          ],
                                        ),
                                      ],
                                    ),
                                    tilePadding: EdgeInsets.zero,
                                    children: data.orderdetails!.map((datas) {
                                      double qty = double.parse(datas.offlinesaledetailsQty ?? "0");
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                width: size.width * 0.1,
                                                height: size.width * 0.1,
                                                imageUrl: "${AppConfig.apiUrl}${datas.offlinesaledetailsPPic ?? ""}",
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
                                                  dualText(
                                                      title: "Name: ",
                                                      textsize: size.width * 0.03,
                                                      desc: "${datas.offlinesaledetailsPName}",
                                                      size: size),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      dualText(
                                                          title: "Price: ",
                                                          textsize: size.width * 0.03,
                                                          desc: "₹ ${datas.offlinesaledetailsTotalamt}",
                                                          size: size),
                                                      dualText(
                                                          title: "Qty: ",
                                                          textsize: size.width * 0.03,
                                                          desc:
                                                              "${qty < 1 ? (qty * 1000).round() : qty.round()} ${qty < 1 ? "gm" : "Kg"}",
                                                          size: size),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ) /*CustomContainer(
                                  horPad: 12,
                                  vertPad: 12,
                                  size: size,
                                  boxShadow: AppColors.primary.withOpacity(0.3),
                                  rad: 8,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          width: size.width * 0.15,
                                          height: size.width * 0.15,
                                          imageUrl: "${AppConfig.apiUrl}${data.orderdetails ?? ""}",
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
                                            dualText(title: "Order ID: ", desc: "#${data.offlineorderId}", size: size),
                                            const SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                dualText(
                                                    title: "Price: ", desc: "₹ ${data.offlineorderDiscountamt}", size: size),
                                                dualText(title: "Qty: ", desc: data.offlineorderId ?? "", size: size),

                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            dualText(title: "Payment Type: ", desc: "Cash", size: size),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )*/
                                    ;
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
        state.filterOfflineSell(start: startDate!, end: endDate!);
        int diff = endDate!.difference(startDate!).inDays;
        log(endDate!.difference(startDate!).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }
}
