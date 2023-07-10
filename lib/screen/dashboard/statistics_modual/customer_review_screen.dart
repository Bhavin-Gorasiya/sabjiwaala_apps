import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';

import '../../../helper/app_config.dart';
import '../../../models/product_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/rating_star.dart';

class CustomerReview extends StatefulWidget {
  const CustomerReview({Key? key}) : super(key: key);

  @override
  State<CustomerReview> createState() => _CustomerReviewState();
}

class _CustomerReviewState extends State<CustomerReview> {
  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.width * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.nameList.length + 1,
            itemBuilder: (context, index) {
              return tabContainer(
                  name: index == 0 ? "All" : state.nameList[index - 1].userproductPname ?? "",
                  size: size,
                  onTap: () {
                    setState(() {
                      selectedTab = index == 0 ? "All" : state.nameList[index - 1].userproductPname ?? "";
                    });
                    state.filterReviewList(selectedTab);
                  },
                  width: size.width / 4.1,
                  isSelect: selectedTab == (index == 0 ? "All" : state.nameList[index - 1].userproductPname ?? ""),
                  btnColor: AppColors.primary);
            },
          ),
        ),
        Consumer<CustomViewModel>(builder: (context, state, child) {
          return Expanded(
            child: state.filterGetReview.isEmpty
                ? const Center(child: Text("No review yet..."))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.filterGetReview.length,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                    itemBuilder: (context, index) {
                      Review review = state.filterGetReview[index];
                      return CustomContainer(
                        size: size,
                        rad: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    width: size.width * 0.14,
                                    height: size.width * 0.14,
                                    imageUrl: "${AppConfig.apiUrl}${review.productPicture ?? ""}",
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Image(image: AssetImage("assets/user.png")),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.productName ?? "Product",
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        RatingStar(rating: double.parse(review.reviewRating ?? "0.0")),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${review.reviewRating}/5",
                                          style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              review.customerName ?? "User",
                              style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              review.reviewDesc ?? "",
                              style: TextStyle(
                                fontSize: size.width * 0.032,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          );
        }),
      ],
    );
  }
}
