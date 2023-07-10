import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../api/app_preferences.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_image.dart';
import '../../helper/navigations.dart';
import '../../view model/CustomViewModel.dart';
import '../dashboard_screen/home_screen.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/customBtn.dart';
import '../widgets/firebase_setup.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController mobile = TextEditingController();
  bool isLoaded = false;
  bool isMobileValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await determinePosition(context).then((value) async {
      //   if (value) {
      String? time = await AppPreferences.getTime();
      var isLoggedIn = await AppPreferences.getLoggedin();
      log("$isLoggedIn");
      if (isLoggedIn == null) {
        await AppPreferences.setTime(DateTime.now().toString());
        setState(() {
          isLoaded = true;
        });
      } else {
        // log("==>> ${DateTime.now().difference(DateTime.parse(time!)).toString()}");
        if (DateTime.now().difference(DateTime.parse(time!)).inHours > 1) {
          setState(() {
            isLoaded = true;
          });
          await AppPreferences.setTime(DateTime.now().toString());
        } else {
          await initFirebase();
          pushReplacement(context, const HomeScreen());
        }
      }
      // }
      // });
    });
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        body: isLoaded == false
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    right: -10,
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Image(
                        width: size.width,
                        image: const AssetImage(
                          AppImages.backImg,
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
                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 5),
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
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
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
                                      focusNode: focusNode,
                                      onChanged: (String value) {
                                        if (value.length == 10) {
                                          focusNode.unfocus();
                                        }
                                      },
                                      controller: mobile,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: "9898123123",
                                        isDense: true,
                                        hintStyle: TextStyle(fontSize: size.width * 0.042, color: Colors.black.withOpacity(0.3)),
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
                                      title: state.isLoading ? 'Sending OTP...' : 'Generate Otp',
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
                                          await state.sendOtp(mobile.text, false, context).then((value) {
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

Future<bool> determinePosition(BuildContext context) async {
  // CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
  bool serviceEnabled;
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      log('Location permissions are denied');
      return false /*Future.error('Location permissions are denied')*/;
    }
  }

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // openAppSettings();
    log('Location services are disabled.');
    return false /*Future.error('Location services are disabled.')*/;
  }

  if (permission == LocationPermission.deniedForever) {
    log('Location permissions are permanently denied, we cannot request permissions.');
    return false /*Future.error('Location permissions are permanently denied, we cannot request permissions.')*/;
  }
  return true /*await Geolocator.getCurrentPosition()*/;
}
