import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/fertilizer_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/product_details.dart';

import '../../auth/signup_screen.dart';

class SeedsScreen extends StatelessWidget {
  final String name;
  const SeedsScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
            child: header(size: size, name: "All $name seeds"),
          ),
          productContainer(
            size: size,
            index: 10,
            name: "name",
            img: "https://static.agrostar.in/static/AGS-S-673_l.jpg",
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
        ],
      ),
    );
  }
}
