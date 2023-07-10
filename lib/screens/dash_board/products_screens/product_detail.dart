import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/ProductListParser.dart';
import 'package:subjiwala_farmer/View%20Models/CustomViewModel.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/Widgets/rating_star.dart';
import 'package:subjiwala_farmer/Widgets/shimmer_loader/image_loader.dart';

import '../../../Models/order_model.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_config.dart';
import '../../../utils/app_text.dart';
import '../../auth/signup_screen.dart';

class ProductDetails extends StatefulWidget {
  final OrderModel product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await state.getReview(
            farmerID: widget.product.productFarmerid ?? "", productID: widget.product.productId ?? "");
      },
    );
    super.initState();
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    OrderModel product = widget.product;
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.productDetail[state.language]),
          Expanded(
            child: SingleChildScrollView(
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
                      items: [product.productPic].map(
                        (index) {
                          // log(AppConfig.apiUrl + index.bannerFile!);
                          return Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 5, right: 15, left: 15),
                            child: Container(
                              width: size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    color: AppColors.bgColorCard,
                                  ),
                                  height: size.width * 0.2,
                                  width: size.width,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    imageUrl: AppConfig.apiUrl + index!,
                                    placeholder: (context, url) =>
                                        ImageLoader(height: size.width * 0.2, width: size.width, radius: 15),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.image_not_supported_outlined),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [product.productPic].asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: _current != entry.key
                            ? Container(
                                width: 10.0,
                                height: 10.0,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                              )
                            : Container(
                                width: 10.0,
                                height: 10.0,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.details[state.language],
                          style: TextStyle(fontSize: size.width * 0.043, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: size.width * 0.04),
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.center,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.black.withOpacity(0.05),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName!,
                                style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                product.productDescription ?? ""
                                /*"Lorem Ipsum is simply dummy text of the printing"
                                "and typesetting industry. Lorem Ipsum has been the"
                                "industry's standard dummy text ever since the 1500s,"
                                "when an unknown printer took a galley of type and"
                                "scrambled it to make a type specimen book."*/
                                ,
                                style: TextStyle(fontSize: size.width * 0.035),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    AppText.availableQty[state.language],
                                    style: TextStyle(fontSize: size.width * 0.035),
                                  ),
                                  Text(
                                    "${product.productQty} ${AppText.kg[state.language]}.",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    AppText.pricePerKg[state.language],
                                    style: TextStyle(fontSize: size.width * 0.035),
                                  ),
                                  Text(
                                    "₹ ${product.productPrice}/-",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // if (widget.product.nutritiondata!.isNotEmpty)
                        Text(
                          AppText.nutritionDetails[state.language],
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.04,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.center,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.black.withOpacity(0.05),
                          ),
                          child: widget.product.nutritiondata!.isEmpty
                              ? Text(AppText.noNutrition[state.language])
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppText.nutritionName[state.language],
                                          style: TextStyle(color: Colors.black54, fontSize: size.width * 0.033),
                                        ),
                                        Text(
                                          AppText.kCal[state.language],
                                          style: TextStyle(color: Colors.black54, fontSize: size.width * 0.033),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: widget.product.nutritiondata!.length,
                                      itemBuilder: (context, index) {
                                        Nutritiondatum nutrition = widget.product.nutritiondata![index];
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
                        /*Text(
                          AppText.growMore[state.language],
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width * 0.04,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.center,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.black.withOpacity(0.05),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppText.suggestions[state.language],
                                style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: const [
                                  Text("  1. "),
                                  Text(
                                    "www.youtube.com",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),*/
                        Text(
                          AppText.reviewsReceive[state.language],
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: size.width * 0.04,
                              letterSpacing: 1,
                              wordSpacing: 1),
                        ),
                        Consumer<CustomViewModel>(builder: (context, state, child) {
                          return state.isLoading
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: size.width,
                                  child: const Center(child: CircularProgressIndicator()))
                              : state.reviewList.isEmpty
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: size.width,
                                      child: Center(child: Text(AppText.noReview[state.language])))
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      padding: const EdgeInsets.only(bottom: 35),
                                      shrinkWrap: true,
                                      itemCount: state.reviewList.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        Review data = state.reviewList[index];
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                            color: Colors.black.withOpacity(0.05),
                                          ),
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.customerName ?? "0.0",
                                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: size.width * 0.032,
                                                        letterSpacing: 0.7),
                                                  ),
                                                  const Spacer(),
                                                  RatingStar(
                                                      rating: double.parse(data.reviewRating ?? "0.0"), size: size),
                                                  const SizedBox(width: 7),
                                                  Text(
                                                    data.reviewRating ?? "0.0",
                                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: size.width * 0.032,
                                                        letterSpacing: 0.7),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                data.reviewDesc ?? "",
                                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: size.width * 0.03,
                                                    letterSpacing: 0.7),
                                              ),
                                              const SizedBox(height: 4),
                                            ],
                                          ),
                                        );
                                      });
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vitamins({required String name, required Size size}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: size.width * 0.03),
          const SizedBox(width: 10),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: size.width * 0.03, letterSpacing: 1, wordSpacing: 1),
          ),
        ],
      ),
    );
  }
}
