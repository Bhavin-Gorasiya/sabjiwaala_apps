import 'package:flutter/material.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import 'confirmation_popup_btn.dart';

dualText(
    {required String title,
    required String desc,
    required Size size,
    Color? color,
    double? titleSize,
    double? descSize}) {
  return SizedBox(
    child: Row(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: titleSize ?? size.width * 0.035, fontWeight: FontWeight.w700, color: color),
        ),
        SizedBox(
          width: size.width * 0.35,
          child: Text(
            desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: descSize ?? size.width * 0.035, color: color ?? Colors.black.withOpacity(0.7)),
          ),
        ),
      ],
    ),
  );
}

headingText({required Size size, required String texts}) {
  return text(size: size, text: texts, textSize: size.width * 0.048, fontWeight: FontWeight.w600);
}

text(
    {required Size size,
    required String text,
    Color? color,
    FontWeight? fontWeight,
    double? textSize,
    double? width,
    double? vertPad,
    int? maxLines,
    bool isTotal = false,
    AlignmentGeometry? alignmentGeometry}) {
  return Container(
    alignment: alignmentGeometry,
    width: width,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: vertPad ?? 1),
      child: Text(
        text,
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isTotal ? size.width * 0.038 : textSize ?? size.width * 0.035,
          color: color,
          fontWeight: isTotal ? FontWeight.w600 : fontWeight,
        ),
      ),
    ),
  );
}

textWithIcon({required Size size, required String text, required IconData icon, required Color color}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: color,
        size: size.width * 0.045,
      ),
      SizedBox(width: size.width * 0.01),
      Text(
        text,
        style: TextStyle(fontSize: size.width * 0.038, color: color),
      ),
    ],
  );
}

popup({
  required Size size,
  required BuildContext context,
  bool isBack = false,
  required String title,
  required Function onYesTap,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsPadding: EdgeInsets.zero,
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size.width * 0.05),
        ),
        actions: [
          Container(color: Colors.black12, height: 1),
          Row(
            children: [
              ConfirmationPopupBtn(
                  size: size,
                  title: "No",
                  onTap: () {
                    pop(context);
                  },
                  textColor: isBack ? Colors.black : Colors.white,
                  btnColor: isBack ? Colors.white : AppColors.red),
              ConfirmationPopupBtn(
                  size: size,
                  title: "Yes",
                  onTap: () {
                    onYesTap();
                    pop(context);
                  },
                  textColor: isBack ? Colors.white : Colors.black,
                  btnColor: isBack ? AppColors.red : Colors.white),
            ],
          ),
        ],
      );
    },
  );
}
