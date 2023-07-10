import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/crop_screens/all_crops_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/cart_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/fertilizer_screen.dart';

import '../../theme/colors.dart';
import '../../utils/helper.dart';
import '../auth/signup_screen.dart';

class SDashBoard extends StatefulWidget {
  const SDashBoard({Key? key}) : super(key: key);

  @override
  State<SDashBoard> createState() => _SDashBoardState();
}

class _SDashBoardState extends State<SDashBoard> {
  @override
  void initState() {
    super.initState();
  }

  int tabIndex = 0;
  List<Widget> screen = [const AllCropsScreen(),const FertilizerScreen()];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final providerListener = Provider.of<CustomViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subjiwaala",
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            push(context, const CartScreen());
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Icon(Icons.shopping_cart, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.035),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        container(name: "All Crops", size: size, index: 0),
                        container(name: "Fertilizer", size: size, index: 1),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: screen[tabIndex],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container({required String name, required Size size, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tabIndex == index ? Colors.white.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        width: size.width * 0.4,
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
