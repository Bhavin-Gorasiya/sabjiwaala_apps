import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/app_detail_model.dart';
import 'package:subjiwala_farmer/View%20Models/CustomViewModel.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import 'package:subjiwala_farmer/utils/helper.dart';

import '/utils/app_config.dart';
import '../theme/colors.dart';
import 'confirmation_popup_btn.dart';
import 'custom_widgets.dart';

List<String> socialAppList_links = [
  "https://www.facebook.com/",
  "https://www.instagram.com/",
  "https://www.linkedin.com/",
];

List<String> socialAppList = [
  "assets/facebook.png",
  "assets/instagram.png",
  "assets/linkedin.png",
];

class AppDialog {
  static Future<void> rating(BuildContext context) async {
    const double iconSize = 40.0;
    const double iconPadding = 0.0;
    const double splashRadius = 25.0;
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 5.0),
            titleTextStyle:
                Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            title: const Text("Rate Us"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Text("We appreciate your feedback"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(iconPadding),
                        onPressed: () {},
                        iconSize: iconSize,
                        splashRadius: splashRadius,
                        color: AppColors.primary,
                        icon: const Icon(Icons.star),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(iconPadding),
                        onPressed: () {},
                        iconSize: iconSize,
                        splashRadius: splashRadius,
                        color: AppColors.primary,
                        icon: const Icon(Icons.star),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(iconPadding),
                        onPressed: () {},
                        iconSize: iconSize,
                        splashRadius: splashRadius,
                        color: AppColors.primary,
                        icon: const Icon(Icons.star),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(iconPadding),
                        onPressed: () {},
                        iconSize: iconSize,
                        color: Colors.grey,
                        splashRadius: splashRadius,
                        icon: const Icon(Icons.star_border),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(iconPadding),
                        onPressed: () {},
                        iconSize: iconSize,
                        color: Colors.grey,
                        splashRadius: splashRadius,
                        icon: const Icon(Icons.star_border),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Not Now"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Never"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  static Future<void> contactUs(BuildContext context, Size size,
      {required String mobile, required String email, required String web}) async {
    Widget _options({
      required Widget title,
      required String value,
      required Function() onTap,
    }) {
      return Padding(
        padding: EdgeInsets.only(left: size.width * 0.05),
        child: Row(
          children: [
            title,
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  value,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return await showDialog(
      context: context,
      builder: (context) {
        final state = Provider.of<CustomViewModel>(context,listen: false);
        return AlertDialog(
          titlePadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actionsPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 8),
            child: Text(
              AppText.needHelp[state.language],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: size.width * 0.047, fontWeight: FontWeight.w500),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          content: Text.rich(
            TextSpan(
              text: AppText.contact1[state.language],
              style: TextStyle(fontSize: size.width * 0.032, color: Colors.black.withOpacity(0.8)),
              children: <InlineSpan>[
                TextSpan(
                  text: mobile,
                  style: const TextStyle(color: AppColors.primary),
                ),
                TextSpan(
                  text: AppText.contact2[state.language],
                ),
                TextSpan(
                  text: email,
                  style: TextStyle(color: AppColors.primary),
                ),
                TextSpan(
                  text: AppText.contact3[state.language],
                ),
              ],
            ),
          ),
          actions: [
            _options(
                title: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.link,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                value: web,
                onTap: () {}),
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
                          color: AppColors.primary, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: textWithIcon(
                        size: size,
                        text: AppText.callUs[state.language],
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
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: textWithIcon(
                        size: size,
                        text: AppText.mailUs[state.language],
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
  }

  static Future<void> aboutUs(BuildContext context, AppDetailModel data) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
            titleTextStyle:
                Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            title: Text(
              "About Us",
              style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.aboutus ??
                        "We provide platform to farmers and "
                            "customers to buy and purchase daily "
                            "products for cooking and spacial occasions.",
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: List.generate(
                        socialAppList.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: InkWell(
                                onTap: () {
                                  commonLaunchURL(Uri.parse(socialAppList_links[index]));
                                },
                                child: Image.asset(
                                  socialAppList[index],
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            )),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  // static Future<void> contactUs(BuildContext context) async {
  //   return await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
  //           titleTextStyle:
  //               Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
  //           title: Text(
  //             "About Us",
  //             style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
  //           ),
  //           content: SizedBox(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   "We provide platform to farmers and "
  //                   "customers to buy and purchase daily "
  //                   "products for cooking and spacial occasions.",
  //                   style: Theme.of(context).textTheme.headline3?.copyWith(),
  //                 ),
  //                 const SizedBox(height: 30),
  //                 Row(
  //                   children: List.generate(
  //                       socialAppList.length,
  //                       (index) => Padding(
  //                             padding: const EdgeInsets.only(right: 25),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 commonLaunchURL(Uri.parse(socialAppList_links[index]));
  //                               },
  //                               child: Image.asset(
  //                                 socialAppList[index],
  //                                 height: 25,
  //                                 width: 25,
  //                               ),
  //                             ),
  //                           )),
  //                 )
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 "OK",
  //                 style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  static Future<void> sosDialog(BuildContext context) async {
    Widget _options({required String title, required String value, required Function() onTap}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            Text("$title:"),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  value,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
            titleTextStyle:
                Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            title: Image.asset(
              "assets/sos2.png",
              width: 200,
              height: 200,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0, top: 15.0),
                    child: Text(
                      "If your need urgent help, please contact us",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _options(
                      title: "Phone",
                      value: AppConfig.sosnumber,
                      onTap: () async {
                        commonLaunchURL("tel:" + AppConfig.sosnumber);
                      }),
                  _options(
                      title: "E-mail",
                      value: AppConfig.sosemail,
                      onTap: () {
                        commonLaunchURL("mailto:" + AppConfig.sosemail);
                      }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  static Future<bool> exitConfirmation(BuildContext context) async {
    bool _exitConfirm = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
            titleTextStyle:
                Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            title: const Text("Exit?"),
            content: const Text("Are you sure to exit the app?"),
            actions: [
              TextButton(
                onPressed: () {
                  _exitConfirm = false;
                  Navigator.pop(context);
                },
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  _exitConfirm = true;
                  Navigator.pop(context);
                },
                child: const Text("YES"),
              ),
            ],
          );
        });
    return _exitConfirm;
  }

  static Future<bool> gotoLoginConfirmation(BuildContext context) async {
    bool _exitConfirm = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
            titleTextStyle:
                Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            title: const Text("Login"),
            content: const Text("Please login to access all features"),
            actions: [
              TextButton(
                onPressed: () {
                  _exitConfirm = false;
                  Navigator.pop(context);
                },
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  _exitConfirm = true;
                  Navigator.pop(context);
                },
                child: const Text("YES"),
              ),
            ],
          );
        });
    return _exitConfirm;
  }

  static Future<bool> logoutConfirmation(BuildContext context) async {
    bool _logoutConfirm = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
        title: const Center(
          child: Text(
            'Logout?',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Are you sure you want to logout from your account?',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _logoutConfirm = false;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "No",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          _logoutConfirm = true;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Logout",
                          textScaleFactor: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return _logoutConfirm;
  }

  static Future<void> thankYou(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
            titleTextStyle:
                Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            title: Image.asset(
              "assets/thank_you.png",
              fit: BoxFit.contain,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 20.0),
                    child: Text(
                      "Thank you!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "By making your voice heard, you help us improve Makeupcentral.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }
}

popup({
  required Size size,
  required BuildContext context,
  bool isBack = false,
  required String title,
  required Function onYesTap,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsPadding: EdgeInsets.zero,
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size.width * 0.05),
        ),
        actions: [
          Container(color: Colors.black12, height: 1),
          Row(
            children: [
              ConfirmationPopupBtn(
                  size: size,
                  title: "No",
                  onTap: () {
                    pop(context);
                  },
                  textColor: isBack ? Colors.black : Colors.white,
                  btnColor: isBack ? Colors.white : AppColors.red),
              ConfirmationPopupBtn(
                  size: size,
                  title: "Yes",
                  onTap: () {
                    onYesTap();
                    pop(context);
                  },
                  textColor: isBack ? Colors.white : Colors.black,
                  btnColor: isBack ? AppColors.red : Colors.white),
            ],
          ),
        ],
      );
    },
  );
}
