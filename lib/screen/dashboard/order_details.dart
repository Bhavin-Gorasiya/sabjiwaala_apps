import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:sub_franchisee/helper/navigations.dart';
import 'package:sub_franchisee/models/delivery_model.dart';
import 'package:sub_franchisee/models/order_model.dart';
import 'package:sub_franchisee/screen/widgets/custom_btn.dart';
import 'package:sub_franchisee/screen/widgets/loading.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_config.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_widgets.dart';

class OrderDetails extends StatelessWidget {
  final bool isHistory;
  final bool isDelivered;
  final bool isHistoryScreen;
  final OrderModel data;

  const OrderDetails({
    Key? key,
    this.isHistory = false,
    this.isHistoryScreen = false,
    this.isDelivered = false,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<CustomViewModel>(builder: (context, state, child) {
        int price = 0;
        int qty = 0;
        for (Orderdetail order in isHistoryScreen ? data.detailsPrevious! : data.detailsToday!) {
          price += int.parse(order.orderdetailsMrp ?? "0");
          qty += int.parse(order.orderdetailsQnty ?? "0");
        }
        return Column(
          children: [
            CustomAppBar(size: size, title: "Order Detail"),
            Expanded(
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    width: size.width * 0.15,
                                    height: size.width * 0.15,
                                    imageUrl: "${AppConfig.apiUrl}"
                                        "${isHistoryScreen ? data.detailsPrevious!.first.orderdetailsPpic : data.detailsToday!.first.orderdetailsPpic ?? ""}",
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          dualText(title: "Price: ", desc: "₹ $price", size: size),
                                          dualText(title: "Qty: ", desc: "$qty", size: size),
                                        ],
                                      ),
                                      dualText(
                                          title: "Payment Type: ", desc: data.orderPaymentStatus ?? "COD", size: size),
                                    ],
                                  ),
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
                                    text:
                                        "${data.userDetails!.first.customerFirstname} ${data.userDetails!.first.customerLastname}"),
                                text(size: size, text: data.userAddress!.first.addressesAddress ?? "", maxLines: 2),
                                text(size: size, text: "${data.userAddress!.first.addressesLandmark}."),
                                text(size: size, text: "+91 ${data.userDetails!.first.customerPhoneno}"),
                                if (!isHistory) const SizedBox(height: 4),
                                if (!isHistory)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          alignment: Alignment.center,
                                          width: size.width * state.userPercentage,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(color: AppColors.primary)),
                                          child: textWithIcon(
                                              size: size,
                                              text: "Call now",
                                              icon: Icons.call_rounded,
                                              color: AppColors.primary),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // launch("https://www.google.com/maps/search/?api=1&query=18.5564731,73.8915384");
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          alignment: Alignment.center,
                                          width: size.width * state.userPercentage,
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
                                  "Order Qty: ${data.orderSubtotal}",
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
                                  shrinkWrap: true,
                                  itemCount:
                                      (isHistoryScreen ? data.detailsPrevious!.length : data.detailsToday!.length) + 1,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index !=
                                        (isHistoryScreen ? data.detailsPrevious!.length : data.detailsToday!.length)) {
                                      Orderdetail order =
                                          (isHistoryScreen ? data.detailsPrevious![index] : data.detailsToday![index]);
                                      return detailText(
                                          name: order.orderdetailsPname ?? "",
                                          weight: order.orderdetailsMrp ?? '',
                                          qty: order.orderdetailsQnty ?? '',
                                          size: size,
                                          price:
                                              "${int.parse(order.orderdetailsMrp ?? '0') * int.parse(order.orderdetailsQnty ?? "0")}/-");
                                    } else {
                                      int price = 0;
                                      int qty = 0;
                                      for (Orderdetail data
                                          in (isHistoryScreen ? data.detailsPrevious : data.detailsToday) ?? []) {
                                        price = price +
                                            (int.parse(data.orderdetailsMrp ?? '0') *
                                                int.parse(data.orderdetailsQnty ?? "0"));
                                        qty = qty + int.parse(data.orderdetailsQnty ?? "0");
                                      }
                                      return Column(
                                        children: [
                                          Container(
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
                                            price: "10/-",
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                                            color: Colors.black,
                                            width: double.infinity,
                                            height: 0.5,
                                          ),
                                          detailText(
                                            name: "Total :-",
                                            weight: "-",
                                            qty: qty.toString(),
                                            size: size,
                                            price: "${price + 10}/-",
                                            isTotal: true,
                                          ),
                                        ],
                                      );
                                    }
                                  },
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
            ),
            if (!isHistory)
              if (data.orderDeliveryboyid == "")
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  child: Column(
                    children: [
                      swipeBtm(
                          onSlide: () {
                            popup(
                              size: size,
                              context: context,
                              onYesTap: () async {
                                pop(context);
                                await state.cancelledOrder(data.orderID ?? "0");
                              },
                              title: "Are you sure want to Cancel Order?",
                              isBack: true,
                            );
                          },
                          text: "Cancel Order",
                          size: size,
                          color: AppColors.red),
                      swipeBtm(
                          onSlide: () {
                            if (data.orderPaymentStatus == "Pickup") {
                              popup(
                                size: size,
                                context: context,
                                onYesTap: () async {
                                  pop(context);
                                  await state.cancelledOrder(data.orderID ?? "0", status: "Completed");
                                },
                                title: "Are you sure want to Completed Order?",
                                isBack: true,
                              );
                            } else {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return AssignDeliverySheet(
                                    size: size,
                                    onTap: (String id) async  {
                                      if (id != "0") {
                                        await state.assignOrder(orderID: data.orderID ?? "0", deliveryId: id);
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          },
                          text: data.orderPaymentStatus == "Pickup" ? "Completed Order" : "Fulfill Order",
                          size: size,
                          color: AppColors.primary),
                    ],
                  ),
                )
          ],
        );
      }),
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

  Widget swipeBtm({required Function onSlide, required String text, required Size size, required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.05),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(15)),
      child: HorizontalSlidableButton(
        height: 45,
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

class AssignDeliverySheet extends StatefulWidget {
  final Size size;
  final String? btnTitle;
  final String? popupTitle;
  final Function(String id) onTap;

  const AssignDeliverySheet({Key? key, required this.size, this.btnTitle, this.popupTitle, required this.onTap})
      : super(key: key);

  @override
  State<AssignDeliverySheet> createState() => _AssignDeliverySheetState();
}

class _AssignDeliverySheetState extends State<AssignDeliverySheet> {
  int selectedIndex = -1;
  String boyId = '0';

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return SizedBox(
        height: widget.size.height * 0.65,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05, vertical: 15),
                  child: Text(
                    "Select Delivery boy",
                    style: TextStyle(fontSize: widget.size.width * 0.05, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.deliveryBoyList.length,
                    padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05),
                    itemBuilder: (context, index) {
                      DeliveryModel data = state.deliveryBoyList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            boyId = data.deliverypersonId ?? "0";
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.03, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: selectedIndex == index ? AppColors.primary.withOpacity(0.4) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: widget.size.width * 0.12,
                                height: widget.size.width * 0.12,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: data.deliverypersonPic == null || data.deliverypersonPic == ""
                                      ? const SizedBox()
                                      : CachedNetworkImage(
                                          imageUrl: "${AppConfig.apiUrl}${data.deliverypersonPic ?? ""}",
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Image(image: AssetImage("assets/user.png")),
                                        ),
                                ),
                              ),
                              SizedBox(width: widget.size.width * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data.deliverypersonFname} ${data.deliverypersonLname}",
                                    style: TextStyle(
                                      fontSize: widget.size.width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: widget.size.width * 0.01),
                                  Text(
                                    "+91 ${data.deliverypersonMobileno1}",
                                    style: TextStyle(
                                        fontSize: widget.size.width * 0.03,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom / 2 + 10, left: 15, right: 10, top: 10),
                  child: CustomBtn(
                      radius: 10,
                      size: widget.size,
                      title: widget.btnTitle ?? "Full fill order",
                      onTap: () {
                        popup(
                            size: widget.size,
                            context: context,
                            onYesTap: () {
                              widget.onTap(boyId);
                              pop(context);
                            },
                            title: widget.popupTitle ?? "Are you sure want to Fulfill Order?",
                            desc: "Delivery boy : "
                                "${state.deliveryBoyList.where((e) => e.deliverypersonId == boyId).first.deliverypersonFname} "
                                "${state.deliveryBoyList.where((e) => e.deliverypersonId == boyId).first.deliverypersonLname}");
                      },
                      btnColor: boyId == '0' ? Colors.grey : AppColors.primary),
                )
              ],
            ),
            if (state.isLoading) const Loading()
          ],
        ),
      );
    });
  }
}
