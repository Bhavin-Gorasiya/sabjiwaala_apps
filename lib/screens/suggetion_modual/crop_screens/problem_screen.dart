import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/crop_screens/all_crops_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/crop_screens/solution_screen.dart';
import 'package:subjiwala_farmer/utils/helper.dart';

import '../../auth/signup_screen.dart';

class ProblemScreen extends StatelessWidget {
  final Size size;

  const ProblemScreen({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
      child: gridView(
        onTap: () {
          push(context, const SolutionScreen());
        },
        size: size,
        name: "Irregular shape of fruits",
        title: "Crop related problems",
        img: "https://static.agrostar.in/static/DS_016.jpg",
        item: 5,
      ),
    );
  }
}
