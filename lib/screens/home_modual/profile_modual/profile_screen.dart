import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_app/helper/navigations.dart';
import 'package:delivery_app/provider/custom_view_model.dart';
import 'package:delivery_app/screens/home_modual/attendance_modual/attendance_module.dart';
import 'package:delivery_app/screens/home_modual/profile_modual/edit_profile.dart';
import 'package:delivery_app/screens/home_modual/profile_modual/send_enquiry.dart';
import 'package:delivery_app/screens/sign_up_modual/signup_screen.dart';
import 'package:delivery_app/screens/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/app_preferences.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/app_config.dart';
import '../../../models/profile_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Consumer<CustomViewModel>(builder: (context, state, child) {
        ProfileModel profile = state.profileDetails ?? ProfileModel();
        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: size.width * 0.61,
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.width * 0.5,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20,
                          right: size.width * 0.05,
                          left: size.width * 0.05,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.primary.withOpacity(0.6),
                            AppColors.primary,
                          ]),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.22,
                  height: size.width * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.green,
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
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "${profile.userFname ?? "Hello"} ${profile.userLname ?? "User"}",
              style: TextStyle(fontSize: size.width * 0.055, fontWeight: FontWeight.w700),
            ),
            Text(
              profile.userEmail ?? "",
              style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            row(
                color: Colors.teal,
                icon: Icons.person,
                text: "Profile",
                onTap: () {
                  push(context, const EditProfileScreen());
                },
                size: size),
            row(
                color: AppColors.red,
                icon: Icons.access_time_outlined,
                text: "Order History",
                onTap: () {
                  Provider.of<CustomViewModel>(context, listen: false).changeBottomNavIndex(index: 1);
                },
                size: size),
            row(
                color: Colors.green,
                icon: Icons.calendar_month,
                text: "Leave Module",
                onTap: () {
                  push(context, const AttendanceModule());
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
                            style: TextStyle(fontSize: size.width * 0.032, color: Colors.black.withOpacity(0.8)),
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
                                    launch("tel:+91 5642318975");
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
                                    launch("mailto:a@gmail.com");
                                    pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.red,
                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))),
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
            row(
                color: Colors.deepPurple,
                icon: Icons.login,
                text: "Logout",
                onTap: () async {
                  await AppPreferences.clearAll().then((value) {
                    Provider.of<CustomViewModel>(context, listen: false).changeBottomNavIndex(index: 0);
                    pushReplacement(context, const SignUpScreen());
                  });
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
        );
      }),
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
