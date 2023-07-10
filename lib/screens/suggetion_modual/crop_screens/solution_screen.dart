import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/fertilizer_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/product_details.dart';
import 'package:subjiwala_farmer/theme/colors.dart';

import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';

class SolutionScreen extends StatelessWidget {
  const SolutionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, right: 15, left: 10, bottom: 4),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
                const SizedBox(width: 5),
                Text(
                  "Cart",
                  style: GoogleFonts.poppins(
                      fontSize: size.width * 0.048, fontWeight: FontWeight.w500, color: Colors.white),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    width: size.width,
                    fit: BoxFit.fitWidth,
                    image: const NetworkImage("https://static.agrostar.in/static/DS_016.jpg"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                    child: Text(
                      "Secondary Symptoms - Use "
                      "pheromone traps on border crops with infested "
                      "fruits and plant basil on edges.",
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                    child: header(size: size, name: "The solution to this problem"),
                  ),
                  productContainer(
                    size: size,
                    index: 5,
                    name: "Baryx - Vegetable Fly Trap + Lure (One Set)",
                    img: "https://static.agrostar.in/static/AGS-CP-115_1.jpg",
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
