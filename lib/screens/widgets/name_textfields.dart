import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helper/app_colors.dart';

class NameTextField extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final String? hintText;
  final String name;
  final TextInputType? keyBoardType;
  final int? maxNum;
  final bool readOnly;
  final bool isEmail;

  const NameTextField(
      {Key? key,
      required this.size,
      required this.controller,
      this.hintText,
      required this.name,
      this.keyBoardType,
      this.maxNum,
      this.readOnly = false,
      this.isEmail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(color: AppColors.primary.withOpacity(0.5))),
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            keyboardType: keyBoardType ?? TextInputType.text,
            textCapitalization: isEmail ? TextCapitalization.none : TextCapitalization.words,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxNum ?? 100),
            ],
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
              hintStyle: TextStyle(fontSize: size.width * 0.038, color: Colors.black.withOpacity(0.4)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
