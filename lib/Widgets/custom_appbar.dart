import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/auth/signup_screen.dart';

import '../theme/colors.dart';
import '../utils/helper.dart';

class CustomAppBar extends StatelessWidget {
  final Size size;
  final Widget? widget;
  final String? title;
  final Function? onTap;

  const CustomAppBar({Key? key, required this.size, this.widget, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          width: size.width,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            right: sizes(size.width * 0.05, 25, size),
            left: sizes(size.width * 0.05, 25, size),
            bottom: 15,
          ),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            // gradient: LinearGradient(colors: [
            //   AppColors.primary.withOpacity(0.6),
            //   AppColors.primary,
            // ]),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: widget ??
              Text(
                title ?? "",
                style: TextStyle(
                  fontSize: sizes(size.width * 0.055, 28, size),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
        ),
        if (widget == null)
          GestureDetector(
            onTap: () async {
              if(onTap != null)onTap!();
              pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.transparent,
              padding: EdgeInsets.only(
                top: 20,
                right: sizes(size.width * 0.05, 25, size),
                left: sizes(size.width * 0.05, 25, size),
              ),
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: sizes(size.width * 0.06, 30, size)),
            ),
          )
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Size size;
  final double rad;
  final Widget child;
  final double? margin;
  final double? vertPad;
  final double? horPad;
  final Color? boxShadow;

  const CustomContainer({
    Key? key,
    required this.size,
    required this.rad,
    required this.child,
    this.margin,
    this.vertPad,
    this.horPad,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: margin ?? 15),
      padding: EdgeInsets.symmetric(horizontal: horPad ?? size.width * 0.05, vertical: vertPad ?? 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rad),
        boxShadow: [
          BoxShadow(color: boxShadow ?? Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }
}
