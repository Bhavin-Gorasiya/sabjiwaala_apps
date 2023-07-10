import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/CustomBtn.dart';
import '../../Widgets/app_dialogs.dart';
import '../../Widgets/firebase_setup.dart';
import '../../api/app_preferences.dart';
import '../../theme/colors.dart';
import '../../utils/app_image.dart';
import '../../utils/helper.dart';
import '../dash_board/home_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoaded = false;
  TextEditingController mobile = TextEditingController();
  bool isMobileValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var isLoggedIn = await AppPreferences.getLoggedin();
      log("$isLoggedIn");
      if (isLoggedIn == null) {
        setState(() {
          isLoaded = true;
        });
      } else {
        await initFirebase().then((value) => pushReplacement(context, const HomeScreen()));
      }
    });
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    debugPrint("===>> width ${size.width}");
    debugPrint("===>> height ${size.height}");
    return WillPopScope(
      onWillPop: () {
        popup(
            title: "Are you sure want to exit app?",
            size: size,
            isBack: true,
            context: context,
            onYesTap: () {
              SystemNavigator.pop();
            });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              right: sizes(-10, -50, size),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Image(
                  width: sizes(size.width, 500, size),
                  image: const AssetImage(
                    AppImages.backImg,
                  ),
                ),
              ),
            ),
            isLoaded == false
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: CircularProgressIndicator(),
                  ))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: sizes(size.width * 0.6, size.height * 0.3, size),
                        width: sizes(size.width, size.width, size),
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
                            image: AssetImage(AppImages.loginImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: sizes(15, size.height * 0.1, size)),
                              Container(
                                width: sizes(size.width, 500, size),
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Welcome to Sabjiwaala",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: sizes(size.width * 0.058, 24, size),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "Enter your mobile number to receive verification code",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: sizes(size.width * 0.04, 20, size),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    Row(
                                      children: [
                                        Text(
                                          "Mobile number",
                                          style: TextStyle(
                                            fontSize: sizes(size.width * 0.042, 20, size),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: sizes(size.width * 0.045, 25, size),
                                        vertical: sizes(size.width * 0.02, 10, size),
                                      ),
                                      width: sizes(size.width, 500, size),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: sizes(size.width * 0.042, 20, size)),
                                        controller: mobile,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        focusNode: focusNode,
                                        onChanged: (String value) {
                                          if (value.length == 10) {
                                            focusNode.unfocus();
                                          }
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "9898123123",
                                          isDense: true,
                                          hintStyle: TextStyle(fontSize: sizes(size.width * 0.042, 20, size), color: Colors.black.withOpacity(0.3)),
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
                                                  style: TextStyle(fontSize: sizes(size.width * 0.03, 15, size), color: Colors.red),
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
                                        title: state.isLoading ? 'Sending OTP...' : 'Get OTP',
                                        btnColor: AppColors.primary,
                                        onTap: () async {
                                          log("done");
                                          if (mobile.text.length < 10) {
                                            setState(() {
                                              isMobileValid = true;
                                            });
                                          } else {
                                            setState(() {
                                              isMobileValid = false;
                                            });
                                            await state.sendOtp(mobile.text, false).then((value) {
                                              if (value == 'success') {
                                                push(
                                                  context,
                                                  OTPScreen(
                                                    mobile: mobile.text,
                                                  ),
                                                );
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
                            ],
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

double sizes(double width, double newWidth, Size size) {
  if (size.width > 500) {
    return newWidth;
  } else {
    return width;
  }
}

double pad(double pad, double newPad, Size size) {
  if (size.width > 500) {
    return newPad;
  } else {
    return pad;
  }
}
