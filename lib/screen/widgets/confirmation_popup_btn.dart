import 'package:flutter/material.dart';

class ConfirmationPopupBtn extends StatelessWidget {
  final Size size;
  final String title;
  final Function onTap;
  final Color textColor;
  final Color btnColor;

  const ConfirmationPopupBtn({
    Key? key,
    required this.size,
    required this.title,
    required this.onTap,
    required this.textColor,
    required this.btnColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              color: btnColor,
              borderRadius: title == "No"
                  ? const BorderRadius.only(bottomLeft: Radius.circular(10))
                  : const BorderRadius.only(bottomRight: Radius.circular(10))),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
