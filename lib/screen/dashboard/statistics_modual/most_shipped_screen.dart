import 'package:flutter/material.dart';

import '../../../helper/app_colors.dart';
import '../../widgets/custom_widgets.dart';

class MostShippedScreen extends StatefulWidget {
  const MostShippedScreen({Key? key}) : super(key: key);

  @override
  State<MostShippedScreen> createState() => _MostShippedScreenState();
}

class _MostShippedScreenState extends State<MostShippedScreen> {
  String selectedTab = "Today";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tabContainer(
                name: "Today",
                size: size,
                onTap: () {
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
                  detailText(
                    index: "No.",
                    name: "Item name",
                    qty: "Total Qty. (Kg.)",
                    price: "Total Revenue (₹)",
                    size: size,
                    isTitle: true,
                  ),
                  divideLine(size: size),
                  ListView.builder(
                    itemCount: fruits.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: detailText(
                            name: fruits[index],
                            qty: "${150 * (fruits.length - index)}",
                            price: "₹ ${500 * (fruits.length - index)}/-",
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
      ],
    );
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
            width: size.width * 0.07,
            alignmentGeometry: Alignment.topLeft,
            text: index,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            width: size.width * 0.25,
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
            width: size.width * 0.3,
            text: price,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
      ],
    );
  }
}
