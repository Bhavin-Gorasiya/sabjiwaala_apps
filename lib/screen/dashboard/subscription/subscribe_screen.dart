import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../helper/app_colors.dart';
import '../../../helper/app_config.dart';
import '../../../models/order_model.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/image_loader.dart';

class SubscribeScreen extends StatefulWidget {
  final bool isWeek;
  final VendorSubscription data;

  const SubscribeScreen({Key? key, required this.isWeek, required this.data}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {

  int qty = 1;
  String pick = "Daily";
  String addressId = "";
  int selectedIndex = 0;
  TextEditingController coupon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<CustomViewModel>(builder: (context, state, child) {
        return Column(
          children: [
            CustomAppBar(title: "Subscription", size: size),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.045, vertical: 1),
                child:
                    widget.isWeek ? weekly(size: size, data: widget.data) : monthly(size: size, data: widget.data),
              ),
            ),
          ],
        );
      }),
    );
  }

  pickSchedule({required Size size, required String name}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          pick = name;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10, bottom: 15, right: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: pick == name ? AppColors.primary : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: pick == name ? AppColors.primary : Colors.black54)),
        child: Text(
          name,
          style: TextStyle(
              fontSize: size.width * 0.035,
              color: pick == name ? Colors.white : Colors.black,
              fontWeight: pick == name ? FontWeight.w600 : null),
        ),
      ),
    );
  }

  monthly({required Size size, required VendorSubscription data}) {
    String htmlText = data.subscriptionproductPdesc ?? "";

    /// sanitize or query document here
    Widget html = Html(
      data: htmlText,
    );

    int dayTotal = 0;
    for (MonthProduct product in data.monthProducts!) {
      dayTotal += int.parse("${product.productsubPrice}");
    }

    int discount =
    (((int.parse(data.subscriptionproductPrice ?? "") - int.parse(data.subscriptionproductDprice ?? "")) /
        int.parse(data.subscriptionproductPrice ?? "")) *
        100)
        .toInt();
    return Column(
      children: [
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  // color: isLow ? Colors.black12 : null,
                  height: size.width * 0.2,
                  width: size.width * 0.2,
                  imageUrl: AppConfig.apiUrl + (data.subscriptionproductPpic ?? ""),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/sabjiwaala.jpeg",
                    fit: BoxFit.cover,
                  ),
                  placeholder: (context, url) =>
                      ImageLoader(height: size.width * 0.2, width: size.width * 0.2, radius: 10),
                ),
              ),
              SizedBox(width: size.width < 350 ? size.width * 0.01 : 10),
              SizedBox(
                width: size.width * 0.58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.subscriptionproductPname ?? "",
                      style: TextStyle(
                        fontSize: size.width * 0.036,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data.subscriptionproductSdesc ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: size.width * 0.03,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹ ${data.subscriptionproductPrice}/Month",
                      style: TextStyle(
                          fontSize: size.width * 0.033, color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: TextStyle(
                  fontSize: size.width * 0.038,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              html,
            ],
          ),
        ),
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Details",
                style: TextStyle(
                  fontSize: size.width * 0.038,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              detailText(index: "No.", name: "Item Name", qty: "Qty", price: "Price", size: size, isTitle: true),
              ListView.builder(
                itemCount: data.monthProducts!.length + 1,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index != data.monthProducts!.length) {
                    MonthProduct product = data.monthProducts![index];
                    return detailText(
                        name: product.productsubName ?? "",
                        qty: "${product.productsubWeight}",
                        price: "₹ ${product.productsubPrice}/-",
                        size: size,
                        index: '${index + 1}');
                  } else {
                    return Column(
                      children: [
                        Container(
                          color: Colors.black12,
                          height: 1,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                        ),
                        detailText(
                            index: "",
                            name: "Day Total :",
                            qty: "",
                            price: "₹ $dayTotal /-",
                            size: size,
                            isTitle: true),
                        detailText(
                            index: "",
                            name: "",
                            qty: "30 x ",
                            price: "₹ ${data.subscriptionproductPrice} /-",
                            size: size,
                            isTitle: true,
                            isLineThrew: true),
                        detailText(
                            index: "",
                            name: "Total :",
                            qty: "- 10%",
                            price: "₹ ${data.subscriptionproductDprice} /-",
                            size: size,
                            isTotal: true,
                            isDiscount: true),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ],
    );
  }

  weekly({required Size size, required VendorSubscription data}) {
    String htmlText = data.subscriptionproductPdesc ?? "";

    /// sanitize or query document here
    Widget html = Html(
      data: htmlText,
    );

    int discount =
    (((int.parse(data.subscriptionproductPrice ?? "") - int.parse(data.subscriptionproductDprice ?? "")) /
        int.parse(data.subscriptionproductPrice ?? "")) *
        100)
        .toInt();

    return Column(
      children: [
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  // color: isLow ? Colors.black12 : null,
                  height: size.width * 0.15,
                  width: size.width * 0.15,
                  imageUrl: AppConfig.apiUrl + (data.subscriptionproductPpic ?? ""),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/sabjiwaala.jpeg",
                    fit: BoxFit.cover,
                  ),
                  placeholder: (context, url) =>
                      ImageLoader(height: size.width * 0.2, width: size.width * 0.2, radius: 10),
                ),
              ),
              SizedBox(width: size.width < 350 ? size.width * 0.01 : 10),
              SizedBox(
                width: size.width * 0.58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.subscriptionproductPname ?? "",
                      style: TextStyle(
                        fontSize: size.width * 0.036,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subscriptionproductSdesc ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: size.width * 0.03,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹ ${data.subscriptionproductPrice}/Month",
                              style: TextStyle(
                                  fontSize: size.width * 0.033, color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: TextStyle(
                  fontSize: size.width * 0.038,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              html,
              const SizedBox(height: 5),
            ],
          ),
        ),
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Details",
                style: TextStyle(
                  fontSize: size.width * 0.038,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              detailText(index: "Day", name: "Item Name", qty: "Qty", price: "Price", size: size, isTitle: true),
              ListView.builder(
                itemCount: data.weekProducts!.length + 1,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index != weekSubji.length) {
                    return ListView.builder(
                      itemCount: data.weekProducts![index].productdetails!.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 5),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, second) {
                        Productdetail product = data.weekProducts![index].productdetails![second];
                        return detailText(
                            name: product.productsubName ?? "",
                            qty: "${product.productsubWeight}",
                            price: "₹ ${product.productsubPrice}/-",
                            size: size,
                            index: second == 0 ? data.weekProducts![index].productsubDay!.substring(0, 3) : "");
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          color: Colors.black12,
                          height: 1,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                        ),
                        detailText(
                            index: "",
                            name: "Month Total :",
                            qty: "",
                            price: "₹ ${data.subscriptionproductPrice} /-",
                            size: size,
                            isTitle: true),
                        detailText(
                            index: "",
                            name: "Total :",
                            qty: "- $discount%",
                            price: "₹ ${data.subscriptionproductDprice} /-",
                            size: size,
                            isTotal: true,
                            isDiscount: true),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom)
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
    bool isLineThrew = false,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
            width: widget.isWeek ? size.width * 0.11 : size.width * 0.08,
            alignmentGeometry: Alignment.center,
            text: index,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            width: widget.isWeek ? size.width * 0.26 : size.width * 0.3,
            alignmentGeometry: Alignment.topLeft,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.2,
            text: qty,
            size: size,
            isTotal: isTotal,
            color: isTitle
                ? Colors.black.withOpacity(0.7)
                : isDiscount
                    ? AppColors.primary
                    : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.23,
            text: price,
            size: size,
            isTotal: isTotal,
            decoration: isLineThrew ? TextDecoration.lineThrough : null,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
      ],
    );
  }
}

List<List<Map<String, dynamic>>> weekSubji = [
  [
    {
      "name": "Onion",
      "day": "Mon",
      "Price": 15,
      "Qty": 250,
    },
    {
      "name": "Lasan",
      "day": "Mon",
      "Price": 10,
      "Qty": 250,
    }
  ],
  [
    {
      "name": "Dhaniya",
      "day": "Tue",
      "Price": 20,
      "Qty": 100,
    },
    {
      "name": "Lasan",
      "day": "Tue",
      "Price": "10",
      "Qty": "250",
    }
  ],
  [
    {
      "name": "Dhaniya",
      "day": "Wed",
      "Price": 20,
      "Qty": 100,
    },
    {
      "name": "Palak",
      "day": "Wed",
      "Price": 15,
      "Qty": 150,
    },
  ],
  [
    {
      "name": "Kobi",
      "day": "Thu",
      "Price": 20,
      "Qty": 500,
    },
    {
      "name": "Palak",
      "day": "Thu",
      "Price": 15,
      "Qty": 150,
    },
  ],
  [
    {
      "name": "Kobi",
      "day": "Fri",
      "Price": 20,
      "Qty": 500,
    },
    {
      "name": "Onion",
      "day": "Fri",
      "Price": 15,
      "Qty": 250,
    },
  ],
  [
    {
      "name": "Onion",
      "day": "Sat",
      "Price": 15,
      "Qty": 250,
    },
    {
      "name": "Lasan",
      "day": "Sat",
      "Price": 10,
      "Qty": 250,
    }
  ],
  [
    {
      "name": "Dhaniya",
      "day": "Sun",
      "Price": 20,
      "Qty": 100,
    },
    {
      "name": "Lasan",
      "day": "Sun",
      "Price": "10",
      "Qty": "250",
    }
  ],
];
