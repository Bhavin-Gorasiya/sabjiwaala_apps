import 'package:flutter/material.dart';

import '../screens/auth/signup_screen.dart';

class RatingStar extends StatelessWidget {
  final double rating;
  final Size size;

  const RatingStar({Key? key, required this.rating, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        star(index: 1),
        star(index: 2),
        star(index: 3),
        star(index: 4),
        star(index: 5),
      ],
    );
  }

  Widget star({required double index}) {
    return Icon(
      (rating >= index)
          ? Icons.star
          : rating > (index - 1)
              ? Icons.star_half
              : Icons.star_border,
      color: Colors.yellow.shade600,
      size: sizes(size.width * 0.05, 25, size),
    );
  }
}
