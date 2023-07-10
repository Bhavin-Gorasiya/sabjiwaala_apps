import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helper/app_colors.dart';

class CustomTextFields extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final String? validation;
  final TextEditingController controller;
  final bool isEmail;
  final bool readOnly;
  final int? lendth;
  final int? maxLines;

  const CustomTextFields(
      {Key? key,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      this.validation,
      this.isEmail = false,
      this.readOnly = false,
      this.lendth,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: maxLines == null ? size.width * 0.15 : null,
        child: TextFormField(
          readOnly: readOnly,
          controller: controller,
          textCapitalization: isEmail ? TextCapitalization.none : TextCapitalization.words,
          inputFormatters: maxLines == null
              ? [LengthLimitingTextInputFormatter(lendth ?? 100), if (!isEmail) UpperCaseTextFormatter()]
              : [if (!isEmail) UpperCaseTextFormatter()],
          validator: (String? arg) {
            if (validation != null) {
              if (arg != null && arg.isEmpty) {
                return validation;
              } else {
                return null;
              }
            } else {
              return null;
            }
          },
          keyboardType: keyboardType ?? TextInputType.text,
          maxLines: maxLines ?? 1,
          minLines: 1,
          style: TextStyle(fontSize: size.width * 0.04),
          decoration: InputDecoration(
            hintText: hintText,
            focusColor: AppColors.primary,
            hintStyle: TextStyle(fontSize: size.width * 0.04),
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

Widget textFiled({
  required String name,
  required TextEditingController controller,
  required Size size,
  int? maxLines,
  TextInputType? keyboardType,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5,top: 15),
    // width: size.width - size.width * 0.11,
    // height: 50,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        labelText: name,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
      ),
      maxLines: maxLines ?? 1,
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
  );
}