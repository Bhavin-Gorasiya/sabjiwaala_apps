import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../helper/app_colors.dart';

class OtpTextField extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  const OtpTextField({Key? key, required this.size, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 4,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        inactiveFillColor: Colors.white,
        inactiveColor: Colors.black.withOpacity(0.5),
        activeColor: Colors.transparent,
        selectedFillColor: AppColors.primary.withOpacity(0.1),
        selectedColor: AppColors.primary,
        shape: PinCodeFieldShape.box,
        fieldHeight: size.width * 0.13,
        fieldWidth: size.width * 0.11,
        activeFillColor: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      cursorColor: Colors.black,
      enableActiveFill: true,
      animationDuration: const Duration(milliseconds: 300),
      keyboardType: TextInputType.number,
      onChanged: (String value) {},
    );
  }
}
