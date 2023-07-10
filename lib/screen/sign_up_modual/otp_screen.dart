import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/screen/sign_up_modual/register_screen.dart';
import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../../view model/CustomViewModel.dart';
import '../dashboard/home_screen.dart';
import '../widgets/custom_btn.dart';

class OTPScreen extends StatefulWidget {
  final String mobile;

  const OTPScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpTimerButtonController controller = OtpTimerButtonController();
  TextEditingController otp = TextEditingController();

  bool iosOtpSend = false;

  requestOtp() {
    controller.loading();
    Future.delayed(const Duration(seconds: 1), () {
      controller.startTimer();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        pop(context);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: const Image(
                image: AssetImage("assets/background.png"),
              ),
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: size.width * 0.6,
                      width: size.width,
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image(
                          image: AssetImage("assets/bg.png"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 15),
                      child: InkWell(
                        onTap: () {
                          pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary)),
                          child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // padding: size.width * 0.06,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "OTP Verification",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Please enter the OTP received to your mobile number +91 ${widget.mobile}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
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
                                fieldHeight: size.width * 0.13,
                                fieldWidth: size.width * 0.11,
                                activeFillColor: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              cursorColor: Colors.black,
                              enableActiveFill: true,
                              animationDuration: const Duration(milliseconds: 300),
                              keyboardType: TextInputType.phone,
                              onChanged: (String value) {},
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Haven't received the verification code?",
                            style: TextStyle(fontSize: size.width * 0.04, color: Colors.black.withOpacity(0.6)),
                          ),
                          // const Spacer(),
                          OtpTimerButton(
                            loadingIndicatorColor: AppColors.primary,
                            backgroundColor: AppColors.primary,
                            buttonType: ButtonType.text_button,
                            controller: controller,
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Otp sent successfully"),
                                backgroundColor: AppColors.primary,
                              ));
                              requestOtp();
                              await Provider.of<CustomViewModel>(context, listen: false).sendOtp(widget.mobile, true,context);
                            },
                            text: Text(
                              "Resend Otp",
                              style: TextStyle(
                                fontSize: size.width * 0.037,
                              ),
                            ),
                            duration: 30,
                          ),
                          const SizedBox(height: 25),
                          Consumer<CustomViewModel>(builder: (context, state, child) {
                            return CustomBtn(
                              btnColor: state.isLoading ? Colors.grey.withOpacity(0.5) : AppColors.primary,
                              size: size,
                              radius: 12,
                              title: state.isLoading ? 'Verifying...' : "Submit",
                              onTap: () async {
                                log(" ==== ${otp.text}");
                                if (!state.isLoading) {
                                  if (otp.text.isNotEmpty && otp.text.length == 4) {
                                    await state.verifyOtp(widget.mobile, otp.text).then(
                                          (value) {
                                        if (value == 'not register') {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                "Not register",
                                                style: TextStyle(
                                                  fontSize: size.width * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (value == 'register') {
                                          pushReplacement(context, HomeScreen());
                                        } else if (value == 'otp error') {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                "Please enter valid OTP",
                                                style: TextStyle(
                                                  fontSize: size.width * 0.045,
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
                                  }
                                }
                              },
                            );
                          }),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
