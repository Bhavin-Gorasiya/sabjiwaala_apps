import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/Widgets/rating_star.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/fertilizer_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/widgets/cosausle_slider.dart';
import 'package:subjiwala_farmer/theme/colors.dart';

import '../../utils/helper.dart';
import '../auth/signup_screen.dart';
import 'cart_screen.dart';

class ProductDetail extends StatefulWidget {
  final String img;
  final String name;

  const ProductDetail({Key? key, required this.img, required this.name}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          left: sizes(size.width * 0.05, 25, size),
          right: sizes(size.width * 0.05, 25, size),
          top: 10,
        ),
        // height: MediaQuery.of(context).padding.bottom + size.width * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: size.width * 0.11,
              height: size.width * 0.11,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary,
                ),
              ),
              child: const Icon(Icons.shopping_cart,color: AppColors.primary),
            ),
            GestureDetector(
              onTap: (){
                push(context, const CartScreen());
              },
              child: Container(
                alignment: Alignment.center,
                width: size.width * 0.7,
                height: size.width * 0.11,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary,
                  ),
                ),
                child: Text(
                  "Add To Cart",
                  style: TextStyle(
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Details"),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCarousle(controller: _controller, img: widget.img),
                  const SizedBox(height: 15),
                  container(
                    size: size,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "₹ 450",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "₹ 600",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                            const Spacer(),
                            RatingStar(rating: 3.5, size: size),
                            Text(
                              "( 3.5 )",
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Price per unit  •  Including all texts",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                  container(
                    size: size,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header(size: size, name: "Key Points:"),
                        columnText(
                          size: size,
                          title: "Sowing season",
                          desc: "Note: This information may change due to changes in weather.",
                        ),
                        columnText(
                          size: size,
                          title: "Method of sowing",
                          desc: "Fair planting",
                        ),
                        columnText(
                          size: size,
                          title: "Sowing distance",
                          desc: "Furrow to furrow = 45 cm, plant to plant = 30 cm",
                        ),
                        columnText(
                          size: size,
                          title: "Special description",
                          desc: "A uniform ball size",
                        ),
                        columnText(
                          size: size,
                          title: "Maturity",
                          desc: "65-70 days after transplanting",
                        ),
                        columnText(
                          size: size,
                          title: "Special comment",
                          desc: "The information given here is for reference "
                              "only and depends on the soil type and climatic conditions. "
                              "Always refer to the product label and accompanying leaflets for "
                              "complete product details and usage.",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                    child: header(size: size, name: "Similar Products"),
                  ),
                  SizedBox(
                    height: size.width * 0.5,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // push(context, ProductDetail(name: name, img: img));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            width: size.width * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Image(
                                    image: NetworkImage(widget.img),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          widget.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: size.width * 0.03,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "₹ 450",
                                              style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "₹ 600",
                                              style: TextStyle(
                                                decoration: TextDecoration.lineThrough,
                                                fontSize: size.width * 0.035,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget container({required Size size, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: child,
    );
  }

  Widget header({required Size size, required String name}) {
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: size.width * 0.042,
      ),
    );
  }

  Widget columnText({required Size size, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.038,
            ),
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: size.width * 0.033,
            ),
          ),
        ],
      ),
    );
  }
}

Widget header({required Size size, required String name}) {
  return Text(
    name,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width * 0.042,
    ),
  );
}