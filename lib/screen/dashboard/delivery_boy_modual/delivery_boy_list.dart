import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/helper/navigations.dart';
import 'package:sub_franchisee/models/delivery_model.dart';
import 'package:sub_franchisee/screen/dashboard/delivery_boy_modual/delivery_boy_detail.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/screen/widgets/custom_widgets.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';

import '../../../helper/app_config.dart';
import '../../widgets/custom_btn.dart';

class DeliveryBoyList extends StatefulWidget {
  const DeliveryBoyList({Key? key}) : super(key: key);

  @override
  State<DeliveryBoyList> createState() => _DeliveryBoyListState();
}

class _DeliveryBoyListState extends State<DeliveryBoyList> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        if (state.profileDetails != null) {
          await state.getAllDeliveryBoy(state.profileDetails!.userID ?? "0");
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(size: size, title: "Delivery Boy"),
          Consumer<CustomViewModel>(builder: (context, state, build) {
            return Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : state.deliveryBoyList.isEmpty
                      ? const Center(child: Text("No Delivery Boy found!!!"))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingText(size: size, texts: "Total number of Delivery boy"),
                                const SizedBox(height: 15),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.deliveryBoyList.length,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    DeliveryModel data = state.deliveryBoyList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        push(context, DeliveryBoyDetail(isNew: false, data: data));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 10),
                                        margin: const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: size.width * 0.126,
                                              height: size.width * 0.126,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.2),
                                                border: Border.all(color: Colors.white, width: 1.5),
                                                shape: BoxShape.circle,
                                                image: const DecorationImage(
                                                  image: AssetImage("assets/user.png"),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: data.deliverypersonPic == null || data.deliverypersonPic == ""
                                                    ? const SizedBox()
                                                    : CachedNetworkImage(
                                                        imageUrl: "${AppConfig.apiUrl}${data.deliverypersonPic ?? ""}",
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context, url, error) =>
                                                            const Image(image: AssetImage("assets/user.png")),
                                                      ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.02),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.4,
                                                  child: Text(
                                                    "${data.deliverypersonFname ?? "Delivery"} ${data.deliverypersonLname ?? "Boy"}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: size.width * 0.043,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: size.width * 0.01),
                                                Text(
                                                  "+91 ${data.deliverypersonMobileno1 ?? "1234567894"}",
                                                  style: TextStyle(
                                                      fontSize: size.width * 0.035,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: index % 3 == 0
                                                    ? AppColors.primary
                                                    : index % 2 == 0
                                                        ? Colors.grey
                                                        : AppColors.red,
                                              ),
                                              child: Text(
                                                index % 3 == 0
                                                    ? "Available"
                                                    : index % 2 == 0
                                                        ? "In Holiday"
                                                        : "In Delivery",
                                                style: TextStyle(
                                                    fontSize: size.width * 0.035,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
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
            );
          }),
          Padding(
            padding: EdgeInsets.only(
                right: size.width * 0.05,
                left: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom + 5,
                top: 5),
            child: CustomBtn(
              size: size,
              title: "Add new Delivery boy",
              onTap: () {
                push(context, const DeliveryBoyDetail(isNew: true));
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          )
        ],
      ),
    );
  }
}
