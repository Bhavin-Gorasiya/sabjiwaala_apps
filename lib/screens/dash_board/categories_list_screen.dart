import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/MainCategoryListParser.dart';
import 'package:subjiwala_farmer/Models/ProductListParser.dart';
import 'package:subjiwala_farmer/Widgets/app_dialogs.dart';
import 'package:subjiwala_farmer/Widgets/category_dropdown.dart';
import 'package:subjiwala_farmer/Widgets/shimmer_loader/image_loader.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import 'package:subjiwala_farmer/utils/helper.dart';
import '../../View Models/CustomViewModel.dart';
import '../../Widgets/custom_textfields.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/utils.dart';
import '../auth/signup_screen.dart';
import 'products_screens/edit_add_products.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({Key? key}) : super(key: key);

  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoad = false;
  TextEditingController qty = TextEditingController();
  bool isSearch = false;

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final providerListener = Provider.of<CustomViewModel>(context, listen: false);
        setState(() {
          isLoad = true;
        });
        providerListener.changeIndex(0);
        await providerListener.getAllMainCategory();
        await providerListener.getAllProducts();
        await providerListener.filterSubCatList(providerListener.categoryId ?? "0").then((value) {
          providerListener.filterProduct(
              catId: providerListener.categoryId ?? "0", subCatId: providerListener.subCategoryId ?? "0");
        });
        setState(() {
          isLoad = false;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> categoryList = Provider.of<CustomViewModel>(context).categoryList;
    CustomViewModel providerListener = Provider.of<CustomViewModel>(context, listen: false);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    bottom: 10,
                    right: sizes(size.width * 0.05, 25, size),
                    left: size.width * 0.05),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(right: 15),
                            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                        ),
                        CompanyDropDown(
                            selectedValue: categoryList.isEmpty
                                ? "Vegetables"
                                : categoryList[0].categoryName ?? "Vegetables"),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            push(context, const AddEditProductScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white24,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            child: Row(
                              children: [
                                Text(
                                  AppText.add[providerListener.language],
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Icon(Icons.add, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*Consumer<CustomViewModel>(builder: (context, state, child) {
            log("== height ${size.height}");
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tabContainer(
                    name: "In Stock",
                    size: size,
                    onTap: () {
                      providerListener.changeCategoryTab("In Stock");

                      providerListener.filterProduct(
                          catId: int.parse(providerListener.mainCategoryList[providerListener.categoryIndex].maincategoryID!),
                          stock: providerListener.categoryTab);
                    },
                    textColor: AppColors.primary,
                    isSelect: providerListener.categoryTab == "In Stock",
                    btnColor: AppColors.primary),
                tabContainer(
                    name: "Low in Stock",
                    size: size,
                    onTap: () {
                      providerListener.changeCategoryTab("Low in Stock");

                      providerListener.filterProduct(
                          catId: int.parse(providerListener.mainCategoryList[providerListener.categoryIndex].maincategoryID!),
                          stock: providerListener.categoryTab);
                    },
                    textColor: const Color(0xFFAD8C5E),
                    isSelect: providerListener.categoryTab == "Low in Stock",
                    btnColor: const Color(0xFFAD8C5E)),
                tabContainer(
                    name: "Out of Stock",
                    size: size,
                    onTap: () {
                      providerListener.changeCategoryTab("Out of Stock");

                      providerListener.filterProduct(
                          catId: int.parse(providerListener.mainCategoryList[providerListener.categoryIndex].maincategoryID!),
                          stock: providerListener.categoryTab);
                    },
                    textColor: AppColors.red,
                    isSelect: providerListener.categoryTab == "Out of Stock",
                    btnColor: AppColors.red)
              ],
            );
          }),*/
          const SizedBox(height: 15),
          isLoad
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Consumer<CustomViewModel>(builder: (context, providerListener, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                            color: AppColors.bgColorCard,
                          ),
                          width: 85,
                          height: size.height * 0.65,
                          child: providerListener.filterSubCategoryList.isEmpty
                              ? const SizedBox()
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: providerListener.filterSubCategoryList.length,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        providerListener.changeIndex(index);
                                        providerListener.changeSubCatId(
                                            providerListener.filterSubCategoryList[index].subcategoryId ?? "");
                                        // providerListener.filterSubCatList(providerListener.categoryId ?? "0");
                                        providerListener.filterProduct(
                                            catId: providerListener.categoryId ?? "1",
                                            subCatId: providerListener.subCategoryId ?? '5');
                                        // providerListener.filterProduct(
                                        //     catId: int.parse(providerListener.subCategoryList[index].!),
                                        //     stock: providerListener.categoryTab);
                                      },
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 3,
                                                  height: 55,
                                                  color: providerListener.categoryIndex == index
                                                      ? Colors.green
                                                      : Colors.transparent),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                      color: AppColors.bgColorCard,
                                                    ),
                                                    width: size.width * 0.12,
                                                    height: size.width * 0.12,
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: AppConfig.apiUrl +
                                                              (providerListener
                                                                      .filterSubCategoryList[index].subcategoryFile ??
                                                                  ""),
                                                          placeholder: (context, url) => ImageLoader(
                                                            width: size.width * 0.12,
                                                            height: size.width * 0.12,
                                                            radius: 8,
                                                          ),
                                                        )

                                                        /* Image.network(
                                                  // "https://upload.wikimedia.org/wikipedia/commons/9/90/Hapus_Mango.jpg"
                                                  AppConfig.apiUrl +
                                                      (providerListener.mainCategoryList[index].maincategoryPic ?? ""),
                                                  fit: BoxFit.cover,
                                                ),*/
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: SizedBox(
                                                      width: size.width * 0.18,
                                                      child: Text(
                                                        providerListener.filterSubCategoryList[index].subcategoryName ??
                                                            "",
                                                        textAlign: TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 9,
                                                            letterSpacing: 1,
                                                            wordSpacing: 1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: SizedBox(
                          // color: Colors.black54,
                          height: size.height < 600 ? size.height * 0.7 : size.height * 0.78,
                          child: providerListener.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                )
                              : providerListener.filterProductList.isEmpty
                                  ? Center(
                                      child: Text(AppText.noProductFound[providerListener.language]),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: providerListener.filterProductList.length,
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, indexes) {
                                        ProductListParser product = providerListener.filterProductList[indexes];
                                        return InkWell(
                                          onTap: () {
                                            // push(context, ProductDetails(product: product));
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(left: 10, bottom: 10),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                                color: AppColors.bgColorCard,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                /*Text(
                                                          "Invoice",
                                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: size.width * 0.034,
                                                                letterSpacing: 0.7,
                                                              ),
                                                        ),
                                                        Text(
                                                          (providerListener.productList[1].productInvoiceno ?? ""),
                                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: size.width * 0.028,
                                                              letterSpacing: 0.7),
                                                        ),*/
                                                                const SizedBox(height: 10),
                                                                Container(
                                                                  decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(15.0)),
                                                                    color: AppColors.bgColorCardDarkGrey,
                                                                  ),
                                                                  height: size.width / 2.2 / 2.5,
                                                                  width: size.width / 5,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    child: product.productPic != ""
                                                                        ? CachedNetworkImage(
                                                                            fit: BoxFit.cover,
                                                                            imageUrl: AppConfig.apiUrl +
                                                                                (product.productPic ?? ""),
                                                                            placeholder: (context, url) => ImageLoader(
                                                                              height: size.width / 2.2 / 2.5,
                                                                              width: size.width / 5,
                                                                              radius: 8,
                                                                            ),
                                                                            errorWidget: (context, url, error) =>
                                                                                const Icon(
                                                                              Icons.image_not_supported_outlined,
                                                                            ),
                                                                          )
                                                                        : const Icon(
                                                                            Icons.image_not_supported_outlined,
                                                                          ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: size.width * 0.023),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  (product.productName ?? ""),
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .displaySmall
                                                                      ?.copyWith(
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: size.width * 0.038,
                                                                        letterSpacing: 0.7,
                                                                      ),
                                                                ),
                                                                const SizedBox(height: 4),
                                                                Text(
                                                                  "$rupeeSign ${product.productPrice ?? ""}/Kg",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .displaySmall
                                                                      ?.copyWith(
                                                                          fontWeight: FontWeight.w800,
                                                                          fontSize: size.width * 0.032,
                                                                          letterSpacing: 0.7),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                if (providerListener.isContractFull)
                                                                  Text(
                                                                    AppText.available[providerListener.language] +
                                                                        "${product.productQty ?? ""} ${AppText.kg[providerListener.language]}",
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .displaySmall
                                                                        ?.copyWith(
                                                                            color: Colors.green.shade800,
                                                                            fontWeight: FontWeight.w800,
                                                                            fontSize: size.width * 0.028,
                                                                            letterSpacing: 0.7),
                                                                  )
                                                                else
                                                                  (int.parse(product.productQty ?? "0") > 50)
                                                                      ? Text(
                                                                          "${AppText.available[providerListener.language]}:  ${product.productQty ?? ""} ${AppText.kg[providerListener.language]}",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .displaySmall
                                                                              ?.copyWith(
                                                                                  color: Colors.green.shade800,
                                                                                  fontWeight: FontWeight.w800,
                                                                                  fontSize: size.width * 0.028,
                                                                                  letterSpacing: 0.7),
                                                                        )
                                                                      : (int.parse(product.productQty ?? "0") <= 50 &&
                                                                              int.parse(product.productQty ?? "0") <=
                                                                                  10)
                                                                          ? Text(
                                                                              AppText.outOfStock[
                                                                                      providerListener.language] +
                                                                                  "(${product.productQty ?? ""} ${AppText.kg[providerListener.language]})",
                                                                              style: Theme.of(context)
                                                                                  .textTheme
                                                                                  .displaySmall
                                                                                  ?.copyWith(
                                                                                      color: Colors.red.shade800,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: size.width * 0.03,
                                                                                      letterSpacing: 0.7),
                                                                            )
                                                                          : Text(
                                                                              AppText.only[providerListener.language] +
                                                                                  ((product.productQty ?? "") +
                                                                                      AppText.kgLeft[
                                                                                          providerListener.language]),
                                                                              style: Theme.of(context)
                                                                                  .textTheme
                                                                                  .displaySmall
                                                                                  ?.copyWith(
                                                                                      color: const Color(0xFFAD8C5E),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: size.width * 0.03,
                                                                                      letterSpacing: 0.7),
                                                                            ),
                                                                const SizedBox(height: 10),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          AppText.harvestedOn[providerListener.language] +
                                                              " ${product.productHarvestFrom} To ${product.productHarvestTo}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: size.width * 0.027,
                                                              letterSpacing: 0.7),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        // Row(
                                                        //   children: [
                                                        //     RatingStar(rating: 3, size: size),
                                                        //     Text(
                                                        //       "( 3.0 )",
                                                        //       style: TextStyle(fontSize: size.width * 0.034),
                                                        //     ),
                                                        //     const Spacer(),
                                                        //     GestureDetector(
                                                        //       onTap: () {
                                                        //         showDialog(
                                                        //           // useSafeArea: false,
                                                        //           context: context,
                                                        //           builder: (context) => customPopup(
                                                        //             contex: context,
                                                        //             onTap: () {},
                                                        //             size: size,
                                                        //             desc: 'Enter Quantity of items in Kg. you '
                                                        //                 'want to add in stock',
                                                        //             heading: 'Add more Stocks',
                                                        //             btnName: 'Add',
                                                        //           ),
                                                        //         );
                                                        //       },
                                                        //       child: Container(
                                                        //         padding: const EdgeInsets.symmetric(
                                                        //             vertical: 3, horizontal: 5),
                                                        //         decoration: BoxDecoration(
                                                        //           borderRadius: BorderRadius.circular(5),
                                                        //           color: providerListener.categoryTab == "In Stock"
                                                        //               ? AppColors.primary
                                                        //               : providerListener.categoryTab == "Low in Stock"
                                                        //                   ? const Color(0xFFAD8C5E)
                                                        //                   : AppColors.red,
                                                        //         ),
                                                        //         child: Text(
                                                        //           "Add Stocks",
                                                        //           style: TextStyle(
                                                        //               color: Colors.white,
                                                        //               fontSize: size.width * 0.035),
                                                        //         ),
                                                        //       ),
                                                        //     )
                                                        //   ],
                                                        // ),
                                                        // const SizedBox(height: 4),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          providerListener
                                                              .filterSubCatList(product.productCatid ?? "0");
                                                          push(
                                                              context,
                                                              AddEditProductScreen(
                                                                  product: product,
                                                                  index: providerListener.categoryIndex));
                                                        },
                                                        child: CircleAvatar(
                                                            radius: size.width * 0.035,
                                                            backgroundColor: providerListener.categoryTab == "In Stock"
                                                                ? AppColors.primary
                                                                : providerListener.categoryTab == "Low in Stock"
                                                                    ? const Color(0xFFAD8C5E)
                                                                    : AppColors.red,
                                                            child: Icon(Icons.edit,
                                                                size: size.width * 0.045, color: Colors.white)),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 35,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          popup(
                                                              size: size,
                                                              context: context,
                                                              isBack: true,
                                                              title: AppText
                                                                  .areUSureWantDeleteP[providerListener.language],
                                                              onYesTap: () async {
                                                                await providerListener
                                                                    .deleteProduct(product.productId.toString());
                                                              });
                                                        },
                                                        child: CircleAvatar(
                                                            radius: size.width * 0.035,
                                                            backgroundColor: AppColors.red,
                                                            child: Icon(Icons.delete,
                                                                size: size.width * 0.045, color: Colors.white)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        );
                                      },
                                    ),
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  );
                }),
        ],
      ),
    );
  }

  Widget customPopup({
    required Size size,
    required String desc,
    required String heading,
    required String btnName,
    required String language,
    required BuildContext contex,
    Function? onTap,
  }) {
    log("${MediaQuery.of(context).viewPadding.bottom}");
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: _key,
        child: Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading,
                          style: TextStyle(
                            fontSize: sizes(size.width * 0.05, 25, size),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.red,
                            radius: size.width * 0.04,
                            child: const Icon(Icons.clear, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: size.width * 0.038,
                      ),
                    ),
                    CustomTextFields(
                      hintText: AppText.qtyInKg[language],
                      controller: qty,
                      keyboardType: TextInputType.phone,
                      validation: AppText.enterSomeValue[language],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          pop(contex);
                          if (onTap != null) onTap();
                        }
                      },
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(size.width * 0.2),
                        ),
                        child: Text(
                          btnName,
                          style: TextStyle(
                            fontSize: sizes(size.width * 0.05, 25, size),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 15)
            ],
          ),
        ),
      ),
    );
  }
}
