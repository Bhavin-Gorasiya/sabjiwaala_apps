import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/address/address_screen.dart';

import '../../theme/colors.dart';
import '../../utils/helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoad = false;
  int qnty = 1;
  int totalPrice = 65;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Cart",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.048,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: size.width * 0.9,
            height: 2,
            color: Colors.black.withOpacity(0.1),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: GoogleFonts.poppins(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                    ),
                    ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // ProductModel productDetail = state.cartProductList[index];
                        // AddCartResponseModel cartDetail = state.cartProduct[index];
                        return Container(
                          width: size.width,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: size.width * 0.2,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            "https://static.agrostar.in/static/Bottle%20Gourd%20(Dudhi).jpg"))),
                              ),
                              SizedBox(width: size.width < 350 ? size.width * 0.01 : 10),
                              SizedBox(
                                width: size.width * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Milky",
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.036,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Best vegetables for ever",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.032,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "₹ 50.00/kg",
                                              style: GoogleFonts.poppins(
                                                  fontSize: size.width * 0.033, fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "₹ 50.00/kg",
                                              style: GoogleFonts.poppins(
                                                  fontSize: size.width * 0.028,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black.withOpacity(0.6),
                                                  decoration: TextDecoration.lineThrough),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: size.width * 0.18,
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: AppColors.primary, borderRadius: BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () async {},
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * 0.04,
                                                  child: Text(
                                                    "-",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: size.width * 0.038,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "2" /*cartDetail.cartQty*/,
                                                style: GoogleFonts.poppins(
                                                    fontSize: size.width * 0.038,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              InkWell(
                                                onTap: () async {},
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * 0.04,
                                                  child: Text(
                                                    "+",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: size.width * 0.038,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Bill Summary",
                      style: GoogleFonts.poppins(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
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
                        children: [
                          billTexts(size: size, title: "Order Total", desc: "50.00", isBold: true),
                          billTexts(size: size, title: "Delivery charges", desc: "10.00"),
                          billTexts(size: size, title: "Service charges", desc: "05.00"),
                          billTexts(size: size, title: "Grand Total", desc: "65.00", isBold: true),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          cartContainer(
            totalPrice: totalPrice.toString(),
            onTap: () {
              push(context, AddressScreen(userId: "1", isCartScreen: true));
            },
            size: size,
            bottomPad: MediaQuery.of(context).padding.bottom + 10,
          )
        ],
      ),
    );
  }

  Widget billTexts({required String title, required String desc, bool isBold = false, required Size size}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: isBold ? size.width * 0.033 : size.width * 0.03,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400),
          ),
          Text(
            "$desc/-",
            style: GoogleFonts.poppins(
                fontSize: isBold ? size.width * 0.033 : size.width * 0.03,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

Widget cartContainer({
  required Function onTap,
  required Size size,
  bool isAddressScreen = false,
  double? bottomPad,
  required String totalPrice,
}) {
  return Container(
    width: size.width,
    padding: EdgeInsets.only(top: 10, right: 15, left: 15, bottom: bottomPad ?? 10),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        color: AppColors.primary),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "1 item in cart",
              style:
                  GoogleFonts.poppins(fontSize: size.width * 0.034, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            Text(
              "₹ $totalPrice.00/-",
              style: GoogleFonts.poppins(fontSize: size.width * 0.04, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Text(
              "Proceed to pay",
              style: GoogleFonts.poppins(fontSize: size.width * 0.04),
            ),
          ),
        )
      ],
    ),
  );
}
