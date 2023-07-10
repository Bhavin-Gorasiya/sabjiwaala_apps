import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:subjiwala/Widgets/shimmer_loader/text_loader.dart';

import '../../theme/colors.dart';
import '../../utils/size_config.dart';

class ProductContainerLoader extends StatelessWidget {
  const ProductContainerLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenWidth! / 1.9,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 15, right: 15),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return productLoader();
        },
      ),
    );
  }

  productLoader() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: AppColors.bgColorCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: Container(
              height: 62,
              width: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.bgColorCard,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const TextLoader(height: 11),
          const SizedBox(height: 8),
          const TextLoader(height: 8),
          const SizedBox(height: 6),
          const TextLoader(height: 8),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
