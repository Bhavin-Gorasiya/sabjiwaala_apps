import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:subjiwala/Widgets/loading.dart';
import 'package:subjiwala/models/review_model.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/app_dialogs.dart';
import '../../Widgets/custom_btn.dart';
import '../../Widgets/custom_textfield.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../models/order_place.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/helper.dart';
import 'orders_screen.dart';

class OrderDetails extends StatefulWidget {
  final MyOrder order;
  final bool isHistory;
  final bool isDelivered;
  final bool isPending;

  const OrderDetails({
    Key? key,
    this.isHistory = false,
    this.isPending = false,
    this.isDelivered = false,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController descController = TextEditingController();
  double ratings = 0.0;

  @override
  Widget build(BuildContext context) {
    int qty = 0;
    for (Orderdetail data in widget.order.orderdetails ?? []) {
      qty = qty + int.parse(data.orderdetailsQnty ?? "0");
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, right: 15, left: 10, bottom: 4),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const SizedBox(width: 5),
                Text(
                  "Order details",
                  style: GoogleFonts.poppins(fontSize: size.width * 0.045),
                )
              ],
            ),
          ),
          Container(width: size.width * 0.9, height: 2, color: Colors.black.withOpacity(0.1)),
          // CustomAppBar(size: size, title: "Order Detail"),
          Expanded(
            child: Consumer<CustomViewModel>(builder: (context, state, child) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: size.width * 0.05),
                      child: Column(
                        children: [
                          if (widget.isHistory)
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: widget.isDelivered ? AppColors.primary : AppColors.red)),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: widget.isDelivered ? AppColors.primary : AppColors.red,
                                    radius: size.width * 0.027,
                                    child: Icon(
                                      widget.isDelivered ? Icons.check : Icons.close,
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
                                    color: widget.isDelivered ? AppColors.primary : AppColors.red,
                                    text: widget.isDelivered
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
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    width: size.width * 0.15,
                                    height: size.width * 0.15,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        AppConfig.apiUrl + (widget.order.orderdetails!.first.orderdetailsPpic ?? ""),
                                    placeholder: (context, url) =>
                                        ImageLoader(width: size.width * 0.15, height: size.width * 0.15, radius: 10),
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
                                          desc: "${widget.order.orderdetails!.first.orderdetailsGeneratedid}",
                                          size: size),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          dualText(
                                              title: "Price: ", desc: "₹ ${widget.order.orderTotalamt}", size: size),
                                          dualText(title: "Qty: ", desc: qty.toString(), size: size),
                                        ],
                                      ),
                                      dualText(
                                          title: "Payment Type: ",
                                          desc: widget.order.orderPaymentStatus ?? "",
                                          size: size),
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
                            child: column(
                                title: "Vendor name",
                                name: widget.order.vendorName ?? "",
                                mobile: "+91 ${widget.order.vendorMobile}",
                                size: size),
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
                                  "Order Qty: 5",
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
                                  itemCount: widget.order.orderdetails!.length + 1,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index != widget.order.orderdetails!.length) {
                                      Orderdetail data = widget.order.orderdetails![index];
                                      return detailText(
                                          name: data.orderdetailsPname ?? "",
                                          weight: data.orderdetailsQnty ?? '',
                                          qty: data.orderdetailsQnty ?? '',
                                          size: size,
                                          price:
                                              "${int.parse(data.orderdetailsMrp ?? '0') * int.parse(data.orderdetailsQnty ?? "0")}/-");
                                    } else {
                                      int price = 0;
                                      int qty = 0;
                                      for (Orderdetail data in widget.order.orderdetails ?? []) {
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
                                            price: "50/-",
                                          ),
                                          detailText(
                                            name: "Additional Charge :",
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
                                            price: "${price + 60}/-",
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
                          if (widget.isDelivered)
                            GestureDetector(
                              onTap: () {},
                              child: CustomContainer(
                                size: size,
                                rad: 8,
                                child: Row(
                                  children: [
                                    const Icon(Icons.document_scanner, color: AppColors.primary),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Scan Product QR",
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (widget.isDelivered)
                            CustomContainer(
                              size: size,
                              rad: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Give Ratings :",
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      unratedColor: Colors.black26,
                                      glow: false,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: AppColors.primary,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          ratings = rating;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextField(
                                    maxLines: 3,
                                    maxLength: 2000,
                                    controller: descController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomBtn(
                                    size: size,
                                    title: "Send",
                                    onTap: () async {
                                      if (ratings != 0.0) {
                                        await state
                                            .addReview(ReviewModel(
                                                reviewCid: state.customerDetail.first.customerId ?? "",
                                                reviewDesc: descController.text,
                                                reviewPid: widget.order.orderID ?? "",
                                                reviewRating: ratings.toString(),
                                                reviewTag: "Subfr",
                                                reviewVid: widget.order.orderdetails!.first.orderdetailsSfrid ?? ''))
                                            .then((value) {
                                          if (value == "success") {
                                            pop(context);
                                            commonToast(context, "Thanks for your feedback!!",
                                                color: AppColors.primary);
                                          } else {
                                            commonToast(context, "Enable to send your feedback",
                                                color: AppColors.primary);
                                          }
                                        });
                                      } else {
                                        commonToast(context, "Please give at least one star", color: AppColors.primary);
                                      }
                                    },
                                    btnColor: ratings == 0.0 ? Colors.black38 : AppColors.primary,
                                    radius: 10,
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading) const Loading()
                ],
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom / 2 + 8,
                top: 8),
            child: CustomBtn(
                size: size,
                title: "Cancel Order",
                onTap: () {
                  CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                  popup(
                      size: size,
                      context: context,
                      title: "Are you sure want delete this order?",
                      onYesTap: () async {
                        await state.deleteOrder(widget.order.orderID ?? "");
                      });
                },
                btnColor: AppColors.red,
                radius: 10),
          )
        ],
      ),
    );
  }

  Widget column({required String title, required String name, required String mobile, required Size size}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.042,
                fontWeight: FontWeight.w600,
              ),
            ),
            text(size: size, text: name),
            text(size: size, text: mobile),
          ],
        ),
        if (!widget.isHistory) const SizedBox(height: 4),
        if (!widget.isHistory)
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              width: size.width * 0.3,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.primary)),
              child: textWithIcon(size: size, text: "Call now", icon: Icons.call_rounded, color: AppColors.primary),
            ),
          )
      ],
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

  const AssignDeliverySheet({Key? key, required this.size}) : super(key: key);

  @override
  State<AssignDeliverySheet> createState() => _AssignDeliverySheetState();
}

class _AssignDeliverySheetState extends State<AssignDeliverySheet> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height * 0.65,
      child: Column(
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
              itemCount: 2,
              padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
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
                        CircleAvatar(
                          radius: widget.size.width * 0.06,
                          child: Image.asset("assets/user.png"),
                        ),
                        SizedBox(width: widget.size.width * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Boy",
                              style: TextStyle(
                                fontSize: widget.size.width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: widget.size.width * 0.01),
                            Text(
                              "+91 5654644646",
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
          CustomBtn(
              size: widget.size,
              title: "Full fill order",
              onTap: () {
                popup(
                  size: widget.size,
                  context: context,
                  onYesTap: () {
                    pop(context);
                  },
                  title: "Are you sure want to Fulfill Order?",
                );
              },
              btnColor: AppColors.primary)
        ],
      ),
    );
  }
}

text(
    {required Size size,
    required String text,
    Color? color,
    FontWeight? fontWeight,
    double? textSize,
    double? width,
    double? vertPad,
    int? maxLines,
    TextDecoration? decoration,
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
          decoration: decoration,
          fontWeight: isTotal ? FontWeight.w600 : fontWeight,
        ),
      ),
    ),
  );
}
