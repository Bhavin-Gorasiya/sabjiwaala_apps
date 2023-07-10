import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/fertilizer_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/product_details.dart';

import '../auth/signup_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(size: size, title: "Seeds"),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size),vertical: 15),
                    child: header(size: size, name: "Seed Products"),
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
            ),
          ),
        ],
      ),
    );
  }
}
