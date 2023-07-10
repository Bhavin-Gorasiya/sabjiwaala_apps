import 'package:delivery_app/helper/navigations.dart';
import 'package:flutter/material.dart';

import '../../helper/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  final Size size;
  final Widget? widget;
  final String? title;

  const CustomAppBar({Key? key, required this.size, this.widget, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          width: size.width,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            right: size.width * 0.05,
            left: size.width * 0.05,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.primary.withOpacity(0.6),
              AppColors.primary,
            ]),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: widget ??
              Text(
                title ?? "",
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
        ),
        if (widget == null)
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: GestureDetector(
              onTap: () {
                pop(context);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  top: 20,
                  right: size.width * 0.05,
                  left: size.width * 0.05,
                  bottom: 20,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
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
    this.horPad, this.boxShadow,
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
