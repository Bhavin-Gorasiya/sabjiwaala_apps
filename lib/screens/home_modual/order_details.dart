import 'package:delivery_app/helper/app_colors.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/screens/widgets/custom_appbar.dart';
import 'package:delivery_app/screens/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/navigations.dart';
import '../../provider/custom_view_model.dart';
import '../widgets/custom_widgets.dart';

class OrderDetails extends StatelessWidget {
  final bool isHistory;
  final bool isDelivered;
  final bool isPending;
  final OrderModel data;

  const OrderDetails({
    Key? key,
    this.isHistory = false,
    this.isPending = false,
    this.isDelivered = false,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int qty = 0;
    int price = 0;
    for (Product product in data.products!) {
      qty += int.parse(product.productsubQty ?? "");
      price += int.parse(product.productsubPrice ?? "");
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Order Detail"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: size.width * 0.05),
                      child: Column(
                        children: [
                          if (isHistory)
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: isDelivered ? AppColors.primary : AppColors.red)),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isDelivered ? AppColors.primary : AppColors.red,
                                    radius: size.width * 0.027,
                                    child: Icon(
                                      isDelivered ? Icons.check : Icons.close,
                                      size: size.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  text(
                                    width: size.width * 0.7,
                                    size: size,
                                    maxLines: 2,
                                    textSize: size.width * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: isDelivered ? AppColors.primary : AppColors.red,
                                    text: isDelivered
                                        ? "Order already Delivered"
                                        : "Order not "
                                            "Delivered due to some reason",
                                  )
                                ],
                              ),
                            ),
                          CustomContainer(
                            horPad: 12,
                            vertPad: 12,
                            size: size,
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
                                    dualText(title: "Price: ", desc: "₹ $price", size: size),
                                    dualText(title: "Payment Type: ", desc: data.orderPaymentStatus ?? "", size: size),
                                    if (!isHistory && data.orderPaymentStatus != "Success")
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.network("https://media-cldnry.s-nbcnews.com/image/upload"
                                                      "/t_fit-760w,f_auto,q_auto:best/MSNBC/Components"
                                                      "/Photo/_new/110322-qr-code-hmed-425p.jpg"),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.primary),
                                              borderRadius: BorderRadius.circular(10)),
                                          alignment: Alignment.center,
                                          height: 25,
                                          width: 100,
                                          child: const Text('Show Qr'),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          CustomContainer(
                            size: size,
                            rad: 8,
                            vertPad: 12,
                            horPad: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Delivery address:",
                                      style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                text(
                                    size: size,
                                    text: "${data.userDetails!.customerFirstname}"
                                        " ${data.userDetails!.customerLastname}"),
                                text(size: size, text: data.userDetails!.addressesAddress ?? "", maxLines: 2),
                                text(size: size, text: "${data.userDetails!.addressesLandmark}."),
                                if (isHistory) text(size: size, text: "+91 ${data.userDetails!.customerPhoneno}"),
                                if (!isHistory)
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: textWithIcon(
                                          size: size,
                                          text: "+91 ${data.userDetails!.customerPhoneno}",
                                          icon: Icons.call_rounded,
                                          color: AppColors.primary),
                                    ),
                                  ),
                                if (!isHistory) const SizedBox(height: 4),
                                if (!isHistory)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: size.width * 0.35,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(color: AppColors.primary)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "assets/customer_care.png",
                                                width: size.width * 0.04,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: size.width * 0.01),
                                              Text(
                                                "Customer Care",
                                                style:
                                                    TextStyle(fontSize: size.width * 0.035, color: AppColors.primary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          launch("https://www.google.com/maps/search/?api="
                                              "1&query=${data.userDetails!.addressesLat},${data.userDetails!.addressesLong}");
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: size.width * 0.35,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              AppColors.primary.withOpacity(0.6),
                                              AppColors.primary,
                                            ]),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: textWithIcon(
                                              size: size,
                                              text: "Direction",
                                              icon: Icons.location_pin,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          CustomContainer(
                            size: size,
                            rad: 8,
                            vertPad: 12,
                            horPad: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order Qty: ${data.products!.length}",
                                  style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5, bottom: 8),
                                  color: Colors.black,
                                  width: double.infinity,
                                  height: 0.5,
                                ),
                                detailText(
                                    name: "Name",
                                    weight: "Weight (Kg.)",
                                    qty: "Qty.",
                                    size: size,
                                    price: "Price (₹)",
                                    isTitle: true),
                                const SizedBox(height: 5),
                                ListView.builder(
                                  itemCount: data.products!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    Product product = data.products![index];
                                    return detailText(
                                        name: product.productsubName ?? "",
                                        weight: "${product.productsubWeight} ${product.productsubUnit}",
                                        qty: product.productsubQty ?? "",
                                        size: size,
                                        price: "${product.productsubPrice}/-");
                                  },
                                ),
                                /*Container(
                                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                                    color: Colors.black.withOpacity(0.2),
                                    width: double.infinity,
                                    height: 0.5,
                                  ),
                                  detailText(
                                    name: "Delivery Charge :",
                                    weight: "-",
                                    qty: "-",
                                    size: size,
                                    price: "50/-",
                                  ),
                                  detailText(
                                    name: "Additional Charge :",
                                    weight: "-",
                                    qty: "-",
                                    size: size,
                                    price: "10/-",
                                  ),*/
                                Container(
                                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                                  color: Colors.black,
                                  width: double.infinity,
                                  height: 0.5,
                                ),
                                detailText(
                                  name: "Total :-",
                                  weight: "",
                                  qty: "$qty",
                                  size: size,
                                  price:
                                      data.orderType == "Subscription" ? "$price/-" : "${data.orderSubtotal ?? ""}/-",
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading) const Loading()
                ],
              ),
            );
          }),
          if (!isHistory)
            Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    color: Colors.black,
                    width: double.infinity,
                    height: 0.5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            size: size,
                            text: "Total Amount",
                            vertPad: 0,
                            textSize: size.width * 0.05,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          text(
                            size: size,
                            text: data.orderType == "Subscription" ? "₹ $price/-" : "₹ ${data.orderSubtotal ?? ""}/-",
                            vertPad: 0,
                            textSize: size.width * 0.05,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (!isPending)
                        swipeBtm(
                            onSlide: () {
                              popup(
                                  size: size,
                                  context: context,
                                  onYesTap: () async {
                                    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                                    await state
                                        .changeStatus(
                                            id: data.orderId ?? "", status: "Completed", type: data.orderType ?? "")
                                        .then((value) {
                                      state.changeList("Out for Delivery");
                                      pop(context);
                                    });
                                  },
                                  title: "Are you sure want to Deliver items?");
                            },
                            text: "Swipe to Deliver Order",
                            size: size,
                            color: AppColors.primary),
                      if (!isPending)
                        swipeBtm(
                            onSlide: () {
                              popup(
                                  size: size,
                                  context: context,
                                  onYesTap: () async {
                                    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                                    await state
                                        .changeStatus(
                                            id: data.orderId ?? "", status: "Cancelled", type: data.orderType ?? "")
                                        .then((value) {
                                      state.changeList("Out for Delivery");
                                      pop(context);
                                    });
                                  },
                                  title: "Are you sure you won't able to Deliver items?");
                            },
                            text: "Order not Delivered",
                            size: size,
                            color: AppColors.red),
                      if (isPending)
                        swipeBtm(
                            onSlide: () async {
                              CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                              await state
                                  .changeStatus(
                                      id: data.orderId ?? "", status: "Out for Delivery", type: data.orderType ?? "")
                                  .then((value) {
                                state.changeList("Pending");
                                pop(context);
                              });
                            },
                            text: "Swipe to Out for Delivery",
                            size: size,
                            color: AppColors.primary),
                      SizedBox(height: MediaQuery.of(context).padding.bottom)
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget detailText({
    required String name,
    required String weight,
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
            width: size.width * 0.27,
            alignmentGeometry: Alignment.topLeft,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.25,
            text: weight,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.12,
            text: qty,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.18,
            text: price,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
      ],
    );
  }

  Widget text(
      {required Size size,
      required String text,
      Color? color,
      FontWeight? fontWeight,
      double? textSize,
      double? width,
      double? vertPad,
      int? maxLines,
      bool isTotal = false,
      AlignmentGeometry? alignmentGeometry}) {
    return Container(
      alignment: alignmentGeometry,
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vertPad ?? 1),
        child: Text(
          text,
          maxLines: maxLines ?? 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isTotal ? size.width * 0.038 : textSize ?? size.width * 0.035,
            color: color,
            fontWeight: isTotal ? FontWeight.w600 : fontWeight,
          ),
        ),
      ),
    );
  }

  Widget swipeBtm({required Function onSlide, required String text, required Size size, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(15)),
      child: HorizontalSlidableButton(
        height: 50,
        isRestart: true,
        initialPosition: SlidableButtonPosition.start,
        buttonWidth: 60.0,
        color: Colors.transparent,
        width: double.infinity,
        onChanged: (SlidableButtonPosition position) {
          if (position == SlidableButtonPosition.end) {
            onSlide();
          }
        },
        label: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          margin: const EdgeInsets.all(5),
          height: 50,
          width: 60,
          child: const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ),
    );
  }
}
