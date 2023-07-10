import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/colors.dart';

class CustomTextFields extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final String? validation;
  final TextEditingController controller;
  final bool isEmail;
  final int? length;
  final int? maxLine;

  const CustomTextFields(
      {Key? key,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      this.validation,
      this.isEmail = false,
      this.length, this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: size.width * 0.15,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(length ?? 100),
          ],
          validator: (String? arg) {
            log('====$arg');
            if (validation != null) {
              return validation;
            } else {
              return null;
            }
          },
          keyboardType: keyboardType ?? TextInputType.text,
          style: TextStyle(fontSize: size.width * 0.045),
          maxLines: maxLine ?? 1,
          minLines: maxLine,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: size.width * 0.045),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
