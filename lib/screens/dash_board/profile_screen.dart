import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/screens/dash_board/orders_screen.dart';
import 'package:subjiwala/screens/profile_modual/address_screen.dart';
import 'package:subjiwala/screens/profile_modual/edit_profile.dart';
import 'package:subjiwala/screens/profile_modual/qr_scanner.dart';
import 'package:subjiwala/screens/profile_modual/setting_scrreen.dart';
import 'package:subjiwala/screens/subcription_module/subscription_screen.dart';
import 'package:subjiwala/screens/sign_up_modual/signup_screen.dart';

import '../../Widgets/cloase_app_popup.dart';
import '../../Widgets/login_popup.dart';
import '../../shared_prefe/app_preferences.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(
      builder: (context, state, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: size.width * 0.6,
                    child: Container(
                      alignment: Alignment.center,
                      height: size.width * 0.48,
                      width: size.width,
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 15),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Text(
                        state.uid == "" ? "" : "Hello, ${state.customerDetail[0].customerFirstname ?? "User"}!",
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.06,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  if (state.uid != "")
                    (state.customerDetail[0].customerPic ?? "") == "" ||
                            (state.customerDetail[0].customerPic ?? "") == "../img/profile/"
                        ? Container(
                            width: size.width * 0.25,
                            height: size.width * 0.25,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black.withOpacity(0.5)),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 55,
                              color: Colors.black,
                            ),
                          )
                        : Container(
                            width: size.width * 0.25,
                            height: size.width * 0.25,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black.withOpacity(0.5)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: AppConfig.apiUrl + state.customerDetail[0].customerPic!,
                                errorWidget: (context, url, error) => Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ),
                          )
                  else
                    Container(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black54),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 55,
                        color: Colors.black54,
                      ),
                    )
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    if (state.uid != "")
                      Text(
                        state.customerDetail[0].customerEmail ?? "Your email",
                        style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.w500),
                      ),
                    if (state.uid != "")
                      Text(
                        "${state.customerDetail[0].customerFirstname} ${state.customerDetail[0].customerLastname}",
                        style: TextStyle(
                            fontSize: size.width * 0.038,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    const SizedBox(height: 25),
                    profileContainer(
                        icon: "assets/userAvatar.png",
                        name: "Edit profile",
                        size: size,
                        onTap: () async {
                          if (state.uid == "") {
                            showDialog(
                              context: context,
                              builder: (context) => const LoginPopup(),
                            );
                          } else {
                            await Provider.of<CustomViewModel>(context, listen: false)
                                .getCustomerProfile(userId: state.uid)
                                .then((value) => {
                                      push(
                                          context,
                                          EditProfile(
                                              data:
                                                  Provider.of<CustomViewModel>(context, listen: false).customerDetail))
                                    });
                          }
                        },
                        iconSize: 26),
                    profileContainer(
                        icon: "assets/address.png",
                        name: "Add address",
                        size: size,
                        onTap: () {
                          if (state.uid == "") {
                            showDialog(
                              context: context,
                              builder: (context) => const LoginPopup(),
                            );
                          } else {
                            push(
                                context,
                                AddressScreen(
                                    userId: state.customerDetail[0].customerId!, isCartScreen: false, length: 0));
                          }
                        }),
                    profileContainer(
                        icon: "assets/bag.png",
                        name: "My Orders",
                        size: size,
                        onTap: () {
                          if (state.uid == "") {
                            showDialog(
                              context: context,
                              builder: (context) => const LoginPopup(),
                            );
                          } else {
                            push(context, const OrderScreen());
                          }
                        }),
                    profileContainer(
                        icon: "assets/subscribe.png",
                        name: "My Subscription Plan",
                        size: size,
                        onTap: () {
                          if (state.uid == "") {
                            showDialog(
                              context: context,
                              builder: (context) => const LoginPopup(),
                            );
                          } else {
                            push(context, const SubscriptionScreen());
                          }
                        }),
                    profileContainer(
                        icon: "assets/scanner.png",
                        name: "QR Scanner",
                        size: size,
                        onTap: () {
                          push(context, const QRViewExample());
                        }),
                    profileContainer(
                        icon: "assets/menu.png",
                        name: "Other options",
                        size: size,
                        onTap: () {
                          push(context, OtherSetting(isLogin: state.uid != ""));
                        }),
                    profileContainer(
                        icon: state.uid != "" ? "assets/exit.png" : "assets/login.png",
                        name: state.uid != "" ? "Logout" : "Login",
                        size: size,
                        onTap: () async {
                          if (state.uid == "") {
                            push(context, const SignUpScreen());
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => CloseAppPopup(onTapYes: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(isLogout: true),
                                  ),
                                );
                              }),
                            );
                            await AppPreferences.setLoggedin('');
                          }
                        },
                        isLast: false),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }

  Widget profileContainer({
    required String icon,
    required String name,
    required Size size,
    required Function onTap,
    bool isLast = true,
    double? iconSize,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Image(image: AssetImage(icon), width: iconSize ?? 22),
                const SizedBox(width: 15),
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: size.width * 0.042),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_sharp, size: 20)
              ],
            ),
          ),
        ),
        isLast
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                width: size.width,
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      AppColors.primary,
                      Colors.white,
                    ],
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
