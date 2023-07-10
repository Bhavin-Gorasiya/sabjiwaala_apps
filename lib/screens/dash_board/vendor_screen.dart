import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/Widgets/loading.dart';
import 'package:subjiwala/Widgets/rating_star.dart';
import 'package:subjiwala/models/product_models.dart';
import 'package:subjiwala/models/subscription_model.dart';
import 'package:subjiwala/screens/dash_board/orders_screen.dart';
import 'package:subjiwala/screens/dash_board/product_details.dart';
import 'package:subjiwala/screens/dash_board/track_now_screen.dart';
import 'package:subjiwala/utils/app_config.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';
import '../../utils/size_config.dart';
import '../subcription_module/subscribe_screen.dart';

class VendorDetailScreen extends StatefulWidget {
  final VendorProfile data;
  final int index;

  const VendorDetailScreen({Key? key, required this.data, required this.index}) : super(key: key);

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  String selectedTab = "Products";

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getProduct(widget.data.userId ?? "");
        await state.getVendorSubscription(widget.data.userId ?? "");
        log("done here");
      },
    );

    super.initState();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          appBar(context: context, title: "Vendor's profile", size: size),
          Consumer<CustomViewModel>(builder: (context, state, build) {
            return Expanded(
              child: state.isPopularLoad
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.45,
                                          child: Text(
                                            "${widget.data.userFname ?? "user"} ${widget.data.userLname ?? ""}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: size.width * 0.043,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              "Status: ",
                                              style: GoogleFonts.poppins(
                                                fontSize: size.width * 0.036,
                                              ),
                                            ),
                                            Text(
                                              widget.data.userStatus == "1" ? "Available" : "Unavailable",
                                              style: GoogleFonts.poppins(
                                                color: widget.data.userStatus == "1" ? AppColors.primary : Colors.red,
                                                fontWeight: FontWeight.w500,
                                                fontSize: size.width * 0.036,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const RatingStar(rating: 3.99),
                                            const SizedBox(width: 8),
                                            Text(
                                              "3.5/5",
                                              style: GoogleFonts.poppins(
                                                  fontSize: size.width * 0.036, fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "100 m far from me",
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.032,
                                              ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          width: size.width * 0.4,
                                          height: 2,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: size.width * 0.4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: AppColors.primary.withOpacity(0.3)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.width * 0.3,
                                            child: CarouselSlider(
                                              options: CarouselOptions(
                                                  autoPlay: false,
                                                  enlargeCenterPage: false,
                                                  viewportFraction: 1.0,
                                                  onPageChanged: (index, reason) {
                                                    setState(() {
                                                      _current = index;
                                                    });
                                                  }),
                                              items: [0]
                                                  .map(
                                                    (index) => Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 12, bottom: 5, right: 15, left: 15),
                                                      child: Container(
                                                        width: size.width,
                                                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                        child: ClipRRect(
                                                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                          child: CachedNetworkImage(
                                                            height: SizeConfig.screenWidth! / 2.1,
                                                            width: SizeConfig.screenWidth!,
                                                            imageUrl:
                                                                (AppConfig.apiUrl + (widget.data.userPicture ?? "")),
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context, url, error) => Image.asset(
                                                              "assets/sabjiwaala.jpeg",
                                                              fit: BoxFit.cover,
                                                            ),
                                                            placeholder: (context, url) => ImageLoader(
                                                                height: size.width < 400
                                                                    ? size.width * 0.25
                                                                    : size.width * 0.22,
                                                                width: size.width < 400
                                                                    ? size.width * 0.32
                                                                    : size.width * 0.3,
                                                                radius: 10),
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
                                            children: ([0].asMap().entries.map((entry) {
                                              return GestureDetector(
                                                child: _current != entry.key
                                                    ? Container(
                                                        width: 10.0,
                                                        height: 10.0,
                                                        margin:
                                                            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle, color: Colors.grey.shade200),
                                                      )
                                                    : Container(
                                                        width: 10.0,
                                                        height: 10.0,
                                                        margin:
                                                            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: AppColors.primary,
                                                        ),
                                                      ),
                                              );
                                            }).toList()),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: Text(
                                          "Track Vendor's location",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: size.width * 0.036,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          log("message ${widget.data.userLat}");
                                          push(
                                              context,
                                              TrackNowScreen(
                                                  id: widget.data.userId ?? "",
                                                  vendorName:
                                                      "${widget.data.userFname ?? "user"} ${widget.data.userLname ?? ""}",
                                                  index: widget.index));
                                        },
                                        child: Text("Track now", style: TextStyle(fontSize: size.width * 0.04)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.black26,
                                ),
                                Row(
                                  children: [
                                    tabContainer(name: "Products", size: size),
                                    tabContainer(name: "Subscription Plan", size: size),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                if (selectedTab == "Products")
                                  Text(
                                    "Available In Basket Today >",
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: size.width * 0.043,
                                        letterSpacing: 1,
                                        wordSpacing: 1),
                                  ),
                                if (selectedTab == "Products")
                                  state.popularProduct.isEmpty
                                      ? Container(
                                          height: 100, alignment: Alignment.center, child: const Text("No Items found"))
                                      : GridView.builder(
                                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                                          itemCount: state.popularProduct.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio: size.width * 0.0014,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 15),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            ProductModel data = state.popularProduct[index];
                                            double qty = double.parse(data.userproductQty ?? "0.0");
                                            String newQty =
                                                "${qty < 1 ? (qty * 1000).round() : qty.round()} ${qty < 1 ? "gm" : "Kg"}";
                                            return GestureDetector(
                                              onTap: () {
                                                push(context, ProductDetailsScreen(productModel: data, isCart: false));
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0),
                                                  ),
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
                                                                width: double.infinity,
                                                                fit: BoxFit.cover,
                                                                imageUrl:
                                                                    AppConfig.apiUrl + (data.userproductPPic ?? ""),
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
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: size.width * 0.037,
                                                                letterSpacing: 0.7),
                                                          ),
                                                          const SizedBox(height: 3),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "₹ ${data.userproductPrice}.00/kg",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .displaySmall
                                                                        ?.copyWith(
                                                                          fontWeight: FontWeight.w800,
                                                                          fontSize: size.width * 0.032,
                                                                          letterSpacing: 0.7,
                                                                        ),
                                                                  ),
                                                                  const SizedBox(height: 2),
                                                                  Text(
                                                                    "Available Qty.:",
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .displaySmall
                                                                        ?.copyWith(
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
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .displaySmall
                                                                        ?.copyWith(
                                                                            color: double.parse(
                                                                                        data.userproductQty ?? "0") <
                                                                                    5
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
                                                      if (double.parse(data.userproductQty ?? "0") > 0 &&
                                                          state.uid != "")
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              if (!data.isCart) {
                                                                await state.addToCart(
                                                                    customerID:
                                                                        state.customerDetail.first.customerId ?? "",
                                                                    vendorID: widget.data.userId ?? "",
                                                                    productID: data.userproductId ?? "",
                                                                    qty: "1");
                                                              } else {
                                                                await state.updateCart(
                                                                    cartID: state.cartProductList
                                                                            .where((element) =>
                                                                                element.cartPid == data.userproductId)
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
                                        )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.vendorSubsList.length,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      VendorSubscription data = state.vendorSubsList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          push(context,
                                              SubscribeScreen(isWeek: data.subscriptionPtype == "Weekly", data: data));
                                        },
                                        child: CustomContainer(
                                          size: size,
                                          rad: 10,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                                  width: SizeConfig.screenWidth! / 2.2 / 2.2,
                                                  fit: BoxFit.cover,
                                                  imageUrl: AppConfig.apiUrl + (data.subscriptionproductPpic ?? ""),
                                                  placeholder: (context, url) => ImageLoader(
                                                    height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                                    width: SizeConfig.screenWidth! / 2.2 / 2.2,
                                                    radius: 10,
                                                  ),
                                                  errorWidget: (context, url, error) => const SizedBox(),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: size.width * 0.55,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.subscriptionproductPname ?? "",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: size.width * 0.04,
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
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "₹ ${data.subscriptionproductPrice}",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.033,
                                                            decoration: TextDecoration.lineThrough,
                                                            color: Colors.black54,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ₹ ${data.subscriptionproductPrice} / month",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.033,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black.withOpacity(0.7),
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
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (state.isCartLoad) const Loading()
                      ],
                    ),
            );
          }),
        ],
      ),
    );
  }

  Widget tabContainer({required String name, required Size size}) {
    return GestureDetector(
      onTap: () {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        state.filterOrder(name.toLowerCase());
        setState(() {
          selectedTab = name;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 2.5,
              width: size.width / 2 - 15,
              color: selectedTab == name ? AppColors.primary : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
