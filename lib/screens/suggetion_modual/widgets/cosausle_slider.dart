import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/dash_board/products_screens/product_detail.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/product_details.dart';
import 'package:subjiwala_farmer/utils/helper.dart';

import '../../../theme/colors.dart';

class CustomCarousle extends StatefulWidget {
  final CarouselController controller;
  final String img;

  const CustomCarousle({Key? key, required this.controller, required this.img}) : super(key: key);

  @override
  State<CustomCarousle> createState() => _CustomCarousleState();
}

class _CustomCarousleState extends State<CustomCarousle> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            carouselController: widget.controller,
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: false,
                // aspectRatio: 2.0,
                // height: 400,
                viewportFraction: 1.0,
                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: [0, 1, 2]
                .map(
                  (index) => Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 5, right: 15, left: 15),
                    width: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        push(
                            context,
                            ProductDetail(
                              img: widget.img,
                              name: "Gladiator Double Motor Battery Spray Pump (Orange)",
                            ));
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            color: AppColors.white,
                          ),
                          height: size.width / 2.1,
                          width: size.width,
                          child: CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: widget.img,
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ([0, 1, 2].map((entry) {
            return GestureDetector(
              onTap: () => widget.controller.animateToPage(entry),
              child: _current != entry
                  ? Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.only(top: 8.0, right: 8.0),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                    )
                  : Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.only(top: 8.0, right: 8.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
            );
          }).toList()),
        ),
      ],
    );
  }
}
