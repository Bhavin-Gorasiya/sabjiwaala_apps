import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/helper/navigations.dart';
import 'package:sub_franchisee/screen/dashboard/offline_sell_screens/offline_sell.dart';
import 'package:sub_franchisee/screen/widgets/custom_btn.dart';

import '../../../helper/app_config.dart';
import '../../../models/product_model.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_widgets.dart';
import 'offline_sell_history.dart';

class SelectOrder extends StatefulWidget {
  const SelectOrder({Key? key}) : super(key: key);

  @override
  State<SelectOrder> createState() => _SelectOrderState();
}

class _SelectOrderState extends State<SelectOrder> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getInventory();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getInventory();
      },
    );
    super.initState();
  }

  List<InventoryModel> selectedProduct = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              // gradient: LinearGradient(colors: [
              //   AppColors.primary.withOpacity(0.6),
              //   AppColors.primary,
              // ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        top: 20,
                        right: size.width * 0.05,
                        left: size.width * 0.05,
                        bottom: 20,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    right: size.width * 0.05,
                    left: size.width * 0.05,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Select Product",
                        style: TextStyle(
                          fontSize: size.width * 0.055,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      push(context, const OfflineSellHistory());
                      // pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        top: 20,
                        right: size.width * 0.05,
                        left: size.width * 0.05,
                        bottom: 20,
                      ),
                      child: const Icon(Icons.history, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: Consumer<CustomViewModel>(builder: (context, state, child) {
                return SingleChildScrollView(
                  child: state.isLoading
                      ? Container(
                          height: size.height * 0.7,
                          width: size.width,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(color: AppColors.primary),
                        )
                      : state.inventoryData.isEmpty
                          ? Container(
                              height: size.height * 0.7,
                              width: size.width,
                              alignment: Alignment.center,
                              child: const Text("No Sell Data found"))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.inventoryData.length,
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 25),
                              itemBuilder: (context, index) {
                                InventoryModel data = state.inventoryData[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedProduct.isNotEmpty) {
                                            if (selectedProduct
                                                .where((element) => element.userproductId == data.userproductId)
                                                .isEmpty) {
                                              selectedProduct.add(data);
                                            } else {
                                              selectedProduct.removeWhere(
                                                  (element) => element.userproductId == data.userproductId);
                                            }
                                          } else {
                                            selectedProduct.add(data);
                                          }
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 12),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                width: size.width * 0.1,
                                                height: size.width * 0.1,
                                                imageUrl: "${AppConfig.apiUrl}${data.userproductPPic ?? ""}",
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) =>
                                                    const Image(image: AssetImage("assets/bg.png")),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                dualText(
                                                    title: "Price: ", desc: "₹ ${data.userproductPrice}", size: size),
                                                dualText(
                                                    title: "Qty: ",
                                                    desc: double.parse(data.userproductQty ?? "").toStringAsFixed(2),
                                                    size: size),
                                              ],
                                            ),
                                            const Spacer(),
                                            if (selectedProduct
                                                .where((element) => element.userproductId == data.userproductId)
                                                .isNotEmpty)
                                              const Icon(Icons.check_circle, color: AppColors.primary),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index + 1 != state.inventoryData.length)
                                      Container(height: 1, color: Colors.black26)
                                  ],
                                );
                              },
                            ),
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom / 2 + 15),
            child: CustomBtn(
                size: size,
                title: "Proceed",
                onTap: () {
                  if (selectedProduct.isNotEmpty) {
                    push(context, OfflineSellScreen(list: selectedProduct));
                    setState(() {
                      selectedProduct = [];
                    });
                  } else {
                    snackBar(context, "Please select product", color: AppColors.red);
                  }
                },
                btnColor: selectedProduct.isNotEmpty ? AppColors.primary : Colors.grey,
                radius: 10),
          )
        ],
      ),
    );
  }
}
