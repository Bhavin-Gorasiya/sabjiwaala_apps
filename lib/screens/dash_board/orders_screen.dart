import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/order_model.dart';
import 'package:subjiwala_farmer/screens/auth/signup_screen.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import '../../View Models/CustomViewModel.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/custom_widgets.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/helper.dart';
import 'order_details.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getOrder();
        await state.getTransactionList();
      },
    );
    super.initState();
  }

  String selectedTab = 'Pending';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.pendingProduct[state.language]),
          const SizedBox(height: 4),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            final list =
                state.orderList.where((element) => (element.productTotalamt ?? 0) != (element.transactionAmt ?? 0));
            return Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : list.isEmpty
                      ? Center(
                          child: Text(AppText.noProducts[state.language]),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 20),
                          itemCount: state.orderList.length,
                          itemBuilder: (context, index) {
                            OrderModel data = state.orderList[index];
                            int totalP = data.productTotalamt ?? 0;
                            int transactionAmt = data.transactionAmt ?? 0;
                            int dueAmount = (data.productTotalamt ?? 0) - (data.transactionAmt ?? 0);
                            return totalP == transactionAmt
                                ? const SizedBox()
                                : SizedBox(
                                    width: sizes(size.width, 600, size),
                                    child: GestureDetector(
                                      onTap: () {
                                        push(context, OrderDetails(data: data, dueAmount: dueAmount));
                                      },
                                      child: CustomContainer(
                                        horPad: sizes(12, 15, size),
                                        vertPad: 7,
                                        size: size,
                                        boxShadow: AppColors.red.withOpacity(0.3),
                                        rad: 8,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: sizes(size.width * 0.16, 85, size),
                                              height: sizes(size.width * 0.16, 85, size),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: AppColors.primary.withOpacity(0.4),
                                                  border: Border.all(color: Colors.black12)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: AppConfig.apiUrl + (data.productPic ?? ""),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    "assets/banner2.png",
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                  placeholder: (context, url) => ImageLoader(
                                                      width: size.width * 0.16, height: size.width * 0.16, radius: 8),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: sizes(size.width * 0.03, 15, size)),
                                            SizedBox(
                                              width: sizes(size.width * 0.62, 370, size),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 2),
                                                  dualText(
                                                      title: AppText.productName[state.language], desc: "${data.productName}", size: size),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      dualText(
                                                          title: AppText.totalPrice[state.language],
                                                          desc: "₹ ${data.productTotalamt}",
                                                          size: size),
                                                      dualText(
                                                          title: "${AppText.qty[state.language]}: ", desc: "${data.productQty} ${AppText.kg[state.language]}", size: size),
                                                    ],
                                                  ),
                                                  dualText(
                                                    title: AppText.duePayment[state.language],
                                                    desc: "₹ $dueAmount",
                                                    size: size,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  dualText(
                                                      title: AppText.totalPayment[state.language],
                                                      desc: "₹ ${data.transactionAmt}",
                                                      size: size),
                                                  const SizedBox(height: 5),
                                                  if (selectedTab != "Pending")
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: selectedTab == "Completed"
                                                              ? AppColors.primary
                                                              : AppColors.red,
                                                          radius: size.width * 0.02,
                                                          child: Icon(
                                                            selectedTab == "Completed" ? Icons.check : Icons.close,
                                                            size: size.width * 0.035,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(selectedTab)
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
            );
          })
        ],
      ),
    );
  }

  Widget tabContainer({required String name, required Size size}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = name;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 2.5,
              width: size.width / 3 - 14,
              color: selectedTab == name ? Colors.white : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
