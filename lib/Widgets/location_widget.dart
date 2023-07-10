import 'package:flutter/material.dart';

import '../screens/auth/signup_screen.dart';
import '../theme/colors.dart';

class LocationWidget extends StatelessWidget {
  final Size size;

  const LocationWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
              radius: size.width * 0.045,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.menu, size: size.width * 0.06, color: Colors.white)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/banner1.jpg",
                height: 50,
              ),
            ],
          ),
          CircleAvatar(
              radius: size.width * 0.045,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.notifications, size: size.width * 0.06, color: Colors.white))
        ],
      ),
    );
  }
}
