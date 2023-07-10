import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/Widgets/payment_status_screens.dart';
import 'package:subjiwala/models/order_place.dart';
import 'package:subjiwala/utils/helper.dart';

import '../theme/colors.dart';
import 'loading.dart';

class PaymentPopup extends StatefulWidget {
  final bool isSubscription;
  final OrderPlace orderPlace;

  const PaymentPopup({Key? key, required this.isSubscription, required this.orderPlace}) : super(key: key);

  @override
  State<PaymentPopup> createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    razorpay.clear();
    super.dispose();
  }

  String payment = "";

  String date() {
    DateTime time = DateTime.now();
    if (time.hour >= 18) {
      DateTime newTime = time.add(const Duration(days: 1));
      return DateFormat("yyyy-MM-dd").format(newTime);
    } else {
      return DateFormat("yyyy-MM-dd").format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    // log("===>>> ${date()}");
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, _) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Options",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                  const SizedBox(height: 10),
                  container(name: "Cash on Delivery", grpValue: "COD", size: size),
                  container(name: "Online Payment", grpValue: "Online", size: size),
                  if (!widget.isSubscription) container(name: "Pickup from Vendor", grpValue: "Pickup", size: size),
                  if (!widget.isSubscription) container(name: "Call Vendor at your location", grpValue: "call", size: size),
                  SizedBox(height: widget.isSubscription ? 50 : 25),
                  CustomBtn(
                      size: size,
                      title: payment == "call" ? "Call Now" : "Proceed",
                      onTap: () async {
                        OrderPlace data = widget.orderPlace;
                        if (payment == "COD" || payment == "Pickup") {
                          await state
                              .orderPlace(OrderPlace(
                                  userId: data.userId,
                                  totalAmount: data.totalAmount,
                                  cartdata: data.cartdata,
                                  addressId: data.addressId,
                                  subTotal: data.subTotal,
                                  razorpayId: "",
                                  orderCoupanamt: "",
                                  orderCoupancode: "",
                                  orderSubfrid: data.orderSubfrid,
                                  orderCoupanid: data.orderCoupanid,
                                  orderCreateDate: date(),
                                  paystatus: payment))
                              .then((value) async {
                            if (value == "success") {
                              await state.deleteAllCart(customerID: data.userId ?? '0').then((value) {
                                pop(context);
                                push(context, const PaymentSuccess());
                              });
                            } else {
                              pop(context);
                              push(context, const PaymentFailed());
                            }
                          });
                        } else if (payment == "Online") {
                          _openCheckout(state.customerDetail.first.customerPhoneno ?? "",
                              state.customerDetail.first.customerEmail ?? "", int.parse(data.totalAmount ?? "0"));
                        } else {

                        }
                      },
                      btnColor: AppColors.primary,
                      radius: 10),
                  SizedBox(height: MediaQuery.of(context).padding.bottom)
                ],
              ),
            ),
          ),
          if (state.isOrder) const Loading()
        ],
      );
    });
  }

  Widget container({required String name, required String grpValue, required Size size}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          payment = grpValue;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: payment == grpValue ? AppColors.primary : Colors.black54),
        ),
        child: Row(
          children: [
            Radio(
              value: payment,
              groupValue: grpValue,
              onChanged: (_) {
                setState(() {
                  payment = grpValue;
                });
              },
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: payment == grpValue ? FontWeight.w600 : FontWeight.w500,
                color: payment == grpValue ? AppColors.primary : Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _onSuccess(PaymentSuccessResponse response) async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    OrderPlace data = widget.orderPlace;
    await state
        .orderPlace(OrderPlace(
            userId: data.userId,
            totalAmount: data.totalAmount,
            cartdata: data.cartdata,
            addressId: data.addressId,
            subTotal: data.subTotal,
            razorpayId: response.paymentId,
            orderCoupanid: data.orderCoupanid,
            orderCoupancode: "",
            orderCoupanamt: "",
            orderSubfrid: data.orderSubfrid,
            orderCreateDate: date(),
            paystatus: payment))
        .then((value) async {
      if (value == "success") {
        await state.deleteAllCart(customerID: data.userId ?? '0').then((value) {
          pop(context);
          push(context, const PaymentSuccess());
        });
      } else {
        pop(context);
        push(context, const PaymentFailed());
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
}
