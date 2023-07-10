import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/screen/dashboard/inventory_modual/popup_menu.dart';
import 'package:sub_franchisee/screen/dashboard/inventory_modual/request_history.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/navigations.dart';
import '../../../models/product_model.dart';
import '../../widgets/custom_widgets.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getInventory().then((value) => getItems());
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getInventory().then((value) => getItems());
      },
    );
    super.initState();
  }

  int totalItems = 0;
  double totalQty = 0;
  double totalAmount = 0;

  getItems() {
    totalItems = 0;
    totalQty = 0;
    totalAmount = 0;
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    for (InventoryModel inventory in state.inventoryData) {
      totalItems = totalItems + 1;
      totalQty = totalQty + double.parse(double.parse(inventory.userproductQty ?? "0").toStringAsFixed(2));
      totalAmount = totalAmount +
          (double.parse(inventory.userproductPrice ?? "0") * double.parse(inventory.userproductQty ?? "0"));
    }
    setState(() {});
  }

  String selectedTab = 'Organic Vegetables';
  String selectedStock = 'In Stock';
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSearch)
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bottomTextColumn(title: "Total Items", desc: "$totalItems", size: size),
                  bottomTextColumn(title: "Total Qty.", desc: "$totalQty Kg.", size: size),
                  bottomTextColumn(title: "Total Amount", desc: "₹ ${totalAmount.round()}/-", size: size),
                ],
              ),
            ),
        ],
      ),
      body: Consumer<CustomViewModel>(builder: (context, state, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 18,
                      bottom: 20,
                      right: size.width * 0.05,
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
                              child: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                          Text(
                            "Inventory",
                            style: TextStyle(
                              fontSize: size.width * 0.055,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      /*SizedBox(height: isSearch ? 15 : 0),*/
                    ],
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        GestureDetector(
                          onTap: () {
                            push(context, const RequestMoreHistory());
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 8, right: size.width * 0.05),
                            alignment: Alignment.topCenter,
                            width: size.width * 0.12,
                            height: size.width * 0.12,
                            color: Colors.transparent,
                            child: const Icon(Icons.history, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                tabContainer(
                    name: "In Stock",
                    size: size,
                    onTap: () {
                      setState(() {
                        selectedStock = "In Stock";
                      });
                    },
                    textColor: AppColors.primary,
                    isSelect: selectedStock == "In Stock",
                    btnColor: AppColors.primary),
                tabContainer(
                    name: "Low in Stock",
                    size: size,
                    onTap: () {
                      setState(() {
                        selectedStock = "Low in Stock";
                      });
                    },
                    textColor: const Color(0xFFAD8C5E),
                    isSelect: selectedStock == "Low in Stock",
                    btnColor: const Color(0xFFAD8C5E)),
                tabContainer(
                    name: "Out of Stock",
                    size: size,
                    onTap: () {
                      setState(() {
                        selectedStock = "Out of Stock";
                      });
                    },
                    textColor: AppColors.red,
                    isSelect: selectedStock == "Out of Stock",
                    btnColor: AppColors.red),
              ],
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                          child: Column(
                            children: [
                              detailText(
                                  data: InventoryModel(),
                                  name: "Item name",
                                  qty: "Qty (kg.)",
                                  price: "Price/kg",
                                  totalPrice: "Total (₹)",
                                  size: size,
                                  isTitle: true),
                              divideLine(size: size),
                              ListView.builder(
                                itemCount: state.inventoryData.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  InventoryModel inventory = state.inventoryData[index];
                                  if (selectedStock == "In Stock" &&
                                      double.parse(inventory.userproductQty ?? "0") > 5) {
                                    return detailText(
                                        data: inventory,
                                        name: inventory.userproductPname ?? "",
                                        qty: inventory.userproductQty ?? "0",
                                        price: "₹ ${inventory.userproductPrice ?? ""}/-",
                                        totalPrice: "₹ ${(double.parse(inventory.userproductPrice ?? "0"
                                            "") * double.parse(inventory.userproductQty ?? "0")).round()}",
                                        size: size);
                                  } else if (selectedStock == "Low in Stock" &&
                                      double.parse(inventory.userproductQty ?? "0") < 0) {
                                    return detailText(
                                        data: inventory,
                                        name: inventory.userproductPname ?? "",
                                        qty: inventory.userproductQty ?? "0",
                                        price: "₹ ${inventory.userproductPrice ?? ""}/-",
                                        totalPrice: "₹ ${(double.parse(inventory.userproductPrice ?? "0"
                                            "") * double.parse(inventory.userproductQty ?? "0")).round()}",
                                        size: size);
                                  } else if (selectedStock == "Out of Stock" &&
                                      double.parse(inventory.userproductQty ?? "0") == 0) {
                                    return detailText(
                                        data: inventory,
                                        name: inventory.userproductPname ?? "",
                                        qty: inventory.userproductQty ?? "0",
                                        price: "₹ ${inventory.userproductPrice ?? ""}/-",
                                        totalPrice: "₹ ${(double.parse(inventory.userproductPrice ?? "0"
                                            "") * double.parse(inventory.userproductQty ?? "0")).round()}",
                                        size: size);
                                  } else {
                                    return index == 0
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: size.height * 0.45,
                                            child: const Text("No Inventory found"),
                                          )
                                        : const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget detailText({
    required String name,
    required String qty,
    required String price,
    required String totalPrice,
    required Size size,
    required InventoryModel data,
    bool isTitle = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
            width: size.width * 0.22,
            alignmentGeometry: Alignment.topLeft,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.155,
            text: qty,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.2,
            text: price,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.18,
            text: totalPrice,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        isTitle
            ? SizedBox(width: size.width * 0.12)
            : PopupMenuItems(
                color: selectedStock == "In Stock"
                    ? AppColors.primary
                    : selectedStock == "Low in Stock"
                        ? const Color(0xFFAD8C5E)
                        : const Color(0xFFF67A71),
                data: data,
              ),
        // isTitle
        //     ? SizedBox(width: size.width * 0.12)
        //     : GestureDetector(
        //         onTap: () {},
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: 8),
        //           child: const Icon(
        //             Icons.more_vert,
        //             color: Colors.black54,
        //           ),
        //         ),
        //       )
        // Container(
        //   alignment: Alignment.center,
        //   padding: const EdgeInsets.symmetric(vertical: 2),
        //   decoration: BoxDecoration(
        //     color: isTitle
        //         ? Colors.transparent
        //         : selectedStock == "In Stock"
        //             ? AppColors.primary
        //             : selectedStock == "Low in Stock"
        //                 ? const Color(0xFFAD8C5E)
        //                 : AppColors.red,
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   width: size.width * 0.12,
        //   child: Text(
        //     isTitle ? "" : "Edit",
        //     style: TextStyle(color: Colors.white, fontSize: size.width * 0.035, fontWeight: FontWeight.w500),
        //   ),
        // )
      ],
    );
  }

  Widget container({required String name, required Size size}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = name;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: size.width * 0.16,
        width: size.width * 0.28,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(selectedTab == name ? 0.3 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.width * 0.042,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget bottomTextColumn({required String title, required String desc, required Size size}) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: size.width * 0.04,
            ),
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.045,
            ),
          ),
        ],
      ),
    );
  }
}
