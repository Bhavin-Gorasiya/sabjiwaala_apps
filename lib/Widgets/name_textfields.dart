import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameTextField extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final String hintText;
  final String name;
  final TextInputType? keyBoardType;
  final int? maxNum;

  const NameTextField(
      {Key? key,
      required this.size,
      required this.controller,
      required this.hintText,
      required this.name,
      this.keyBoardType,
      this.maxNum})
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
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(color: Colors.black.withOpacity(0.3))),
          child: TextFormField(
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxNum ?? 100),
              if (name != "Email") UpperCaseTextFormatter()
            ],
            keyboardType: keyBoardType ?? TextInputType.name,
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
              hintStyle: TextStyle(fontSize: size.width * 0.038, color: Colors.black.withOpacity(0.3)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
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
