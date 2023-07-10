import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/models/product_model.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import '../../helper/app_config.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_widgets.dart';

class ProductHistory extends StatefulWidget {
  const ProductHistory({Key? key}) : super(key: key);

  @override
  State<ProductHistory> createState() => _ProductHistoryState();
}

class _ProductHistoryState extends State<ProductHistory> {
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
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getProduct();
      },
    );
    super.initState();
  }

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMMM');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Product history"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              width: size.width,
                              margin: EdgeInsets.only(right: size.width * 0.05),
                              height: 40,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                icon: const Icon(Icons.date_range_rounded),
                                label: Text(
                                  startDate == null
                                      ? "Select Date"
                                      : startDate!.day == endDate!.day
                                          ? format.format(startDate!)
                                          : "${format.format(startDate!)} - ${format.format(endDate!)}",
                                  style: TextStyle(
                                    fontSize: size.width * 0.035,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    // color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  await _showDatePicker(state);
                                },
                              ),
                            ),
                            state.filterProductData.isEmpty
                                ? Container(
                                    height: size.height * 0.7,
                                    width: size.width,
                                    alignment: Alignment.center,
                                    child: const Text("No Data found"),
                                  )
                                : ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.filterProductData.length,
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                                    itemBuilder: (context, index) {
                                      ProductModel product = state.filterProductData[index];
                                      return CustomContainer(
                                        horPad: 12,
                                        vertPad: 12,
                                        size: size,
                                        rad: 8,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.black26)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  height: size.width * 0.15,
                                                  width: size.width * 0.15,
                                                  imageUrl: (AppConfig.apiUrl + (product.inventorysfrPPic ?? '')),
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    "assets/sabjiwaala.jpeg",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.03),
                                            SizedBox(
                                              width: size.width * 0.62,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  dualText(
                                                      title: "Name: ",
                                                      desc: product.inventorysfrPname ?? "",
                                                      size: size),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      dualText(
                                                          title: "Price: ",
                                                          desc: "₹ ${product.inventorysfrPrice ?? ""}",
                                                          size: size),
                                                      dualText(
                                                          title: "Qty: ",
                                                          desc: product.inventorysfrQty ?? '',
                                                          size: size),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  dualText(
                                                      title: "Date: ",
                                                      desc: DateFormat('dd MMM yyyy, hh:mm a')
                                                          .format(product.inventorysfrDate ?? DateTime.now()),
                                                      size: size),
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
              ),
            );
          })
        ],
      ),
    );
  }

  Future<void> _showDatePicker(CustomViewModel state) async {
    final DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: Colors.grey,
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onSurface: Colors.grey,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate.start;
        endDate = pickedDate.end;
        state.filterProductHistory(start: startDate!, end: endDate!);
        int diff = endDate!.difference(startDate!).inDays;
        log(endDate!.difference(startDate!).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }
}
