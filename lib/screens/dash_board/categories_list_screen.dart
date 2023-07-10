import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:subjiwala/Widgets/shimmer_loader/main_category_loader.dart';
import 'package:subjiwala/Widgets/vendor_container.dart';
import 'package:subjiwala/models/product_models.dart';
import 'package:subjiwala/theme/colors.dart';
import 'package:subjiwala/utils/app_config.dart';
import 'package:subjiwala/utils/size_config.dart';
import '../../View Models/CustomViewModel.dart';
import '../../Widgets/location_widget.dart';
import '../../Widgets/shimmer_loader/loading_condition.dart';
import '../../models/MainCategoryListParser.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  final RefreshController _refreshController = RefreshController();

  bool isLoading = false;

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getAllMainCategory();
    await state.getVendor();
    await state.filterVendor(
        catId: state.subCategoryList[state.categoryIndex].categoryId ?? "",
        subCatId: state.subCategoryList[state.categoryIndex].subcategoryId ?? "");
    setState(() {
      isLoading = false;
    });
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Categories",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700, fontSize: size.width * 0.042, letterSpacing: 1, wordSpacing: 1),
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.7,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                              color: AppColors.bgColorCard,
                            ),
                            width: 80,
                            child: LoadingCondition(
                              isLoad: state.isMainCategoryLoad,
                              list: state.subCategoryList,
                              loader: const CategoryLoader(),
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: state.subCategoryList.length,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Subcategory data = state.subCategoryList[index];
                                    return InkWell(
                                      onTap: () {
                                        state.changeCategoryIndex(index: index);
                                        state.filterVendor(
                                            subCatId: data.subcategoryId ?? "", catId: data.categoryId ?? "");
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 5,
                                              height: 80,
                                              color: state.categoryIndex == index ? Colors.green : Colors.transparent),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 65,
                                                width: 65,
                                                margin: const EdgeInsets.only(top: 5),
                                                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(100),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: AppConfig.apiUrl + (data.subcategoryFile ?? ""),
                                                    errorWidget: (context, url, error) => const SizedBox(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 65,
                                                child: Text(
                                                  data.subcategoryName ?? "",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: size.width * 0.028),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(width: 5)
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.7,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: SizeConfig.screenWidth! - 90,
                              child: state.categoryVendorList.isEmpty
                                  ? Container(
                                      height: size.height * 0.6,
                                      width: SizeConfig.screenWidth! - 90,
                                      alignment: Alignment.center,
                                      child: const Text("No Vendor found"))
                                  : GridView.builder(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      itemCount: state.categoryVendorList.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: size.width * 0.0017,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        VendorProfile data = state.categoryVendorList[index];
                                        return VendorContainer(
                                          index: index,
                                          size: size,
                                          data: data,
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10)
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }
}

/*InkWell(
                            onTap: () {},
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
                                              width: double.infinity,
                                              child: state.categoryIndex == 0 ||
                                                      state.categoryIndex == 5 ||
                                                      state.categoryIndex == 7
                                                  ? Image.network(
                                                      "http://clipart-library.com/image_gallery/327825.png",
                                                      fit: BoxFit.contain,
                                                    )
                                                  : state.categoryIndex % 2 == 0
                                                      ? Image.network(
                                                          "https://freepngimg.com/thumb/onion/164056-onion-free-transparent-image-hd.png",
                                                          fit: BoxFit.contain,
                                                        )
                                                      : Image.network(
                                                          "https://image.similarpng.com/very-thumbnail/2020/06/Lemon-vector-transparent-PNG.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            state.categoryIndex % 2 == 0 ? "Capsicum" : "Tomato",
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.7),
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
                                                    "$rupeeSign ${index % 2 == 0 ? "50.00/Kg" : "70.00/Kg"}",
                                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 11.5,
                                                        letterSpacing: 0.7),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "$rupeeSign ${index % 2 == 0 ? "50.00/Kg" : "70.00/Kg"}",
                                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        color: Colors.grey,
                                                        decoration: TextDecoration.lineThrough,
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 10,
                                                        letterSpacing: 0.7),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColors.primary,
                                            child: Icon(Icons.add, size: 23, color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                )),
                          )*/
