import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/screens/auth/signup_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/home_screen.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/CustomBtn.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';
import '../dash_board/dashboard.dart';

class OTPScreen extends StatefulWidget {
  final String mobile;

  const OTPScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpTimerButtonController controller = OtpTimerButtonController();
  TextEditingController otp = TextEditingController();

  requestOtp() {
    controller.loading();
    Future.delayed(const Duration(seconds: 1), () {
      controller.startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (size.width < 500)
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Image.asset(
                "assets/background.png",
                width: size.width,
              ),
            ),
          InkWell(
            onTap: () {
              pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 15),
              child: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                // padding: size.width * 0.06,
                children: [
                  Text(
                    "OTP Verification",
                    style: TextStyle(
                        fontSize: sizes(size.width * 0.05, 24, size),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Enter the OTP received to +91 ${widget.mobile}',
                    style: TextStyle(
                      fontSize: sizes(size.width * 0.035, 18, size),
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: sizes(size.width, 500, size),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: PinCodeTextField(
                        controller: otp,
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
                          fieldHeight: sizes(size.width * 0.13, 65, size),
                          fieldWidth: sizes(size.width * 0.11, 50, size),
                          activeFillColor: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        cursorColor: Colors.black,
                        enableActiveFill: true,
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {},
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizes(size.width, 500, size),
                    child: Row(
                      children: [
                        const Spacer(),
                        OtpTimerButton(
                          loadingIndicatorColor: AppColors.primary,
                          backgroundColor: AppColors.primary,
                          buttonType: ButtonType.text_button,
                          controller: controller,
                          onPressed: () async {
                            requestOtp();
                            await Provider.of<CustomViewModel>(context, listen: false)
                                .sendOtp(widget.mobile, true)
                                .then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Otp sent successfully"),
                                      backgroundColor: AppColors.primary,
                                    )));
                          },
                          text: Text(
                            "Resend Otp",
                            style: TextStyle(
                              fontSize: sizes(size.width * 0.037, 22, size),
                            ),
                          ),
                          duration: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Consumer<CustomViewModel>(builder: (context, state, child) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 15,
                  right: 15,
                  left: 15,
                ),
                height: 50,
                child: CustomBtn(
                  btnColor: state.isLoading ? Colors.grey.withOpacity(0.5) : AppColors.primary,
                  size: size,
                  radius: 12,
                  title: state.isLoading ? 'Verifying...' : "Submit",
                  onTap: () async {
                    log(" ==== ${otp.text}");

                    if (!state.isLoading) {
                      if (otp.text.isNotEmpty && otp.text.length == 4) {
                        await Provider.of<CustomViewModel>(context, listen: false)
                            .verifyOtp(widget.mobile, otp.text)
                            .then(
                          (value) {
                            if (value == 'not register') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Not register",
                                    style: TextStyle(
                                      fontSize: sizes(size.width * 0.045, 18, size),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                              /* push(
                                  context,
                                  RegisterScreen(
                                    mobile: widget.mobile,
                                  ));*/
                            } else if (value == 'register') {
                              pushReplacement(context, HomeScreen());
                            } else if (value == 'otp error') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Please enter valid OTP",
                                    style: TextStyle(
                                      fontSize: sizes(size.width * 0.045, 18, size),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                        // pushPage(context, const DetailsAddingScreen());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Please enter valid OTP"),
                          backgroundColor: AppColors.red,
                        ));
                        // popup(context, size, AppText.otpValidation, AppColors.primaryColor.withOpacity(0.8));
                      }
                    }
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
