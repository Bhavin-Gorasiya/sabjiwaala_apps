import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:sub_franchisee/helper/navigations.dart';

import '../../../helper/app_colors.dart';
import '../../../models/subscription_model.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/loading.dart';
import '../order_details.dart';

class SubOrderScreen extends StatelessWidget {
  final List<SubsProducts> list;
  final String img;
  final String name;
  final String vendorName;
  final String vendorMobile;
  final int mainIndex;

  const SubOrderScreen(
      {Key? key,
      required this.list,
      required this.img,
      required this.name,
      required this.mainIndex,
      required this.vendorName,
      required this.vendorMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: name, size: size),
          Consumer<CustomViewModel>(builder: (context, state, build) {
            return Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                child: Column(
                  children: [
                    CustomContainer(
                      size: size,
                      rad: 8,
                      vertPad: 12,
                      horPad: 12,
                      child:
                          column(title: "Vendor Details :", name: vendorName, mobile: "+91 $vendorMobile", size: size),
                    ),
                    Stack(
                      children: [
                        ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            SubsProducts data = list[index];
                            List<String> dates = data.subscriptionorderSDate!.split('-');
                            DateTime end = DateTime(int.parse(dates[2]), int.parse(dates[1]), int.parse(dates[0]));
                            String name = "";
                            int qty = 0;
                            int mrp = 0;

                            for (Product product in data.products!) {
                              int dummyQty = int.parse(product.productsubWeight ?? "0");
                              qty += (product.productsubUnit == "gm" ? dummyQty : dummyQty * 1000);
                              mrp += int.parse(product.productsubPrice ?? "0");
                              name += "${product.productsubName ?? ""}, ";
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  /*ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    child: CachedNetworkImage(
                                      height: size.width * 0.15,
                                      width: size.width * 0.15,
                                      fit: BoxFit.cover,
                                      imageUrl: img,
                                      placeholder: (context, url) => ImageLoader(
                                        height: size.width * 0.2,
                                        width: size.width * 0.2,
                                        radius: 10,
                                      ),
                                      errorWidget: (context, url, error) => const SizedBox(),
                                    ),
                                  ),*/
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: size.width * 0.85,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.5,
                                              child: Text(
                                                name.substring(0, name.length - 2),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: size.width * 0.036,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Date : ${DateFormat('MMM d, y').format(end)}",
                                              style: TextStyle(fontSize: size.width * 0.03, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Quantity : ${qty > 1000 ? qty / 1000 : qty} "
                                                  "${qty > 1000 ? "kg" : "gm"}",
                                                  style: TextStyle(fontSize: size.width * 0.03, color: Colors.black),
                                                ),
                                                Text(
                                                  "MRP : ₹ $mrp.00",
                                                  style: TextStyle(
                                                      fontSize: size.width * 0.033,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(
                                                        color: data.subscriptionorderStatus != "Pending"
                                                            ? AppColors.primary
                                                            : AppColors.red),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(
                                                    data.subscriptionorderDeliveryboyid == ""
                                                        ? "Assign"
                                                        : data.subscriptionorderStatus ?? 'Pending',
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (state.isLoading) const Loading()
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          if (list.first.subscriptionorderDeliveryboyid == "")
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: swipeBtm(
                  onSlide: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return AssignDeliverySheet(
                          size: size,
                          onTap: (String id) async {
                            CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                            if (id != "0") {
                              pop(context);
                              state.assignSubscription(orderID: list.first.subscriptionorderOid ?? "0", deliveryId: id);
                            }
                          },
                          btnTitle: "Assign",
                          popupTitle: "Are you sure want to Assign this Order?",
                        );
                      },
                    );
                  },
                  text: "Assign Delivery boy",
                  size: size,
                  color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  Widget column({required String title, required String name, required String mobile, required Size size}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.042,
                fontWeight: FontWeight.w600,
              ),
            ),
            text(size: size, text: name),
            text(size: size, text: mobile),
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            width: size.width * 0.3,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.primary)),
            child: textWithIcon(size: size, text: "Call now", icon: Icons.call_rounded, color: AppColors.primary),
          ),
        )
      ],
    );
  }

  Widget swipeBtm({required Function onSlide, required String text, required Size size, required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.05),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(15)),
      child: HorizontalSlidableButton(
        height: 45,
        isRestart: true,
        initialPosition: SlidableButtonPosition.start,
        buttonWidth: 60.0,
        color: Colors.transparent,
        width: double.infinity,
        onChanged: (SlidableButtonPosition position) {
          if (position == SlidableButtonPosition.end) {
            onSlide();
          }
        },
        label: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          margin: const EdgeInsets.all(5),
          height: 50,
          width: 60,
          child: const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ),
    );
  }
}
