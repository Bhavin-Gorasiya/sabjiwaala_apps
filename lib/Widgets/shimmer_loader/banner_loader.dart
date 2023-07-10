import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';

class BannerLoader extends StatelessWidget {
  final Size size;

  const BannerLoader({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 5, right: 15, left: 15),
        height: 180,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.bgColorCard,
        ),
      ),
    );
  }
}
