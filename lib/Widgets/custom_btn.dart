import 'package:flutter/material.dart';
import 'package:subjiwala/theme/colors.dart';

import '../utils/helper.dart';

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

Widget backBtn({required Size size, required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      pop(context);
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 5, bottom: 10, right: 10),
      child: Icon(Icons.arrow_back, size: size.width * 0.07, color: Colors.white),
    ),
  );
}

Widget appBar({required BuildContext context, required String title, required Size size}) {
  return Padding(
    // color: AppColors.primary,
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 3, right: 15, left: 10, bottom: 3),
    child: Row(
      children: [
        IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: AppColors.black.withOpacity(0.7))),
        const SizedBox(width: 5),
        SizedBox(
          width: size.width * 0.7,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: size.width * 0.048,
                letterSpacing: 1,
                wordSpacing: 1,
                color: AppColors.black),
          ),
        ),
      ],
    ),
  );
}

// class CustomContainer extends StatelessWidget {
//   final Size size;
//   final double rad;
//   final Widget child;
//   final double? margin;
//   final double? vertPad;
//   final double? horPad;
//   final Color? boxShadow;
//
//   const CustomContainer({
//     Key? key,
//     required this.size,
//     required this.rad,
//     required this.child,
//     this.margin,
//     this.vertPad,
//     this.horPad,
//     this.boxShadow,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: margin ?? 15),
//       padding: EdgeInsets.symmetric(horizontal: horPad ?? size.width * 0.05, vertical: vertPad ?? 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(rad),
//         boxShadow: [
//           BoxShadow(color: boxShadow ?? Colors.black12, blurRadius: 5, spreadRadius: 1),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
