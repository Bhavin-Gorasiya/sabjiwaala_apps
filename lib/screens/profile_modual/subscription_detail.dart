import 'package:flutter/material.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/utils/helper.dart';

import '../../Widgets/payment_popup.dart';
import '../../theme/colors.dart';

class SubscriptionPlan extends StatelessWidget {
  final bool isRecommend;
  final String plan;

  const SubscriptionPlan({Key? key, this.isRecommend = false, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  backBtn(size: size, context: context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Plan Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.075,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isRecommend)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                          child: const Text(
                            "Recommend",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                    ],
                  ),
                  Text(
                    plan,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 15),
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            desc(name: "Dhaniya", qty: "200", price: "10", size: size, index: 1),
                            desc(name: "Fulawar", qty: "200", price: "15", size: size, index: 2),
                            desc(name: "Kobi", qty: "200", price: "30", size: size, index: 3),
                            desc(name: "Onion", qty: "200", price: "25", size: size, index: 4),
                            desc(name: "Lasan", qty: "200", price: "20", size: size, index: 5),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          title(title: "Name", width: size.width * 0.065, size: size),
                          title(title: "Qty (g.)", width: size.width * 0.18, size: size),
                          title(title: "Price / 250g", width: size.width < 360 ? size.width * 0.02 : size.width * 0.05, size: size),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 30,
                        child: Row(
                          children: [
                            title(title: "Total ( per day ) :", width: size.width * 0.05, size: size),
                            title(title: "₹ 100/-", width: size.width * 0.0, size: size),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 15),
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        rowText(
                          title: "Total amount per month :",
                          price: "₹ 3000 /-",
                          size: size,
                          isLine: true,
                        ),
                        rowText(
                          title: "Benefits from Plan :",
                          price: "₹ 800 /-",
                          size: size,
                        ),
                        Container(
                          height: 1,
                          width: size.width,
                          color: Colors.white60,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                        ),
                        rowText(
                          title: "You need to pay only :",
                          price: "₹ 2200 /-",
                          size: size,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "* From this plan you save Money & Time",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: size.height * 0.1),
                  CustomBtn(
                    size: size,
                    title: "Active Now",
                    onTap: () {
                      pop(context);/*showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        builder: (context) {
                          return const PaymentPopup(isSubscription: true);
                        },
                      );*/
                    },
                    radius: 10,
                    btnColor: Colors.black38,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget title({required String title, required double width, required Size size}) {
    return Padding(
      padding: EdgeInsets.only(left: width),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primary),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.034,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget desc({
    required String name,
    required String qty,
    required String price,
    required Size size,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$index.  ",
            style: TextStyle(
              fontSize: size.width * 0.038,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: size.width * 0.28,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: size.width * 0.038,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.23,
            child: Text(
              "$qty gram",
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.25,
            child: Text(
              price,
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowText({
    required String title,
    required String price,
    required Size size,
    bool isLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.04,
            ),
          ),
          Text(
            price,
            style: TextStyle(
                color: Colors.white,
                fontWeight: isLine ? FontWeight.w400 : FontWeight.w600,
                fontSize: size.width * 0.042,
                decoration: isLine ? TextDecoration.lineThrough : TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
