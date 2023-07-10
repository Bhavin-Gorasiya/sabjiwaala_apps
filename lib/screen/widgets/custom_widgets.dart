import 'package:flutter/material.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import 'confirmation_popup_btn.dart';
import 'custom_textfields.dart';

List fruits = [
  "Mango",
  "Watermelon",
  "Cherry",
  "Pineapple",
  "Chikoo",
  "Apple",
  "Dragon Fruit",
  "Banana",
  "RaspBerry",
  "BlackBerry",
  "StoBerry"
];

dualText({required String title, required String desc, required Size size, double? textsize}) {
  return Row(
    children: [
      Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: textsize ?? size.width * 0.034,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
      Text(
        desc,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: textsize ?? size.width * 0.034,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
      ),
    ],
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
  String? desc,
  required Function onYesTap,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: size.width * 0.05),
            ),
            if (desc != null) const SizedBox(height: 10),
            if (desc != null)
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.04),
              ),
          ],
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

divideLine({required Size size}) {
  return Container(
    width: size.width,
    height: 1,
    color: Colors.black12,
    margin: const EdgeInsets.only(top: 2, bottom: 10),
  );
}

text(
    {required Size size,
    required String text,
    Color? color,
    FontWeight? fontWeight,
    double? textSize,
    double? width,
    double? vertPad,
      TextDecoration? decoration,
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
          decoration: decoration,
          fontSize: isTotal ? size.width * 0.038 : textSize ?? size.width * 0.035,
          color: color,
          fontWeight: isTotal ? FontWeight.w600 : fontWeight,
        ),
      ),
    ),
  );
}

tabContainer(
    {required String name,
    required Size size,
    required Function onTap,
    required bool isSelect,
    Color? textColor,
    double? width,
    required Color btnColor}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8),
            width: width ?? size.width / 3,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: textColor ?? AppColors.primary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 2.5,
            width: width ?? size.width / 3,
            color: isSelect ? btnColor : Colors.transparent,
          )
        ],
      ),
    ),
  );
}

// textFieldsWithText({required String title,
//   String? validation,
//   required String hint,
//   required Size size,
//   int? maxLines,
//   bool isEmail = false,
//   int? lendth,
//   TextInputType? keyboardType,
//   required TextEditingController controller}) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 5),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//               fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.7), fontSize: size.width * 0.038),
//         ),
//         CustomTextFields(
//           hintText: hint,
//           controller: controller,
//           validation: validation,
//           maxLines: maxLines,
//           keyboardType: keyboardType,
//           lendth: lendth,
//           isEmail: isEmail,
//         ),
//       ],
//     ),
//   );
// }

headingText({required Size size, required String texts}) {
  return text(size: size, text: texts, textSize: size.width * 0.048, fontWeight: FontWeight.w600);
}
