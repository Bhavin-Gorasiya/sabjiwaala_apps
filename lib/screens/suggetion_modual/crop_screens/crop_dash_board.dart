import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/crop_screens/problem_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/crop_screens/seeds_screen.dart';
import '../../../theme/colors.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';

class CropDashBoard extends StatefulWidget {
  final String name;

  const CropDashBoard({Key? key, required this.name}) : super(key: key);

  @override
  State<CropDashBoard> createState() => _CropDashBoardState();
}

class _CropDashBoardState extends State<CropDashBoard> {
  @override
  void initState() {
    super.initState();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> screen = [SeedsScreen(name: widget.name), ProblemScreen(size: size)];
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
                      children: [
                        GestureDetector(
                          onTap: () {
                            pop(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: size.width * 0.055,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.035),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        container(name: "Seeds", size: size, index: 0),
                        container(name: "Problems", size: size, index: 1),
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
