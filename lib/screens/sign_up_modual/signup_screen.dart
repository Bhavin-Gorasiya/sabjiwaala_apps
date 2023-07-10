import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/screens/sign_up_modual/otp_screen.dart';
import 'package:subjiwala/theme/colors.dart';
import 'package:subjiwala/utils/helper.dart';

import '../../Widgets/cloase_app_popup.dart';

class SignUpScreen extends StatefulWidget {
  final bool isLogout;

  const SignUpScreen({Key? key, this.isLogout = false}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController mobile = TextEditingController();
  bool isMobileValid = false;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (widget.isLogout) {
          showDialog(
            context: context,
            builder: (context) => CloseAppPopup(onTapYes: () {
              SystemNavigator.pop();
            }),
          );
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              right: -10,
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Image(
                  width: size.width,
                  image: const AssetImage(
                    "assets/background.png",
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      image: AssetImage("assets/loginImg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome to Sabjiwaala",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Enter your mobile number to receive verification code",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                Text(
                                  "Mobile number",
                                  style: TextStyle(
                                    fontSize: size.width * 0.042,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.045,
                                vertical: size.width * 0.02,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(size.width * 0.03),
                              ),
                              child: TextFormField(
                                controller: mobile,
                                focusNode: focusNode,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                keyboardType: TextInputType.phone,
                                onChanged: (String value){
                                  if(value.length == 10){
                                    focusNode.unfocus();
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "9898123123",
                                  isDense: true,
                                  hintStyle:
                                      TextStyle(fontSize: size.width * 0.042, color: Colors.black.withOpacity(0.3)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            isMobileValid
                                ? Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          "Mobile Number must be of 10 digit",
                                          style: TextStyle(fontSize: size.width * 0.03, color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 55),
                            Consumer<CustomViewModel>(builder: (context, state, child) {
                              return CustomBtn(
                                radius: 10,
                                size: size,
                                title: state.isLoading ? 'Loading...' : 'Generate Otp',
                                btnColor: AppColors.primary,
                                onTap: () async {
                                  if (mobile.text.length < 10) {
                                    setState(() {
                                      isMobileValid = true;
                                    });
                                  } else {
                                    setState(() {
                                      isMobileValid = false;
                                    });
                                    // push(context, OTPScreen(mobile: mobile.text));
                                    Provider.of<CustomViewModel>(context, listen: false).isLoading = true;
                                    await Provider.of<CustomViewModel>(context, listen: false)
                                        .sendOtp(mobile.text)
                                        .then((value) {
                                      if (value == 'success') {
                                        log(" === $value");
                                        push(
                                            context,
                                            OTPScreen(
                                              mobile: mobile.text,
                                            ));
                                        Provider.of<CustomViewModel>(context, listen: false).isLoading = false;
                                        mobile.clear();
                                      }
                                    });
                                  }
                                },
                              );
                            }),
                            SizedBox(height: MediaQuery.of(context).viewInsets.top + 15)
                          ],
                        ),
                      ),
                    ]),
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
