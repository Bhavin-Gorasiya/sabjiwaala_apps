import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/app_colors.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_widgets.dart';

class RevenueGeneratedScreen extends StatefulWidget {
  final bool isOnline;

  const RevenueGeneratedScreen({Key? key, this.isOnline = false}) : super(key: key);

  @override
  State<RevenueGeneratedScreen> createState() => _RevenueGeneratedScreenState();
}

class _RevenueGeneratedScreenState extends State<RevenueGeneratedScreen> {
  String selectedTab = "Today";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tabContainer(
                  name: "Today",
                  size: size,
                  onTap: () {
                    state.filterStatsList("Today");
                    setState(() {
                      selectedTab = "Today";
                    });
                  },
                  width: size.width / 4.1,
                  isSelect: selectedTab == "Today",
                  btnColor: AppColors.primary),
              tabContainer(
                  name: "Weekly",
                  size: size,
                  onTap: () {
                    state.filterStatsList("Weekly");
                    setState(() {
                      selectedTab = "Weekly";
                    });
                  },
                  width: size.width / 4.1,
                  isSelect: selectedTab == "Weekly",
                  btnColor: AppColors.primary),
              tabContainer(
                  name: "Monthly",
                  size: size,
                  onTap: () {
                    state.filterStatsList("Monthly");
                    setState(() {
                      selectedTab = "Monthly";
                    });
                  },
                  width: size.width / 4.1,
                  isSelect: selectedTab == "Monthly",
                  btnColor: AppColors.primary),
              tabContainer(
                  name: "Yearly",
                  size: size,
                  onTap: () {
                    state.filterStatsList("Yearly");
                    setState(() {
                      selectedTab = "Yearly";
                    });
                  },
                  width: size.width / 4.1,
                  isSelect: selectedTab == "Yearly",
                  btnColor: AppColors.primary),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                child: Column(
                  children: [
                    if (widget.isOnline
                        ? state.filterOnlineSellStats.isNotEmpty
                        : state.filterOfflineSellStats.isNotEmpty)
                      detailText(
                        index: "No.",
                        name: "Item name",
                        qty: "Sold Qty.",
                        price: "Revenue",
                        size: size,
                        isTitle: true,
                      ),
                    if (widget.isOnline
                        ? state.filterOnlineSellStats.isNotEmpty
                        : state.filterOfflineSellStats.isNotEmpty)
                      divideLine(size: size),
                    if (widget.isOnline ? state.filterOnlineSellStats.isEmpty : state.filterOfflineSellStats.isEmpty)
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: size.width,
                          child: const Text("No Data found"),
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount:
                            widget.isOnline ? state.filterOnlineSellStats.length : state.filterOfflineSellStats.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          dynamic data = widget.isOnline
                              ? state.filterOnlineSellStats[index]
                              : state.filterOfflineSellStats[index];
                          double qty = double.parse(data.totalQty);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: detailText(
                                name: widget.isOnline ? data.orderdetailsPname : data.offlinesalePName,
                                qty: "${qty < 1 ? (qty * 1000).round() : qty} ${qty < 1 ? "gm" : "Kg"}",
                                price: "₹ ${(int.parse(data.totalAmt) * state.userPercentage).toInt()}/-",
                                size: size,
                                index: '${index + 1}'),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 15,
              top: 15,
              left: size.width * 0.05,
              right: size.width * 0.05,
            ),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Total Quantity",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white60.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      "${widget.isOnline ? state.onlineQty : state.offlineQty} Kg.",
                      style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Total revenue",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white60.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      "₹ ${widget.isOnline ? state.onlineRevenue : state.offlineRevenue}",
                      style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget detailText({
    required String index,
    required String name,
    required String qty,
    required String price,
    required Size size,
    bool isTitle = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
            width: size.width * 0.08,
            alignmentGeometry: Alignment.topLeft,
            text: index,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            width: size.width * 0.3,
            alignmentGeometry: Alignment.topLeft,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.25,
            text: qty,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.23,
            text: price,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
      ],
    );
  }
}
