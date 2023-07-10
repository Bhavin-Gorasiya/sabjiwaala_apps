import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/Widgets/loading.dart';
import 'package:subjiwala/Widgets/rating_star.dart';
import 'package:subjiwala/models/product_models.dart';
import 'package:subjiwala/theme/colors.dart';
import 'package:subjiwala/utils/helper.dart';
import 'package:subjiwala/utils/size_config.dart';
import '../../Widgets/login_popup.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../models/product_review_model.dart';
import '../../utils/app_config.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  final bool isCart;

  const ProductDetailsScreen({super.key, required this.productModel, required this.isCart});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _current = 0;
  double ratings = 0.0;
  bool isCart = false;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // getReview();
    isCart = widget.isCart;
    log("  is cart  === ${widget.isCart}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // getReview() async {
  //   await Provider.of<CustomViewModel>(context, listen: false)
  //       .getProductReview(productId: widget.productModel.productId!, vendorId: widget.productModel.vendorId!)
  //       .then((value) {
  //     if (value == "true") {
  //       getRating(productReviewList: Provider.of<CustomViewModel>(context, listen: false).productReviewList);
  //     }
  //   });
  // }

  getRating({required List<ProductReviewModel> productReviewList}) {
    if (productReviewList.isNotEmpty) {
      for (int i = 0; i < productReviewList.length; i++) {
        setState(() {
          ratings = ratings + double.parse(productReviewList[i].reviewRating);
        });
      }
      ratings = ratings / productReviewList.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      /*bottomNavigationBar: Container(
        height: 60,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom / 2 + 10,
            top: 10,
            left: size.width * 0.05,
            right: size.width * 0.05),
        child: CustomBtn(
          title: "Get Subscription",
          size: size,
          radius: 10,
          onTap: () {
            push(context, SubscribeScreen(data: widget.productModel));
          },
          btnColor: AppColors.primary,
        ),
      ),*/
      body: Consumer<CustomViewModel>(builder: (context, state, child) {
        log("==== review list length  ${state.productReviewList.length}");
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar(context: context, title: widget.productModel.userproductPname ?? "", size: size),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: false,
                                // aspectRatio: 2.0,
                                // height: 400,
                                viewportFraction: 1.0,
                                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                            items: [0]
                                .map(
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(top: 12, bottom: 5, right: 15, left: 15),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                        child: CachedNetworkImage(
                                          height: SizeConfig.screenWidth! / 2.1,
                                          width: SizeConfig.screenWidth!,
                                          fit: BoxFit.cover,
                                          imageUrl: AppConfig.apiUrl + (widget.productModel.userproductPPic ?? ""),
                                          placeholder: (context, url) => ImageLoader(
                                            height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                            width: double.infinity,
                                            radius: 10,
                                          ),
                                          errorWidget: (context, url, error) => const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [0].asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current != entry.key ? Colors.grey.shade200 : AppColors.primary),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.6,
                                    child: Text(
                                      widget.productModel.userproductPname ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: size.width * 0.045,
                                          letterSpacing: 1,
                                          wordSpacing: 1),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "₹ ${widget.productModel.userproductPrice}.00/kg",
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w700, fontSize: size.width * 0.038, letterSpacing: 0.7),
                                  ),
                                ],
                              ),
                              if (double.parse(widget.productModel.userproductQty ?? "0") > 0)
                                GestureDetector(
                                  onTap: () async {
                                    if (state.uid != "") {
                                      ProductModel data = widget.productModel;

                                      if (!data.isCart) {
                                        await state.addToCart(
                                            customerID: state.customerDetail.first.customerId ?? "",
                                            vendorID: widget.productModel.userproductSubfid ?? "",
                                            productID: data.userproductId ?? "",
                                            qty: "1");
                                      } else {
                                        await state.updateCart(
                                            cartID: state.cartProductList
                                                    .where((element) =>
                                                        element.userproductID == widget.productModel.userproductId)
                                                    .first
                                                    .cartId ??
                                                "",
                                            qty: "0");
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const LoginPopup(),
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(7.0),
                                      ),
                                      color: widget.productModel.isCart && state.uid != ""
                                          ? Colors.black.withOpacity(0.3)
                                          : AppColors.primary,
                                    ),
                                    child: SizedBox(
                                      width: 100,
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          widget.productModel.isCart && state.uid != "" ? "Remove" : "ADD",
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: size.width * 0.036,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                              wordSpacing: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.productModel.userproductDesc ?? "",
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                                fontSize: size.width * 0.035,
                                letterSpacing: 0.7,
                                wordSpacing: 1),
                          ),
                        ),
                        state.productReviewList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(15),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                      ),
                                    ]),
                                child: Text(
                                  "No review yet.",
                                  style: GoogleFonts.poppins(fontSize: size.width * 0.04),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Card(
                                  elevation: 3,
                                  child: ExpansionTile(
                                    textColor: Colors.black,
                                    iconColor: Colors.black,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Text(
                                            "Reviews",
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: size.width * 0.04,
                                                letterSpacing: 1,
                                                wordSpacing: 1),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        RatingStar(rating: ratings)
                                      ],
                                    ),
                                    children: [
                                      ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: state.productReviewList.length,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.only(left: 15, bottom: 10),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                color: AppColors.bgColorCard,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        RatingStar(
                                                            rating: double.parse(
                                                                state.productReviewList[index].reviewRating)),
                                                        const SizedBox(width: 7),
                                                        Text(
                                                          "${double.parse(state.productReviewList[index].reviewRating)}",
                                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                              fontWeight: FontWeight.w800,
                                                              fontSize: size.width * 0.032,
                                                              letterSpacing: 0.7),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      state.productReviewList[index].reviewDesc,
                                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: size.width * 0.032,
                                                          letterSpacing: 0.7),
                                                    ),
                                                    const SizedBox(height: 4),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Nutritional details",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: size.width * 0.042,
                                    letterSpacing: 1,
                                    wordSpacing: 1),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.info_outline, size: 16),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                          padding: const EdgeInsets.all(15),
                          width: SizeConfig.screenWidth,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            color: AppColors.bgColorCard,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nutrition name",
                                    style: TextStyle(color: Colors.black54, fontSize: size.width * 0.033),
                                  ),
                                  Text(
                                    "kCal",
                                    style: TextStyle(color: Colors.black54, fontSize: size.width * 0.033),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.productModel.nutritiondata!.length,
                                itemBuilder: (context, index) {
                                  Nutritiondatum nutrition = widget.productModel.nutritiondata![index];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${index + 1}.  ${nutrition.nutritionType}",
                                        style: TextStyle(color: Colors.black, fontSize: size.width * 0.033),
                                      ),
                                      Text(
                                        nutrition.nutritionName ?? "",
                                        style: TextStyle(color: Colors.black, fontSize: size.width * 0.033),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Vendor's other Items",
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.042,
                                letterSpacing: 1,
                                wordSpacing: 1),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenWidth! / 1.8,
                          width: SizeConfig.screenWidth,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                            shrinkWrap: true,
                            itemCount: state.popularProduct.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              ProductModel data = state.popularProduct[index];
                              double qty = double.parse(data.userproductQty ?? "0.0");
                              String newQty = "${qty < 1 ? (qty * 1000) : qty.round()} ${qty < 1 ? "gm" : "Kg"}";
                              return GestureDetector(
                                onTap: () {
                                  push(context, ProductDetailsScreen(productModel: data, isCart: isCart));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15, bottom: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    color: AppColors.bgColorCard,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                                  width: size.width * 0.28,
                                                  fit: BoxFit.cover,
                                                  imageUrl: AppConfig.apiUrl + (data.userproductPPic ?? ""),
                                                  placeholder: (context, url) => ImageLoader(
                                                    height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                                    width: double.infinity,
                                                    radius: 10,
                                                  ),
                                                  errorWidget: (context, url, error) => const SizedBox(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              data.userproductPname ?? "",
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                  fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.7),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "₹ ${data.userproductPrice}.00/kg",
                                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: 10,
                                                          letterSpacing: 0.7),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Available Qty.:",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                          color: Colors.grey,
                                                          fontSize: size.width * 0.028,
                                                          letterSpacing: 0.7),
                                                    ),
                                                    Text(
                                                      double.parse(data.userproductQty ?? "0") < 5
                                                          ? "Only $newQty left"
                                                          : newQty,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                          color: double.parse(data.userproductQty ?? "0") < 5
                                                              ? AppColors.red
                                                              : Colors.black87,
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: size.width * 0.028,
                                                          letterSpacing: 0.7),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        if (double.parse(data.userproductQty ?? "0") > 0 && state.uid != "")
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (!data.isCart) {
                                                  await state.addToCart(
                                                      customerID: state.customerDetail.first.customerId ?? "",
                                                      vendorID: widget.productModel.userproductSubfid ?? "",
                                                      productID: data.userproductId ?? "",
                                                      qty: "1");
                                                } else {
                                                  await state.updateCart(
                                                      cartID: state.cartProductList
                                                              .where((element) =>
                                                                  element.userproductID ==
                                                                  widget.productModel.userproductId)
                                                              .first
                                                              .cartId ??
                                                          "",
                                                      qty: "0");
                                                }
                                              },
                                              child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: AppColors.primary,
                                                  child: Icon(data.isCart ? Icons.check : Icons.add,
                                                      size: 23, color: Colors.white)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
                      ],
                    ),
                  ),
                  if (state.isCartLoad) const Loading()
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
