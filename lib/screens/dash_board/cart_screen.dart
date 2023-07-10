import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/loading.dart';
import 'package:subjiwala/Widgets/login_popup.dart';
import 'package:subjiwala/models/cart_model.dart';
import 'package:subjiwala/models/order_place.dart';
import 'package:subjiwala/screens/profile_modual/address_screen.dart';
import 'package:subjiwala/theme/colors.dart';
import 'package:subjiwala/utils/helper.dart';

import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../utils/app_config.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoad = false;
  int qnty = 1;
  int totalPrice = 0;

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await getAllCart();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    getAllCart();
    super.initState();
  }

  getAllCart() async {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAllCart();
    if (state.uid == "") {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          showDialog(
            context: context,
            builder: (context) => const LoginPopup(),
          );
        },
      );
    }
    getPrice();
  }

  getPrice({int? listLength, List<AddCartResponseModel>? product, List<AddCartResponseModel>? cart}) {
    totalPrice = 0;
    int length = listLength ?? Provider.of<CustomViewModel>(context, listen: false).cartProductList.length;
    List<AddCartResponseModel> productList =
        product ?? Provider.of<CustomViewModel>(context, listen: false).cartProductList;
    if (length != 0) {
      for (int i = 0; i < length; i++) {
        if (double.parse(productList[i].userproductQty ?? "0") > 0) {
          setState(() {
            totalPrice =
                totalPrice + (int.parse(productList[i].userproductPrice!) * int.parse(productList[i].cartQty ?? "0"));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, right: 15, left: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My cart",
                  style: GoogleFonts.poppins(fontSize: size.width * 0.048, fontWeight: FontWeight.w500),
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
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : state.cartProductList.isEmpty
                      ? Center(
                          child: Text(state.customerDetail.isEmpty ? "Please Login first!!!" : "No items in cart"),
                        )
                      : Stack(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order Summary",
                                      style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                                    ),
                                    ListView.builder(
                                      itemCount: state.cartProductList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        AddCartResponseModel productDetail = state.cartProductList[index];
                                        // AddCartResponseModel cartDetail = state.cartProduct[index];
                                        bool isLow = double.parse(productDetail.userproductQty ?? "0") < 1;
                                        return Stack(
                                          alignment: Alignment.topRight,
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
                                                      color: isLow ? Colors.black12 : null,
                                                      height: size.width * 0.2,
                                                      width: size.width * 0.2,
                                                      imageUrl:
                                                          (AppConfig.apiUrl + (productDetail.userproductPPic ?? "")),
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context, url, error) => Image.asset(
                                                        "assets/sabjiwaala.jpeg",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      placeholder: (context, url) => ImageLoader(
                                                          height: size.width * 0.2,
                                                          width: size.width * 0.2,
                                                          radius: 10),
                                                    ),
                                                  ),
                                                  SizedBox(width: size.width < 350 ? size.width * 0.01 : 10),
                                                  SizedBox(
                                                    width: size.width * 0.6,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          productDetail.userproductPname ?? "",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: size.width * 0.036,
                                                            color: isLow ? Colors.black26 : Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          productDetail.userproductDesc ?? "",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: size.width * 0.032,
                                                              fontWeight: FontWeight.w500,
                                                              color: isLow
                                                                  ? Colors.black26
                                                                  : Colors.black.withOpacity(0.5)),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "₹ ${productDetail.userproductPrice ?? ""}.00/kg",
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: size.width * 0.033,
                                                                      color: isLow ? Colors.black26 : Colors.black,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                            isLow
                                                                ? GestureDetector(
                                                                    onTap: () async {
                                                                      await Provider.of<CustomViewModel>(context,
                                                                              listen: false)
                                                                          .updateCart(
                                                                              cartID: productDetail.cartId ?? "1",
                                                                              qty: "0");
                                                                      getPrice(product: state.cartProductList);
                                                                    },
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      width: size.width * 0.18,
                                                                      padding: const EdgeInsets.symmetric(
                                                                          horizontal: 5, vertical: 2),
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors.red,
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child: Text(
                                                                        "Remove",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize: size.width * 0.032,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: size.width * 0.18,
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal: 5, vertical: 2),
                                                                    decoration: BoxDecoration(
                                                                        color: AppColors.primary,
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () async {
                                                                            if (qnty > 0) {
                                                                              await Provider.of<CustomViewModel>(
                                                                                      context,
                                                                                      listen: false)
                                                                                  .updateCart(
                                                                                      cartID:
                                                                                          productDetail.cartId ?? "1",
                                                                                      qty:
                                                                                          "${int.parse(productDetail.cartQty ?? "1") - 1}");
                                                                              getPrice(product: state.cartProductList);
                                                                            }
                                                                          },
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
                                                                          productDetail.cartQty ?? "1",
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: size.width * 0.038,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.white),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () async {
                                                                            if (productDetail.cartQty !=
                                                                                productDetail.userproductQty) {
                                                                              await Provider.of<CustomViewModel>(
                                                                                      context,
                                                                                      listen: false)
                                                                                  .updateCart(
                                                                                      cartID:
                                                                                          productDetail.cartId ?? "1",
                                                                                      qty:
                                                                                          "${int.parse(productDetail.cartQty ?? "1") + 1}");
                                                                              getPrice();
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            width: size.width * 0.04,
                                                                            child: Text(
                                                                              "+",
                                                                              style: GoogleFonts.poppins(
                                                                                  fontSize: size.width * 0.038,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: productDetail.cartQty !=
                                                                                          productDetail.userproductQty
                                                                                      ? Colors.white
                                                                                      : Colors.white38),
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
                                            ),
                                            if (isLow)
                                              const Padding(
                                                padding: EdgeInsets.all(18),
                                                child: Text(
                                                  "Product unavailable",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Bill Summary",
                                      style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
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
                                          billTexts(
                                              size: size, title: "Order Total", desc: "$totalPrice.00", isBold: true),
                                          billTexts(size: size, title: "Delivery charges", desc: "00.00"),
                                          billTexts(size: size, title: "Service charges", desc: "00.00"),
                                          billTexts(
                                              size: size, title: "Grand Total", desc: "$totalPrice.00", isBold: true),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (state.isCartLoad) const Loading()
                          ],
                        ),
            ),
          ),
          if (state.cartProductList.isNotEmpty)
            cartContainer(
                length: state.cartProductList.length,
                totalPrice: totalPrice.toString(),
                onTap: () {
                  List<Cartdatum> cartData = [];
                  for (AddCartResponseModel data in state.cartProductList) {
                    if (double.parse(data.userproductQty ?? "0") > 0) {
                      cartData.add(Cartdatum(
                          pQty: data.cartQty,
                          productTotalamt: "${int.parse(data.userproductPrice ?? " ") * int.parse(data.cartQty ?? "")}",
                          productId: data.userproductID,
                          productMrp: data.userproductPrice));
                    }
                  }
                  push(
                    context,
                    AddressScreen(
                      length: state.cartProductList.length,
                      userId: state.uid!,
                      isCartScreen: true,
                      totalPrice: totalPrice,
                      orderPlace: OrderPlace(
                        cartdata: cartData,
                        orderCoupanid: "0",
                        orderSubfrid: state.cartProductList.first.cartVid,
                        totalAmount: totalPrice.toString(),
                        userId: state.customerDetail.first.customerId,
                        subTotal: totalPrice.toString(),
                      ),
                      widget: const SizedBox(),
                    ),
                  );
                },
                size: size)
        ],
      );
    });
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
  required int length,
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
              "$length item in cart",
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
