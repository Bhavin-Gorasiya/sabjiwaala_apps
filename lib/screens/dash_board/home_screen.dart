import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/shimmer_loader/banner_loader.dart';
import 'package:subjiwala/Widgets/shimmer_loader/image_loader.dart';
import 'package:subjiwala/Widgets/shimmer_loader/loading_condition.dart';
import 'package:subjiwala/Widgets/shimmer_loader/main_category_loader.dart';
import 'package:subjiwala/Widgets/shimmer_loader/product_container_loader.dart';
import 'package:subjiwala/Widgets/shimmer_loader/text_loader.dart';
import 'package:subjiwala/models/cart_model.dart';
import 'package:subjiwala/screens/dash_board/product_details.dart';
import 'package:subjiwala/screens/dash_board/vendor_screen.dart';
import 'package:subjiwala/theme/colors.dart';
import 'package:subjiwala/utils/size_config.dart';
import '../../Widgets/location_widget.dart';
import '../../Widgets/vendor_container.dart';
import '../../models/MainCategoryListParser.dart';
import '../../models/product_models.dart';
import '../../utils/app_config.dart';
import '../../utils/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.determinePosition(context);
      },
    );
    super.initState();
  }

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAllProduct().then((value) async => await state.determinePosition(context));
    log("===>>> onRefresh");
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationWidget(size: size, address: state.address),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    // const SearchProductWidget(),
                    state.isBannerLoad
                        ? BannerLoader(size: size)
                        : state.bannerList.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CarouselSlider(
                                  carouselController: _controller,
                                  options: CarouselOptions(
                                      autoPlay: false,
                                      enlargeCenterPage: false,
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                  items: state.bannerList.map(
                                    (index) {
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
                                              height: SizeConfig.screenWidth! / 2.1,
                                              width: SizeConfig.screenWidth!,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: AppConfig.apiUrl + index.bannerFile!,
                                                placeholder: (context, url) => ImageLoader(
                                                    height: SizeConfig.screenWidth! / 2.1,
                                                    width: SizeConfig.screenWidth!,
                                                    radius: 15),
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
                    state.isBannerLoad
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (state.isBannerLoad ? [0, 1] : state.bannerList).asMap().entries.map((entry) {
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
                    LoadingCondition(
                      isLoad: state.isPopularLoad,
                      list: state.vendorList,
                      loader: const Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 15, top: 25),
                        child: TextLoader(width: 120, height: 15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Popular vendors",
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: size.width * 0.042,
                              letterSpacing: 1,
                              wordSpacing: 1),
                        ),
                      ),
                    ),
                    LoadingCondition(
                      isLoad: state.isPopularLoad,
                      list: state.vendorList,
                      loader: const ProductContainerLoader(),
                      child: SizedBox(
                        height: size.width < 400 ? size.width / 1.68 : size.width / 1.9,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: state.vendorList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return VendorContainer(data: state.vendorList[index], size: size, index: index);
                          },
                        ),
                      ),
                    ),
                    LoadingCondition(
                      isLoad: state.isMainCategoryLoad,
                      list: state.subCategoryList,
                      loader: const Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 15, top: 25),
                        child: TextLoader(width: 120, height: 15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Categories",
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.042,
                                  letterSpacing: 1,
                                  wordSpacing: 1),
                            ),
                            GestureDetector(
                              onTap: () {
                                state.changeBottomNavIndex(index: 1);
                              },
                              child: Text(
                                "View All",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.underline,
                                    fontSize: size.width * 0.04,
                                    letterSpacing: 1,
                                    wordSpacing: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LoadingCondition(
                      isLoad: state.isMainCategoryLoad,
                      list: state.subCategoryList,
                      loader: const MainCategoryLoader(),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                        width: SizeConfig.screenWidth,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: AppColors.bgColorCard,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.subCategoryList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: size.width < 400 ? size.width * 0.0019 : size.width * 0.00185,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 4.0,
                              ),
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                Subcategory data = state.subCategoryList[index];
                                // log(AppConfig.apiUrl + state.mainCategory[index].categoryFile!);
                                return GestureDetector(
                                  onTap: () {
                                    state.filterVendor(
                                        subCatId: data.subcategoryId ?? "", catId: data.categoryId ?? "");
                                    state.changeCategoryIndex(index: index);
                                    state.changeBottomNavIndex(index: 1);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 65,
                                        height: 70,
                                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: AppConfig.apiUrl + data.subcategoryFile!,
                                            placeholder: (context, url) => const ImageLoader(
                                              height: 70,
                                              width: 65,
                                              radius: 10,
                                            ),
                                            errorWidget: (context, url, error) => const SizedBox(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          data.subcategoryName ?? "",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: size.width * 0.03,
                                              letterSpacing: 1,
                                              wordSpacing: 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Vendors Near You",
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: size.width * 0.042,
                            letterSpacing: 1,
                            wordSpacing: 1),
                      ),
                    ),
                    GridView.builder(
                      padding: const EdgeInsets.only(right: 15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: size.width < 400 ? 10 : 3,
                        mainAxisSpacing: 10,
                        crossAxisCount: size.width < 400 ? 2 : 3,
                        childAspectRatio: size.width < 400
                            ? size.width < 350
                                ? size.width * 0.0023
                                : size.width * 0.002
                            : size.width * 0.0013,
                      ),
                      shrinkWrap: true,
                      itemCount: state.vendorList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        VendorProfile data = state.vendorList[index];
                        return GestureDetector(
                          onTap: () {
                            push(context, VendorDetailScreen(data: state.vendorList[index], index: index));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, bottom: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              color: AppColors.bgColorCard,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width < 400 ? 15 : 8.0, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height: size.width < 400 ? size.width * 0.25 : size.width * 0.22,
                                        width: size.width < 400 ? size.width * 0.32 : size.width * 0.3,
                                        imageUrl: (AppConfig.apiUrl + (data.userPicture ?? "")),
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Image.asset(
                                          "assets/sabjiwaala.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                        placeholder: (context, url) => ImageLoader(
                                            height: size.width < 400 ? size.width * 0.25 : size.width * 0.22,
                                            width: size.width < 400 ? size.width * 0.32 : size.width * 0.3,
                                            radius: 10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.015),
                                  Text(
                                    "${data.userFname} ${data.userLname}",
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w700, fontSize: size.width * 0.036, letterSpacing: 0.7),
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow.shade600, size: 18),
                                      const SizedBox(width: 7),
                                      Text(
                                        index % 2 == 0 ? "3.4" : "4.5",
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: size.width * 0.032,
                                            letterSpacing: 0.7),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: Text(
                                      data.userHaddress ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w800,
                                            fontSize: size.width * 0.032,
                                            letterSpacing: 0.7,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    index % 2 == 0 ? "350 m" : "100 m",
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w900,
                                        fontSize: size.width * 0.033,
                                        letterSpacing: 0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget productContainer({
    required Size size,
    required List<ProductModel> productList,
    required int index,
    required List<AddCartResponseModel> cartProduct,
    required String uid,
  }) {
    return InkWell(
      onTap: () {
        log("===${cartProduct.any((element) => element.cartPid == productList[index].userproductPid)}");
        push(
            context,
            ProductDetailsScreen(
              productModel: productList[index],
              isCart: cartProduct.any((element) => element.cartPid == productList[index].userproductPid),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, bottom: 10),
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
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: AppColors.bgColorCardDarkGrey,
                      ),
                      height: SizeConfig.screenWidth! / 2.2 / 2.2,
                      width: SizeConfig.screenWidth! / 3.5,
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: index == 1
                            ? "https://freepngimg.com/thumb/onion/164056-onion-free-transparent-image-hd.png"
                            : index == 2
                                ? "http://clipart-library.com/image_gallery/327825.png"
                                : "https://image.similarpng.com/very-thumbnail/2020/06/Lemon-vector-transparent-PNG.png",
                        placeholder: (context, url) => const SizedBox(),
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    productList[index].userproductPname ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: size.width * 0.036, letterSpacing: 0.7),
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
                            "₹${productList[index].userproductPrice ?? "0"}.00/Kg",
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w800,
                                fontSize: size.width * 0.028,
                                letterSpacing: 0.7),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₹${productList[index].userproductPrice ?? ""}.00/Kg",
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: size.width * 0.032, letterSpacing: 0.7),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    ProductModel data = productList[index];

                    if (cartProduct.any((element) => element.cartPid != data.userproductPid) || cartProduct.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Product added to cart"),
                        ),
                      );
                      await Provider.of<CustomViewModel>(context, listen: false).addToCart(
                          customerID: uid, vendorID: data.userproductPid!, productID: data.userproductPid!, qty: "1");
                    } else {
                      for (var e in cartProduct) {
                        if (e.cartPid == data.userproductPid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product added to cart"),
                            ),
                          );
                          // await Provider.of<CustomViewModel>(context, listen: false).updateCart(
                          //     customerID: uid, productID: data.inventorysfrPid!, qty: "${int.parse(e.cartQty) + 1}");
                        }
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: size.width * 0.038,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.add, size: size.width * 0.06, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LoadingCondition(
//   isLoad: state.isTrendingLoad,
//   list: state.trendingProduct,
//   loader: const Padding(
//     padding: EdgeInsets.only(left: 15, bottom: 15, top: 25),
//     child: TextLoader(width: 120, height: 15),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(15.0),
//     child: Text(
//       "Trending The List",
//       style: Theme.of(context).textTheme.displaySmall?.copyWith(
//           fontWeight: FontWeight.w700,
//           fontSize: size.width * 0.042,
//           letterSpacing: 1,
//           wordSpacing: 1),
//     ),
//   ),
// ),
// LoadingCondition(
//   isLoad: state.isTrendingLoad,
//   list: state.trendingProduct,
//   loader: const ProductContainerLoader(),
//   child: SizedBox(
//     height: SizeConfig.screenWidth! / 1.9,
//     width: SizeConfig.screenWidth,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       shrinkWrap: true,
//       itemCount: state.trendingProduct.length,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) {
//         return productContainer(
//             size: size,
//             productList: state.trendingProduct,
//             index: index,
//             cartProduct: state.cartProduct,
//             uid: state.uid!);
//       },
//     ),
//   ),
// ),
