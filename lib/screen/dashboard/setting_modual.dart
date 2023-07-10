import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/helper/app_image.dart';
import 'package:sub_franchisee/screen/dashboard/edit_profile.dart';
import 'package:sub_franchisee/screen/dashboard/home_screen.dart';
import 'package:sub_franchisee/screen/dashboard/orders_screen.dart';
import 'package:sub_franchisee/screen/dashboard/send_enquiry.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/service/background_service.dart';

import '../../../helper/app_colors.dart';
import '../../api/app_preferences.dart';
import '../../helper/app_config.dart';
import '../../helper/navigations.dart';
import '../../models/profile_model.dart';
import '../../view model/CustomViewModel.dart';
import '../sign_up_modual/signup_screen.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/loading.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isShop = false;
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Settings"),
          Expanded(
            child: Consumer<CustomViewModel>(builder: (context, state, child) {
              ProfileModel profile = state.profileDetails ?? ProfileModel();
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 15),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          width: size.width * 0.22,
                          height: size.width * 0.22,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            border: Border.all(color: Colors.white, width: 1.5),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 6,
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage("assets/bg.png"),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: profile.userPicture == null
                                ? const SizedBox()
                                : CachedNetworkImage(
                                    imageUrl: "${AppConfig.apiUrl}${profile.userPicture ?? ""}",
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Image(image: AssetImage("assets/user_avatar.png")),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "${profile.userFname ?? "Hello"} ${profile.userLname ?? "User"}",
                          style: TextStyle(fontSize: size.width * 0.055, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          profile.userEmail ?? "",
                          style: TextStyle(
                              fontSize: size.width * 0.038, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        row(
                            color: Colors.teal,
                            icon: Icons.person,
                            text: "Edit Profile",
                            onTap: () {
                              push(context, const EditProfileScreen());
                            },
                            size: size),
                        row(
                            color: AppColors.red,
                            icon: Icons.access_time_outlined,
                            text: "My Orders",
                            onTap: () {
                              push(context, const OrderScreen());
                            },
                            size: size),
                        row(
                            color: Colors.cyan,
                            icon: Icons.question_answer,
                            text: "Send Enquiry",
                            onTap: () {
                              push(context, const SendEnquiry());
                            },
                            size: size),
                        row(
                            color: Colors.orangeAccent,
                            icon: Icons.messenger_outline,
                            text: "Support",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    actionsPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                                      child: Text(
                                        "Need Help? Contact Our Support Team",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: size.width * 0.047, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                    content: Text.rich(
                                      TextSpan(
                                        text: 'If you need assistance with your delivery or have any questions, '
                                            'please contact our support team. You can reach us by phone at ',
                                        style: TextStyle(
                                            fontSize: size.width * 0.032, color: Colors.black.withOpacity(0.8)),
                                        children: const <InlineSpan>[
                                          TextSpan(
                                            text: '+91 9875641325',
                                            style: TextStyle(color: AppColors.primary),
                                          ),
                                          TextSpan(
                                            text: ' or by email at ',
                                          ),
                                          TextSpan(
                                            text: 'a@gmail.com',
                                            style: TextStyle(color: AppColors.primary),
                                          ),
                                          TextSpan(
                                            text: '. Our team is available to help you 24/7. '
                                                'Thank you for delivering with us!',
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      const SizedBox(height: 15),
                                      Container(color: Colors.black12, height: 1),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                pop(context);
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                child: textWithIcon(
                                                  size: size,
                                                  text: "Call Us",
                                                  icon: Icons.call_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.red,
                                                    borderRadius:
                                                        const BorderRadius.only(bottomRight: Radius.circular(10))),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                child: textWithIcon(
                                                  size: size,
                                                  text: "Mail Us",
                                                  icon: Icons.mail,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            size: size),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Image.asset(
                                      isShop ? AppImages.shopOpen : AppImages.shopClose,
                                      height: size.width * 0.06,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "Shop Visibility",
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              FlutterSwitch(
                                value: state.profileDetails!.userStatus == "1",
                                onToggle: (newVal) {
                                  popup(
                                      size: size,
                                      context: context,
                                      isBack: isShop,
                                      title: isShop
                                          ? "Are you sure want to Closed your shop?"
                                          : "Are you sure want to Re-Open your shop?",
                                      onYesTap: () async {
                                        setState(() {
                                          isShop = newVal;
                                        });
                                        log("===>> $isShop");
                                        await state.shopOnOff(isShop ? "1" : "0").then((value) async {
                                          if (!isShop) {
                                            await AppPreferences.setShop(false);
                                            exit(1);
                                          } else {
                                            await AppPreferences.setShop(true);
                                            await BackgroundService.initializeService();
                                          }
                                        });
                                      });
                                },
                                height: size.width * 0.065,
                                width: size.width * 0.15,
                                padding: 5,
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.red,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "Notification",
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              FlutterSwitch(
                                value: notification,
                                onToggle: (newVal) {
                                  setState(() {
                                    notification = newVal;
                                  });
                                },
                                height: size.width * 0.065,
                                width: size.width * 0.15,
                                padding: 5,
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.red,
                              )
                            ],
                          ),
                        ),
                        row(
                            color: Colors.blueGrey,
                            icon: Icons.login,
                            text: "Logout",
                            onTap: () {
                              popup(
                                size: size,
                                context: context,
                                title: "Are you sure want to logout?",
                                onYesTap: () async {
                                  await AppPreferences.clearAll().then((value) =>
                                      // Provider.of<CustomViewModel>(context, listen: false).changeBottomNavIndex(index: 0);
                                      pushReplacement(context, const SignUpScreen()));
                                },
                              );
                            },
                            size: size),
                        row(
                            color: Colors.red,
                            icon: Icons.delete,
                            text: "Delete Account",
                            onTap: () async {
                              popup(
                                  size: size,
                                  context: context,
                                  isBack: true,
                                  title: "This operation is permanent. Are you sure you want to delete your account?",
                                  onYesTap: () async {
                                    final provider = context.read<CustomViewModel>();
                                    await provider.deleteAccount().then((value) async {
                                      if (value == "success") {
                                        snackBar(context, "Account has been deleted");
                                        AppPreferences.clearAll();
                                        pop(context);
                                        pushReplacement(context, const SignUpScreen());
                                      } else {
                                        snackBar(context, "Unable to delete your account");
                                      }
                                    });
                                  });
                            },
                            size: size),
                      ],
                    ),
                  ),
                  if (state.isLoading) const Loading()
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget row(
      {required Color color,
      required IconData icon,
      required String text,
      required Function onTap,
      required Size size}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_outlined)
            ],
          ),
        ),
      ),
    );
  }
}
