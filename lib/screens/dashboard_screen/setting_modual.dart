import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_app/api/app_preferences.dart';
import 'package:employee_app/helper/app_config.dart';
import 'package:employee_app/models/attendance_model.dart';
import 'package:employee_app/models/profile_model.dart';
import 'package:employee_app/screens/dashboard_screen/edit_profile.dart';
import 'package:employee_app/screens/dashboard_screen/send_enquiry.dart';
import 'package:employee_app/screens/sign_up_modual/signup_screen.dart';
import 'package:employee_app/screens/widgets/custom_widgets.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/loading.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notification = true;
  bool isShop = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Settings"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            ProfileModel profile = state.profileDetails ?? ProfileModel();
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.0, vertical: 15),
                      child: Column(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(50), // Image radius
                              child: profile.userPicture == null || profile.userPicture == ""
                                  ? Image.asset("assets/user_avatar.png", fit: BoxFit.cover)
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: AppConfig.apiUrl + profile.userPicture!,
                                      errorWidget: (context, url, error) => Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                                      placeholder: (context, url) => Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                                    ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  "${profile.userFname ?? "Hello"} ${profile.userLname ?? "User"}",
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  profile.userEmail ?? "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          common(
                              icon: Icons.person,
                              context: context,
                              title: "Edit profile",
                              onTap: () {
                                push(context, const EditProfileScreen());
                              }),
                          divider(size: size),
                          common(
                              icon: Icons.question_answer,
                              context: context,
                              title: "Send Enquiry",
                              onTap: () {
                                push(context, const SendEnquiry());
                              }),
                          divider(size: size),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            child: Consumer<CustomViewModel>(builder: (context, state, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    state.attendance ? "assets/icons/check-out.png" : "assets/icons/check-in.png",
                                    height: size.width * 0.058,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    state.attendance ? "Check Out" : "Check In",
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                    ),
                                  ),
                                  const Spacer(),
                                  FlutterSwitch(
                                    value: state.attendance,
                                    onToggle: (newVal) async {
                                      DateTime date = DateTime.now();
                                      if (state.attendance) {
                                        await state.setAttendance(
                                          model: Attendance(
                                              attendanceDates: "${date.year}-${date.month}-${date.day}",
                                              attendanceEtime: "${date.hour}:${date.minute}",
                                              attendanceUid: profile.userID,
                                              type: "checkout"),
                                        );
                                      } else {
                                        await state.setAttendance(
                                          model: Attendance(
                                              attendanceDates: "${date.year}-${date.month}-${date.day}",
                                              attendanceStime: "${date.hour}:${date.minute}",
                                              attendanceIp: "123",
                                              attendanceUid: profile.userID,
                                              type: "checkin"),
                                        );
                                      }
                                    },
                                    height: size.width * 0.065,
                                    width: size.width * 0.15,
                                    padding: 5,
                                    activeColor: AppColors.primary,
                                    inactiveColor: AppColors.red,
                                  )
                                ],
                              );
                            }),
                          ),
                          divider(size: size),
                          common(
                            icon: Icons.star_border,
                            context: context,
                            title: "Rate us",
                            onTap: () async {
                              // launch(Platform.isIOS
                              //     ? (providerListener.appVersionParser!.appstore ?? "").toString()
                              //     : (providerListener.appVersionParser!.playstore ?? "").toString());
                            },
                          ),
                          divider(size: size),
                          common(
                            icon: Icons.messenger_outline,
                            context: context,
                            title: "Contact us",
                            onTap: () async {
                              await AppDialog.contactUs(context, size);
                            },
                          ),
                          divider(size: size),
                          common(
                            icon: Icons.info_outline,
                            context: context,
                            title: "About us",
                            onTap: () async {
                              await AppDialog.aboutUs(context);
                            },
                          ),
                          /*divider(size: size),
                            common(
                              icon: Icons.shopping_bag_outlined,
                              context: context,
                              title: "Buy seeds",
                              onTap: () async {
                                push(context, SDashBoard());
                              },
                            ),*/
                          divider(size: size),
                          common(
                            isDelete: true,
                            icon: Icons.logout,
                            context: context,
                            title: "Log Out",
                            onTap: () async {
                              popup(
                                  size: size,
                                  context: context,
                                  title: "Are you sure want to Log Out?",
                                  isBack: true,
                                  onYesTap: () async {
                                    final pref = await SharedPreferences.getInstance();
                                    pref.remove("userID").then((value) {
                                      pop(context);
                                      pushReplacement(context, const SignUpScreen());
                                    });
                                  });
                            },
                          ),
                          divider(size: size),
                          common(
                              isDelete: true,
                              icon: Icons.delete,
                              context: context,
                              title: "Delete account",
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
                                          pop(context);
                                          pushReplacement(context, const SignUpScreen());
                                        } else {
                                          snackBar(context, "Unable to delete your account");
                                        }
                                      });
                                    });
                              }),
                          const SizedBox(height: 35),
                          Text(
                            "Version: 1.0.0",
                            style: TextStyle(fontSize: size.width * 0.045),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading) Loading()
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  Widget common({
    required IconData icon,
    required BuildContext context,
    required String title,
    Function()? onTap,
    Color? color,
    bool isDelete = false,
  }) {
    return ListTile(
      minLeadingWidth: 25,
      onTap: onTap,
      leading: Icon(icon, color: isDelete ? AppColors.red : color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045),
      ),
      trailing: Icon(
        isDelete ? null : Icons.arrow_forward_ios_rounded,
        color: isDelete ? AppColors.red : AppColors.primary,
        size: 18,
      ),
    );
  }

  Widget divider({required Size size}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      height: 1.6,
      width: size.width,
      color: Colors.grey.shade200,
    );
  }
}
