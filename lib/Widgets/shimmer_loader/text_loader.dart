import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';

class TextLoader extends StatelessWidget {
  final double? height;
  final double? width;

  const TextLoader({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        height: height ?? 10,
        width: width ?? 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: AppColors.bgColorCard,
        ),
      ),
    );
  }
}
