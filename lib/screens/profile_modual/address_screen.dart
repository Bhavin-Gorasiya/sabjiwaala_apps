import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/cloase_app_popup.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/theme/colors.dart';

import '../../Widgets/payment_popup.dart';
import '../../models/customer_detail_model.dart';
import '../../models/order_place.dart';
import '../../utils/helper.dart';
import '../dash_board/cart_screen.dart';
import 'add_address.dart';

class AddressScreen extends StatefulWidget {
  final String userId;
  final bool isCartScreen;
  final int? totalPrice;
  final int length;
  final Widget? widget;
  final OrderPlace? orderPlace;

  const AddressScreen({
    Key? key,
    required this.userId,
    required this.isCartScreen,
    this.widget,
    this.totalPrice,
    required this.length,
    this.orderPlace,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String payment = "COD";

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  getAddress() async {
    log("==== user Id ${widget.userId}");
    final state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAddress();
    addressId = state.addressList.first.addressesId;
  }

  int selectedIndex = 0;
  String addressId = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      // log("====state.addressList.length ===${state.addressList.length}");
      return Scaffold(
        body: Column(
          children: [
            appBar(context: context, title: "Address details", size: size),
            Container(
              width: size.width * 0.9,
              height: 2,
              color: Colors.black.withOpacity(0.1),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : SingleChildScrollView(
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
                                    // addressId = state.addressList.first.addressesId;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          addressId = state.addressList[index].addressesId;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width < 350 ? size.width * 0.01 : 15, vertical: 10),
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
                                              child: !widget.isCartScreen
                                                  ? Text(
                                                      '${index + 1}',
                                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                                    )
                                                  : CircleAvatar(
                                                      radius: size.width * 0.017,
                                                      backgroundColor: selectedIndex == index
                                                          ? AppColors.primary
                                                          : Colors.black.withOpacity(0.1),
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
                                                    style: GoogleFonts.poppins(
                                                        fontSize: size.width * 0.038, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                Text(
                                                  "Pin code: ${state.addressList[index].addressesLandmark}.",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: size.width * 0.032, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Get.bottomSheet(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight: Radius.circular(15),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        customContainer(
                                                            size: size,
                                                            name: "Edit address",
                                                            icon: Icons.edit,
                                                            color: Colors.black.withOpacity(0.6),
                                                            onTap: () {
                                                              AddressModel data = state.addressList[index];
                                                              pop(context);
                                                              push(
                                                                context,
                                                                EditAddress(
                                                                  isUpdate: true,
                                                                  index: index,
                                                                  tag: data.addressesTag,
                                                                  landmark: data.addressesLandmark,
                                                                  address: data.addressesAddress,
                                                                  addressID: data.addressesId,
                                                                ),
                                                              );
                                                            }),
                                                        const SizedBox(height: 5),
                                                        customContainer(
                                                            size: size,
                                                            name: "Delete address",
                                                            icon: Icons.delete,
                                                            color: Colors.red.withOpacity(0.6),
                                                            onTap: () async {
                                                              pop(context);
                                                              Get.dialog(
                                                                CloseAppPopup(
                                                                  name: "Are you sure want to delete address?",
                                                                  onTapYes: () async {
                                                                    Provider.of<CustomViewModel>(context, listen: false)
                                                                        .deleteAddress(
                                                                            addressesID:
                                                                                state.addressList[index].addressesId);
                                                                    pop(context);
                                                                  },
                                                                ),
                                                              );
                                                            }),
                                                        const SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.more_vert_rounded,
                                                  color: Colors.black.withOpacity(0.5),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
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
                    ),
            ),
            widget.isCartScreen
                ? cartContainer(
                    length: widget.length,
                    totalPrice: widget.totalPrice.toString(),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        builder: (context) {
                          OrderPlace data = widget.orderPlace ?? OrderPlace();
                          log("address ===>> $addressId");
                          return PaymentPopup(
                              isSubscription: false,
                              orderPlace: OrderPlace(
                                userId: data.userId,
                                totalAmount: data.totalAmount,
                                orderCoupanid: data.orderCoupanid,
                                cartdata: data.cartdata,
                                addressId: addressId,
                                subTotal: data.subTotal,
                                  orderSubfrid: data.orderSubfrid
                              ));
                        },
                      );
                    },
                    size: size,
                    isAddressScreen: true,
                    bottomPad: MediaQuery.of(context).padding.bottom + 10)
                : const SizedBox()
          ],
        ),
      );
    });
  }
}

  Widget customContainer({
    required String name,
    required IconData icon,
    required Color color,
    required Function onTap,
    required Size size,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: size.width * 0.06,
            ),
            const SizedBox(width: 15),
            Text(
              name,
              style: GoogleFonts.poppins(fontSize: size.width * 0.045),
            )
          ],
        ),
      ),
    );
  }
