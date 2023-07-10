import 'package:delivery_app/screens/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../helper/app_colors.dart';

class ViewProfile extends StatelessWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "My Profile"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.22,
                      height: size.width * 0.22,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.7),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage("assets/bg.png"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    textContainer(title: "Full name", desc: "Bhavin gorasiya", size: size),
                    textContainer(title: "Mobile number", desc: "+91 9875641325", size: size),
                    textContainer(title: "Email ID", desc: "bhavin@gmail.com", size: size),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textContainer({required String title, required String desc, required Size size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.width * 0.038,
            fontWeight: FontWeight.w500,
            color: Colors.black87.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.02),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          child: Text(
            desc,
            style: TextStyle(
              fontSize: size.width * 0.041,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.8)
            ),
          ),
        )
      ],
    );
  }
}
