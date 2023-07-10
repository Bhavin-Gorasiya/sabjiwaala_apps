import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helper/app_colors.dart';

class CustomTextFields extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final String? validation;
  final TextEditingController controller;
  final bool isEmail;
  final int? lendth;
  final int? maxLines;
  final bool readOnly;

  const CustomTextFields(
      {Key? key,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      this.validation,
      this.isEmail = false,
      this.lendth,
      this.readOnly = false,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: size.width * 0.15,
        child: TextFormField(
          readOnly: readOnly,
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(lendth ?? 100),
            if(!isEmail)UpperCaseTextFormatter()
          ],
          validator: (String? arg) {
            debugPrint('====$arg');
            if (validation != null) {
              return validation;
            } else {
              return null;
            }
          },
          keyboardType: keyboardType ?? TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontSize: size.width * 0.045),
          maxLines: maxLines ?? 1,
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
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}