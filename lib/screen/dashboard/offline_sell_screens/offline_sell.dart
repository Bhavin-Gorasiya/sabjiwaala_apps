import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/helper/navigations.dart';
import 'package:sub_franchisee/models/order_model.dart';
import 'package:sub_franchisee/models/product_model.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/screen/widgets/custom_widgets.dart';
import 'package:sub_franchisee/screen/widgets/loading.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/app_config.dart';
import '../../widgets/company_name_dropdown.dart';

class OfflineSellScreen extends StatefulWidget {
  final List<InventoryModel> list;

  const OfflineSellScreen({Key? key, required this.list}) : super(key: key);

  @override
  State<OfflineSellScreen> createState() => _OfflineSellScreenState();
}

class _OfflineSellScreenState extends State<OfflineSellScreen> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getUnits();
    await state.getDiscount();
    addKey();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getUnits();
        await state.getDiscount();
        addKey();
      },
    );
    super.initState();
  }

  List<GlobalKey<PopupMenuButtonState>> keyList = [];
  List<String> selectedUnit = [];
  List<int> qty = [];
  List<Productdatum> productData = [];

  addKey() {
    keyList = [];
    selectedUnit = [];
    discount = 0;
    totalPrice = 0;
    discountPrice = 0;
    productData = [];
    qty = [];
    for (int i = 0; i < widget.list.length; i++) {
      setState(() {
        keyList.add(GlobalKey<PopupMenuButtonState>());
        selectedUnit.add("Kg");
        qty.add(0);
      });
    }
  }

  int discount = 0;
  double totalPrice = 0;
  double discountPrice = 0;

  getPrice({required int price, required String unit, required int qty, required bool isAdd}) {
    discountPrice = 0;
    discount = 0;
    if (isAdd) {
      if (unit == "gm") {
        totalPrice += price * (100 / 1000);
      } else {
        totalPrice += price;
      }
    } else {
      if (unit == "gm") {
        totalPrice -= price * (50 / 1000);
      } else {
        totalPrice -= price;
      }
    }
    setState(() {});
  }

  String selectedValue = "All Companies";

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Offline Sell"),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: Consumer<CustomViewModel>(builder: (context, state, child) {
                return Stack(
                  children: [
                    state.isLoading || keyList.isEmpty
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingText(size: size, texts: "Review Items"),
                                const SizedBox(height: 10),
                                CustomContainer(
                                  margin: 25,
                                  size: size,
                                  rad: 10,
                                  child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 5),
                                    itemCount: widget.list.length,
                                    itemBuilder: (context, index) {
                                      InventoryModel data = widget.list[index];
                                      return Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 12),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                width: size.width * 0.13,
                                                height: size.width * 0.13,
                                                imageUrl: "${AppConfig.apiUrl}${data.userproductPPic ?? ""}",
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) =>
                                                    const Image(image: AssetImage("assets/bg.png")),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.03),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                dualText(
                                                    title: "Price: ",
                                                    desc: "₹ ${data.userproductPrice}",
                                                    textsize: size.width * 0.031,
                                                    size: size),
                                                dualText(
                                                  title: "Qty: ",
                                                  desc: "${double.parse(data.userproductQty ?? ""
                                                      "").toStringAsFixed(2)} Kg",
                                                  size: size,
                                                  textsize: size.width * 0.031,
                                                ),
                                                CompanyDropDown(
                                                  dropdownKey: keyList[index],
                                                  selectedValue: selectedUnit[index],
                                                  onTap: (String org, String pic) {
                                                    setState(() {
                                                      if (selectedUnit[index] == "gm") {
                                                        totalPrice -= (int.parse(data.userproductPrice ?? "0") *
                                                            (qty[index] / 1000));
                                                      } else {
                                                        totalPrice -=
                                                            (int.parse(data.userproductPrice ?? "0") * qty[index]);
                                                      }
                                                      productData.removeWhere((e) {
                                                        return e.productID == data.userproductId;
                                                      });
                                                      selectedUnit[index] = org;
                                                      qty[index] = 0;
                                                      discount = 0;
                                                      discountPrice = 0;
                                                      // productData.removeWhere((element) => element.productID)
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              // width: size.width * 0.18,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primary, borderRadius: BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (qty[index] > 0) {
                                                        setState(() {
                                                          if (selectedUnit[index] == "gm") {
                                                            if (qty[index] >= 50) {
                                                              qty[index] -= 50;
                                                            }
                                                          } else {
                                                            qty[index] -= 1;
                                                          }
                                                        });
                                                        getPrice(
                                                            isAdd: false,
                                                            price: int.parse(data.userproductPrice ?? "0"),
                                                            unit: selectedUnit[index],
                                                            qty: qty[index]);
                                                        int price = int.parse(data.userproductPrice ?? "0");
                                                        if (selectedUnit[index] == "gm") {
                                                          price = ((price / 1000) * qty[index]).round();
                                                        } else {
                                                          // log("===>>> product productTotalamt1 ${price.toString()}");
                                                          price = (price * qty[index]).round();
                                                          // log("===>>> product productTotalamt ${price.toString()}");
                                                        }
                                                        setState(() {
                                                          removeProduct(
                                                            Productdatum(
                                                                name: data.userproductPname ?? "",
                                                                productUnit: "Kg",
                                                                pQty: selectedUnit[index] == "gm"
                                                                    ? (qty[index] / 1000).toString()
                                                                    : qty[index].toString(),
                                                                productTotalamt: price.toString(),
                                                                productMrp: data.userproductPrice,
                                                                productID: data.userproductId),
                                                          );
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "-",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.038,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    qty[index].toString(),
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.038,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        if (selectedUnit[index] == "gm") {
                                                          qty[index] += 100;
                                                        } else {
                                                          qty[index] += 1;
                                                        }
                                                      });
                                                      getPrice(
                                                          isAdd: true,
                                                          price: int.parse(data.userproductPrice ?? "0"),
                                                          unit: selectedUnit[index],
                                                          qty: qty[index]);

                                                      int price = int.parse(data.userproductPrice ?? "0");
                                                      if (selectedUnit[index] == "gm") {
                                                        price = ((price / 1000) * qty[index]).round();
                                                        // log("===>>> product data ${price.toString()}");
                                                      } else {
                                                        price = price * qty[index];
                                                      }

                                                      setState(() {
                                                        addProduct(
                                                          Productdatum(
                                                              name: data.userproductPname ?? "",
                                                              productUnit: "Kg",
                                                              pQty: selectedUnit[index] == "gm"
                                                                  ? (qty[index] / 1000).toString()
                                                                  : qty[index].toString(),
                                                              productTotalamt: price.toString(),
                                                              productMrp: data.userproductPrice,
                                                              productID: data.userproductId),
                                                        );
                                                      });
                                                      // log("===>>> product productTotal amt add ${productData.length}
                                                      // ${productData.first.productTotalamt}");
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "+",
                                                        style: TextStyle(
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
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (productData.isNotEmpty) headingText(size: size, texts: "Bill Details"),
                                const SizedBox(height: 10),
                                if (productData.isNotEmpty)
                                  CustomContainer(
                                    size: size,
                                    rad: 10,
                                    child: Column(
                                      children: [
                                        detailText(
                                            name: "Item Name",
                                            qty: "Qty ( weight )",
                                            price: "Amount",
                                            size: size,
                                            isTitle: true),
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(top: 5),
                                          itemCount: productData.length,
                                          itemBuilder: (context, index) {
                                            Productdatum data = productData[index];
                                            double qty = double.parse(data.pQty ?? "");
                                            return detailText(
                                                name: data.name ?? "",
                                                qty:
                                                    "${qty < 1 ? (qty * 1000).round() : qty.round()} ${qty < 1 ? "gm" : "Kg"}",
                                                price: "₹ ${data.productTotalamt ?? "0"}/-",
                                                size: size);
                                          },
                                        ),
                                        if (discount != 0)
                                          Container(
                                              height: 1,
                                              color: Colors.black26,
                                              margin: const EdgeInsets.symmetric(vertical: 10)),
                                        if (discount != 0)
                                          detailText(
                                              name: "Discount",
                                              qty: "$discount %",
                                              isSave: true,
                                              price: "-₹ ${(totalPrice.round() - discountPrice.round())}/-",
                                              size: size),
                                        Container(
                                            height: 1,
                                            color: Colors.black26,
                                            margin: const EdgeInsets.symmetric(vertical: 10)),
                                        detailText(
                                            name: "Total Amount",
                                            qty: "",
                                            isTotal: true,
                                            price:
                                                "₹ ${discountPrice == 0 ? totalPrice.round() : discountPrice.round()}/-",
                                            size: size)
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                    if (state.sellLoading) const Loading()
                  ],
                );
              }),
            ),
          ),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return state.isLoading || keyList.isEmpty
                ? const SizedBox()
                : Container(
                    width: size.width,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom / 2 + 15,
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                        top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        color: AppColors.primary),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.width * 0.1,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            itemCount: state.discountList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              Discount data = state.discountList[index];
                              return GestureDetector(
                                onTap: () {
                                  if (totalPrice > 8.0 && discount != int.parse(data.discountPercent ?? "0")) {
                                    setState(() {
                                      discount = int.parse(data.discountPercent ?? "0");
                                      discountPrice = (totalPrice - (totalPrice * (discount / 100))).roundToDouble();
                                      // log("===>>> 1 $discount $discountPrice
                                      // ${totalPrice - (totalPrice * (discount / 100))}");
                                    });
                                  } else {
                                    setState(() {
                                      discount = 0;
                                      discountPrice = 0;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: discount == int.parse(data.discountPercent ?? "0") ? 2 : 1,
                                          color: discount == int.parse(data.discountPercent ?? "0")
                                              ? Colors.white
                                              : Colors.white54)),
                                  child: Text(
                                    data.discountPercent ?? "0",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: discount == int.parse(data.discountPercent ?? "0")
                                            ? FontWeight.bold
                                            : null),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${qty.where((qty) => qty > 0).length} item in cart",
                                  style: TextStyle(
                                      fontSize: size.width * 0.034, fontWeight: FontWeight.w500, color: Colors.white),
                                ),
                                Text(
                                  "₹ ${discountPrice == 0 ? totalPrice.roundToDouble() : discountPrice.roundToDouble()}0/-",
                                  style: TextStyle(
                                      fontSize: size.width * 0.04, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                if (productData.isNotEmpty || state.sellLoading) {
                                  popup(
                                      size: size,
                                      context: context,
                                      title: "Are you sure you sold this items?",
                                      onYesTap: () async {
                                        final state = Provider.of<CustomViewModel>(context, listen: false);
                                        await state
                                            .offlineSell(
                                          OfflineSell(
                                              productdata: productData,
                                              offlineorderSubfrid: state.profileDetails!.userID ?? "",
                                              offlineorderDiscountid: discount.toString(),
                                              offlineorderSubtotal: totalPrice.round().toString(),
                                              offlineorderTotalamt:
                                                  "${discountPrice == 0 ? totalPrice.round() : discountPrice.round()}",
                                              offlineorderDiscountamt:
                                                  "${discountPrice == 0 ? 0 : (totalPrice.round() - discountPrice.round())}"),
                                        )
                                            .then((value) {
                                          pop(context);
                                          productData = [];
                                        });
                                      });
                                }
                                // log("====>>> data ${productData.map((e) => debugPrint("${e.toJson()}"))}");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                    color: productData.isEmpty ? Colors.white38 : Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  "Proceed to sell",
                                  style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: productData.isEmpty ? Colors.black54 : Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
          })
        ],
      ),
    );
  }

  Widget detailText({
    required String name,
    required String qty,
    required String price,
    required Size size,
    bool isTitle = false,
    bool isSave = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
            width: size.width * 0.3,
            alignmentGeometry: Alignment.topLeft,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.28,
            text: qty,
            size: size,
            isTotal: isTotal,
            color: isTitle
                ? Colors.black.withOpacity(0.7)
                : isSave
                    ? AppColors.primary
                    : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.18,
            text: price,
            size: size,
            isTotal: isTotal,
            color: isTitle
                ? Colors.black.withOpacity(0.7)
                : isSave
                    ? AppColors.primary
                    : Colors.black,
            vertPad: 2),
      ],
    );
  }

  addProduct(Productdatum data) {
    if (productData.where((element) => element.productID == data.productID).isNotEmpty) {
      productData.removeWhere((element) => element.productID == data.productID);
      productData.add(data);
    } else {
      productData.add(data);
    }
  }

  removeProduct(Productdatum data) {
    if (productData.where((element) => element.productID == data.productID).isNotEmpty) {
      if (data.productUnit == "gm" && data.pQty == "0") {
        productData.removeWhere((element) => element.productID == data.productID);
      } else if (data.productUnit == "Kg" && data.pQty == "0") {
        // log("  kg ===>>  ");
        productData.removeWhere((element) => element.productID == data.productID);
      } else {
        productData.removeWhere((element) => element.productID == data.productID);
        productData.add(data);
      }
    }
  }
}

/*class SellOffline extends StatefulWidget {
  const SellOffline({Key? key}) : super(key: key);

  @override
  State<SellOffline> createState() => _SellOfflineState();
}

class _SellOfflineState extends State<SellOffline> {
  String selectedValue = "Select Vegetables";

  TextEditingController qty = TextEditingController();
  TextEditingController price = TextEditingController();

  ProductName? selected;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Sell"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSearchableDropDown(
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                            ),
                            items: state.nameList,
                            dropdownItemStyle: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                            ),
                            label: 'Select Vegetables',
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54),
                            ),
                            dropDownMenuItems: state.nameList.map((item) {
                              return item.userproductPname;
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                log("==>>> new Value ${value.userproductID}");
                                selected = value;
                              } else {
                                selected = null;
                              }
                            },
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "Total Sell Qty. ( in gm. )",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.045),
                          ),
                          const SizedBox(height: 5),
                          CustomTextFields(hintText: "Quantity", controller: qty, keyboardType: TextInputType.phone),
                          CustomTextFields(hintText: "₹ Price", controller: price, keyboardType: TextInputType.phone),
                          const SizedBox(height: 25),
                          if (state.offlineSellItem.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primary),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "     Vegetables",
                                        style: TextStyle(fontSize: size.width * 0.035, color: Colors.black54),
                                      ),
                                      Text(
                                        "Qty. ( in gm. )     ",
                                        style: TextStyle(fontSize: size.width * 0.035, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.offlineSellItem.length,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Productdatum data = state.offlineSellItem[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${index + 1}.  ",
                                              style: TextStyle(fontSize: size.width * 0.038),
                                            ),
                                            Text(
                                              state.nameList
                                                      .where((element) => element.userproductID == data.productID)
                                                      .first
                                                      .userproductPname ??
                                                  "",
                                              style: TextStyle(fontSize: size.width * 0.038),
                                            ),
                                            const Spacer(),
                                            Container(
                                              alignment: Alignment.center,
                                              width: size.width * 0.2,
                                              child: Text(
                                                data.offlinesaleQty ?? "",
                                                style: TextStyle(fontSize: size.width * 0.038),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  state.removeProductName(data);
                                                });
                                              },
                                              child: Icon(Icons.delete, color: AppColors.red, size: size.width * 0.055),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading) const Loading()
                ],
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
            child: Column(
              children: [
                CustomBtn(
                    size: size,
                    title: "Add",
                    onTap: () {
                      if (qty.text.isNotEmpty) {
                        final state = Provider.of<CustomViewModel>(context, listen: false);
                        int qtys = int.parse(widget.list
                                .where((element) => element.userproductId == selected!.userproductID)
                                .first
                                .userproductQty ??
                            "0");
                        log("==>>. $qtys");
                        if (int.parse(qty.text) <= qtys) {
                          state.addProductName(Productdatum(
                              offlinesalePid: selected!.userproductID,
                              offlinesalePrice: price.text,
                              offlinesaleQty: qty.text,
                              offlinesaleVid: state.profileDetails!.userID ?? ""));
                          setState(() {
                            selectedValue = "Select Vegetables";
                            qty.clear();
                            price.clear();
                          });
                        } else {
                          snackBar(context, "You have not enough quantity", color: AppColors.red);
                        }
                      }
                    },
                    btnColor: AppColors.primary,
                    radius: 10),
                const SizedBox(height: 15),
                CustomBtn(
                    size: size,
                    title: "Update Sell",
                    onTap: () {
                      popup(
                          size: size,
                          context: context,
                          title: "Are you sure you sold this items?",
                          onYesTap: () async {
                            final state = Provider.of<CustomViewModel>(context, listen: false);
                            await state.offlineSell(OfflineSell(productdata: state.offlineSellItem)).then((value) {
                              pop(context);
                              state.clearProductName();
                            });
                          });
                    },
                    btnColor: AppColors.primary,
                    radius: 10),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          )
        ],
      ),
    );
  }
}*/
