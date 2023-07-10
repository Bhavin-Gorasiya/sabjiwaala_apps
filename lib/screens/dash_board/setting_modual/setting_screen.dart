import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/screens/dash_board/setting_modual/edit_profile.dart';
import 'package:subjiwala_farmer/screens/dash_board/setting_modual/send_enquiry.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../View Models/CustomViewModel.dart';
import '../../../Widgets/app_dialogs.dart';
import '../../../api/app_preferences.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_config.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';
import '../../suggetion_modual/s_dash_board.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.settings[state.language]),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.0, vertical: 15),
                child: Column(
                  children: [
                    if (state.profileDetails != null)
                      (state.profileDetails!.userPicture ?? "").isEmpty
                          ? ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child: Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                              ),
                            )
                          : ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child: CachedNetworkImage(
                                  imageUrl: AppConfig.apiUrl + (state.profileDetails!.userPicture ?? ""),
                                  placeholder: (context, url) =>
                                      Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                                ),
                              ),
                            ),
                    const SizedBox(height: 15),
                    common(
                        icon: Icons.person,
                        context: context,
                        title: AppText.editProfile[state.language],
                        onTap: () {
                          push(context, const EditProfileScreen());
                          // push(context, const SDashBoard());
                        }),
                    /*divider(size: size),
                    common(
                        icon: Icons.money,
                        context: context,
                        title: "Refer & Earn",
                        onTap: () {
                          push(context, const ReferEarnScreen());
                          // push(context, const SDashBoard());
                        }),*/
                    divider(size: size),
                    common(
                        icon: Icons.question_answer,
                        context: context,
                        title: AppText.sendSEnquiry[state.language],
                        onTap: () {
                          push(context, const SendEnquiry());
                          // push(context, const SDashBoard());
                        }),
                    divider(size: size),
                    common(
                      icon: Icons.star_border,
                      context: context,
                      title: AppText.rateUs[state.language],
                      onTap: () async {
                        launch(Platform.isIOS
                            ? (state.appDetailModel!.appstore ?? "").toString()
                            : (state.appDetailModel!.playstore ?? "").toString());
                      },
                    ),
                    divider(size: size),
                    common(
                      icon: Icons.messenger_outline,
                      context: context,
                      title: AppText.contactUs[state.language],
                      onTap: () async {
                        await AppDialog.contactUs(context, size,
                            email: state.appDetailModel!.email!,
                            mobile: state.appDetailModel!.phone!,
                            web: state.appDetailModel!.website!);
                      },
                    ),
                    divider(size: size),
                    common(
                      icon: Icons.info_outline,
                      context: context,
                      title: AppText.aboutUs[state.language],
                      onTap: () async {
                        await AppDialog.aboutUs(context, state.appDetailModel!);
                      },
                    ),
                     divider(size: size),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                      child: Consumer<CustomViewModel>(builder: (context, state, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/translator.png", height: size.width * 0.058),
                            const SizedBox(width: 15),
                            Text(
                              state.language == "en" ? "हिंदी" : "English",
                              style: TextStyle(
                                fontSize: size.width * 0.045,
                              ),
                            ),
                            const Spacer(),
                            FlutterSwitch(
                              value: state.language == "en",
                              onToggle: (newVal) async {
                                if (state.language == "en") {
                                  state.changeLanguage("hn");
                                } else {
                                  state.changeLanguage("en");
                                }
                              },
                              height: size.width * 0.065,
                              width: size.width * 0.15,
                              padding: 5,
                              activeColor: AppColors.primary,
                              inactiveColor: AppColors.primary,
                            )
                          ],
                        );
                      }),
                    ),
                    /*divider(size: size),
                    common(
                      icon: Icons.shopping_bag_outlined,
                      context: context,
                      title: AppText.suggestions[state.language],
                      onTap: () async {
                        push(context, SDashBoard());
                      },
                    ),*/
                    divider(size: size),
                    common(
                      icon: Icons.logout,
                      context: context,
                      title: AppText.logOut[state.language],
                      onTap: () async {
                        popup(
                            size: size,
                            context: context,
                            isBack: true,
                            title: AppText.areUSureLogOut[state.language],
                            onYesTap: () async {
                              await AppPreferences.clearAll().then((value) {
                                pop(context);
                                pushReplacement(context, LoginScreen());
                              });
                            });
                      },
                    ),
                    divider(size: size),
                    /*divider(size: size),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications, color: AppColors.primary),
                          const SizedBox(width: 15),
                          Text(
                            "Notification",
                            style: Theme.of(context).textTheme.headline3?.copyWith(),
                          ),
                          const Spacer(),
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
                          ),
                        ],
                      ),
                    ),*/
                    common(
                      isDelete: true,
                      icon: Icons.delete,
                      context: context,
                      title: AppText.deleteAcc[state.language],
                      onTap: () async {
                        String? isLoggedIn = await AppPreferences.getLoggedin();

                        if (isLoggedIn == "31") {
                          final confirm = await AppDialog.gotoLoginConfirmation(context);
                          if (confirm) {
                            AppPreferences.clearAll();

                            pop(context);
                            pushReplacement(context, const LoginScreen());
                          }
                        } else {
                          popup(
                              size: size,
                              context: context,
                              isBack: true,
                              title: AppText.thisOperation[state.language],
                              onYesTap: () async {
                                final provider = context.read<CustomViewModel>();
                                EasyLoading.show(status: 'Deleting...');
                                await provider.deleteAccount().then((value) async {
                                  EasyLoading.dismiss();
                                  if (value == "success") {
                                    commonToast(context, AppText.accHasBeen[state.language]);
                                    AppPreferences.clearAll();
                                    pop(context);
                                    pop(context);
                                    pushReplacement(context, const LoginScreen());
                                  } else {
                                    commonToast(context, value);
                                  }
                                });
                              });
                          // await showDialog(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //     contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                          //     title: Center(
                          //       child: Text(
                          //         'Delete Account?',
                          //         textScaleFactor: 1,
                          //         style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
                          //       ),
                          //     ),
                          //     content: SingleChildScrollView(
                          //       child: Column(
                          //         children: [
                          //           Text(
                          //             'This operation is permanent. Are you sure you want to delete your account?',
                          //             textScaleFactor: 1,
                          //             textAlign: TextAlign.center,
                          //             style: Theme.of(context).textTheme.headline3?.copyWith(),
                          //           ),
                          //           const SizedBox(height: 30),
                          //           SizedBox(
                          //             height: 40,
                          //             child: Row(
                          //               children: [
                          //                 Expanded(
                          //                   child: TextButton(
                          //                     onPressed: () {
                          //                       Navigator.pop(context);
                          //                     },
                          //                     child: Text(
                          //                       "No",
                          //                       textScaleFactor: 1,
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .headline3
                          //                           ?.copyWith(fontWeight: FontWeight.bold),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 const SizedBox(
                          //                   width: 5.0,
                          //                 ),
                          //                 Expanded(
                          //                   child: ElevatedButton(
                          //                     onPressed: () async {
                          //                       final provider = context.read<CustomViewModel>();
                          //                       EasyLoading.show(status: 'Deleting...');
                          //                       await provider.deleteAccount().then((value) async {
                          //                         EasyLoading.dismiss();
                          //                         if (value == "success") {
                          //                           commonToast(context, "Account has been deleted");
                          //                           AppPreferences.clearAll();
                          //                           pop(context);
                          //                           pop(context);
                          //                           pushReplacement(context, const LoginScreen());
                          //                         } else {
                          //                           commonToast(context, value);
                          //                         }
                          //                       });
                          //                     },
                          //                     style: ElevatedButton.styleFrom(
                          //                         backgroundColor: Colors.red,
                          //                         shape: RoundedRectangleBorder(
                          //                           borderRadius: BorderRadius.circular(6.0),
                          //                         )),
                          //                     child: Text(
                          //                       "Delete",
                          //                       style: Theme.of(context).textTheme.button?.copyWith(),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                        }
                        // push(context, const DeleteAccount());
                      },
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "${AppText.version[state.language]}: 1.0.0$app_version",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(),
                    ),
                  ],
                ),
              ),
            ),
          )
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
        style: Theme.of(context).textTheme.displaySmall?.copyWith(),
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
