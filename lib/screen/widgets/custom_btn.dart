import 'package:flutter/material.dart';

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
        width: width ?? double.infinity,
        padding: EdgeInsets.symmetric(vertical: padding ?? 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
          color: btnColor,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? size.width * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
