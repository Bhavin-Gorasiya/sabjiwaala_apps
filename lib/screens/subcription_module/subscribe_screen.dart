import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/Widgets/loading.dart';
import 'package:subjiwala/screens/sign_up_modual/signup_screen.dart';
import 'package:subjiwala/screens/subcription_module/subcribe_success_screen.dart';
import 'package:subjiwala/utils/app_config.dart';
import '../../View Models/CustomViewModel.dart';
import '../../Widgets/payment_status_screens.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../models/subscription_model.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';
import '../dash_board/order_details.dart';
import '../profile_modual/add_address.dart';

class SubscribeScreen extends StatefulWidget {
  final bool isWeek;
  final VendorSubscription data;

  const SubscribeScreen({Key? key, required this.isWeek, required this.data}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    });
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getAddress();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    razorpay.clear();
    super.dispose();
  }

  getAddress() async {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    if (state.uid != "") {
      await state.getAddress();
    addressId = state.addressList.first.addressesId;
    }
  }

  DateTime start = DateTime.now().add(const Duration(days: 1));
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
            appBar(context: context, title: "Subscription", size: size),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.045, vertical: 1),
                    child:
                        widget.isWeek ? weekly(size: size, data: widget.data) : monthly(size: size, data: widget.data),
                  ),
                  if (state.isSubscription) const Loading()
                ],
              ),
            ),
            if (state.uid != "")
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return addressPopup(state: state, size: size);
                    },
                  );
                },
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12)),
                  child: Row(
                    children: [
                      Icon(state.addressList.isEmpty ? Icons.add : Icons.home_rounded, color: Colors.black54),
                      const SizedBox(width: 10),
                      state.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            )
                          : state.addressList.isEmpty
                              ? Text(
                                  "Add Address",
                                  style: GoogleFonts.poppins(fontSize: size.width * 0.038),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Delivery Address",
                                      style: GoogleFonts.poppins(fontSize: size.width * 0.03, color: Colors.black54),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        state.addressList[selectedIndex].addressesAddress,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.03,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54, size: 16)
                    ],
                  ),
                ),
              ),
            if (state.uid != "")
              GestureDetector(
                onTap: () async {
                  _openCheckout(
                      state.customerDetail.first.customerPhoneno ?? "",
                      state.customerDetail.first.customerEmail ?? "",
                      int.parse(widget.data.subscriptionproductPrice ?? "0"));
                },
                child: Container(
                  width: size.width,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: 10),
                  color: AppColors.primary,
                  child: Column(
                    children: [
                      Text(
                        "Start Subscription",
                        style:
                            TextStyle(fontSize: size.width * 0.042, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        DateFormat('E, MMM d y').format(start),
                        style: TextStyle(fontSize: size.width * 0.03, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 10,
                    bottom: MediaQuery.of(context).padding.bottom / 2 + 10),
                child: CustomBtn(
                    radius: 10,
                    size: size,
                    title: "Login",
                    btnColor: AppColors.red,
                    onTap: () {
                      push(context, const SignUpScreen());
                    }),
              )
          ],
        );
      }),
    );
  }

  addressPopup({required CustomViewModel state, required Size size}) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 15, top: 10),
      child: Column(
        children: [
          state.addressList.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  width: size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "No address found!!",
                    style: GoogleFonts.poppins(fontSize: size.width * 0.042),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.addressList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          addressId = state.addressList[index].addressesId;
                        });
                        pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width < 350 ? size.width * 0.01 : 15, vertical: 10),
                        margin: const EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: size.width * 0.03,
                              backgroundColor: Colors.black.withOpacity(0.1),
                              child: CircleAvatar(
                                radius: size.width * 0.017,
                                backgroundColor:
                                    selectedIndex == index ? AppColors.primary : Colors.black.withOpacity(0.1),
                              ),
                            ),
                            SizedBox(width: size.width < 350 ? size.width * 0.01 : 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.65,
                                  child: Text(
                                    state.addressList[index].addressesAddress,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        GoogleFonts.poppins(fontSize: size.width * 0.038, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  "Pin code: ${state.addressList[index].addressesLandmark}.",
                                  style: GoogleFonts.poppins(fontSize: size.width * 0.032, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              pop(context);
              push(context, const EditAddress(tag: "", landmark: "", address: "", addressID: ""));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: size.width * 0.03,
                    backgroundColor: Colors.black.withOpacity(0.1),
                    child: Icon(Icons.add, size: size.width * 0.05, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Add new address",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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
          style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(
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
                "Pick schedule",
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.038,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  pickSchedule(size: size, name: "Daily"),
                  // pickSchedule(size: size, name: "Alternative Day"),
                ],
              ),
              Container(width: size.width, height: 1, color: Colors.black26, margin: const EdgeInsets.only(bottom: 10)),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now().add(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 365)))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        start = value;
                      });
                    }
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.black54),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subscription start date",
                            style: GoogleFonts.poppins(fontSize: size.width * 0.03, color: Colors.black54),
                          ),
                          Text(
                            DateFormat('E, MMM d y').format(start),
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.03,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)
                    ],
                  ),
                ),
              ),
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
                style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
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
          child: GestureDetector(
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    start = value;
                  });
                }
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.black54),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subscription start date",
                        style: GoogleFonts.poppins(fontSize: size.width * 0.03, color: Colors.black54),
                      ),
                      Text(
                        DateFormat('E, MMM d y').format(start),
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.03,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54)
                ],
              ),
            ),
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
                style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
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
      ],
    );
  }

  Future _onSuccess(PaymentSuccessResponse response) async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    AddSubscriptionModel data = AddSubscriptionModel(
      userID: state.customerDetail.first.customerId ?? "1",
      addressID: addressId,
      orderSubfrid: widget.data.sassignSFid,
      subTotal: widget.data.subscriptionproductDprice ?? "0",
      totalAmount: widget.data.subscriptionproductPrice ?? "0",
      razorpayId: response.paymentId ?? "",
      orderFlag: widget.data.subscriptionPtype ?? "",
      productID: widget.data.subscriptionproductId ?? "",
      startDate: DateFormat('yyyy-MM-dd').format(start),
    );
    await state.placeSubscription(data).then((value) async {
      if (value == "success") {
        log("===>>>>> $value");
        push(context, SubscribeSuccess(date: DateFormat('E, MMM d y').format(start)));
      } else {
        commonToast(context, "Enable to create your subscription", color: AppColors.red);
      }
    });
  }

  Future _onExternalWallet(ExternalWalletResponse response) async {
    log("===>>>> razor pay status external wallet ${response.walletName}");
  }

  Future _onError(PaymentFailureResponse response) async {
    pop(context);
    push(context, const PaymentFailed());
    log("===>>>> razor pay status on error ${response.message}");
  }

  void _openCheckout(String phone, String email, int amount) {
    var tempAmount = (100 * (amount)).toStringAsFixed(0);

    final options = {
      'key': "rzp_test_YC8LrKeoPMI8k9",
      'amount': int.parse(tempAmount),
      'name': 'Sabjiwaala',
      'description': 'Booking from app',
      'prefill': {'contact': phone, 'email': email}
    };
    try {
      razorpay.open(options);
    } catch (e, s) {
      log("==>>> ${s.toString()}");
      throw Exception(e);
    }
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
