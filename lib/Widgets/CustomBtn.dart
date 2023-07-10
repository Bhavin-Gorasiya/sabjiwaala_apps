import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/theme/colors.dart';

import '../screens/auth/signup_screen.dart';

class CustomBtn extends StatelessWidget {
  final Size size;
  final String title;
  final Function onTap;
  final Color? btnColor;
  final double? width;
  final double? radius;
  final double? padding;
  final double? fontSize;

  const CustomBtn({
    Key? key,
    required this.size,
    required this.title,
    required this.onTap,
    this.btnColor,
    this.width,
    this.radius,
    this.padding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        width: sizes(width ?? double.infinity, 500, size),
        padding: EdgeInsets.symmetric(vertical: padding ?? 10),
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 10))),
        child: Text(
          title,
          style: TextStyle(
            fontSize: sizes(fontSize ?? size.width * 0.045, 22, size),
            color: btnColor == Colors.white ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
