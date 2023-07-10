import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helper/app_colors.dart';

class ImageLoader extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ImageLoader({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: AppColors.bgColorCard,
        ),
      ),
    );
  }
}
