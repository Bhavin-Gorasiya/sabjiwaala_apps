import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';
import 'package:subjiwala_farmer/Widgets/shimmer_loader/text_loader.dart';

import '../../theme/colors.dart';
import '../../utils/size_config.dart';

class MainCategoryLoader extends StatelessWidget {
  const MainCategoryLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: SizeConfig.screenWidth,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: AppColors.bgColorCard,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [loader(), loader(), loader(), loader()],
      ),
    );
  }

  loader() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Container(
            width: 50,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const TextLoader(width: 50)
      ],
    );
  }
}

class CategoryLoader extends StatelessWidget {
  const CategoryLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

