import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:subjiwala_farmer/screens/dash_board/setting_modual/edit_profile.dart';
import 'package:subjiwala_farmer/screens/dash_board/setting_modual/refer_earn_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/setting_modual/setting_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/wallet_modual/my_wallet_screen.dart';

import '../../../View Models/CustomViewModel.dart';
import '../../../Widgets/app_dialogs.dart';
import '../../../Widgets/custom_icon_button.dart';
import '../../../api/app_preferences.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_config.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';

BuildContext? parentContextProfile;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {
    setState(() {
      parentContextProfile = context;
    });

    final providerListener = Provider.of<CustomViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: providerListener.profileDetails == null
          ? Container()
          : Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 15, bottom: MediaQuery.of(context).padding.bottom + 80),
              color: AppColors.bgColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomIconButton(
                            size: size,
                            icon: Icons.arrow_back_ios,
                            onTap: () {
                              pop(context);
                            },
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Stack(
                      children: [
                        /*  ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(50), // Image radius
                            child: Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                          ),
                        ),*/
                        (providerListener.profileDetails!.userPicture ?? "").isEmpty
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
                                    imageUrl: AppConfig.apiUrl + (providerListener.profileDetails!.userPicture ?? ""),
                                    placeholder: (context, url) =>
                                        Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                                    errorWidget: (context, url, error) =>
                                        Image.asset("assets/user_avatar.png", fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "${providerListener.profileDetails!.userFname!} ${providerListener.profileDetails!.userLname!}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.042),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          (providerListener.profileDetails!.userEmail!),
                          style: TextStyle(fontSize: size.width * 0.035),
                        ),
                      ),
                      Text(
                        (providerListener.profileDetails!.userMobileno1!),
                        style: TextStyle(fontSize: size.width * 0.035),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _OptionTile(
                          size: size,
                          icon: Icons.person,
                          title: "Edit profile",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primary,
                            size: sizes(size.width * 0.05, 25, size),
                          ),
                          onTap: () async {
                            push(context, const EditProfileScreen());
                          },
                        ),
                        Divider(
                          thickness: 1.6,
                          color: Colors.grey.shade200,
                        ),
                        _OptionTile(
                          size: size,
                          icon: Icons.account_balance_wallet,
                          title: "My wallet",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primary,
                            size: sizes(size.width * 0.05, 25, size),
                          ),
                          onTap: () async {
                            push(context, const MyWalletScreen());
                          },
                        ),
                        Divider(
                          thickness: 1.6,
                          color: Colors.grey.shade200,
                        ),
                        _OptionTile(
                          size: size,
                          icon: Icons.settings,
                          title: "Settings",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primary,
                            size: sizes(size.width * 0.05, 25, size),
                          ),
                          onTap: () async {
                            push(context, const SettingScreen());
                          },
                        ),
                        Divider(
                          thickness: 1.6,
                          color: Colors.grey.shade200,
                        ),
                        _OptionTile(
                          size: size,
                          icon: Icons.money,
                          title: "Refer & Earn",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primary,
                            size: sizes(size.width * 0.05, 25, size),
                          ),
                          onTap: () async {
                            push(context, const ReferEarnScreen());
                          },
                        ),
                        Divider(
                          thickness: 1.6,
                          color: Colors.grey.shade200,
                        ),
                        _OptionTile(
                          size: size,
                          icon: Icons.logout,
                          title: "Logout",
                          onTap: () async {
                            popup(
                                size: size,
                                context: context,
                                isBack: true,
                                title: "Are you sure you want"
                                    " to logout from your account?",
                                onYesTap: () async {
                                  await AppPreferences.clearAll().then((value) {
                                    pop(context);
                                    pushReplacement(context, LoginScreen());
                                  });
                                });
                            // final confirm = await AppDialog.logoutConfirmation(context);
                            // if (confirm) {
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({Key? key, required this.icon, required this.title, this.trailing, this.onTap, required this.size})
      : super(key: key);
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Size size;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ListTile(
        minLeadingWidth: 2,
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(fontSize: size.width * 0.042),
        ),
        trailing: trailing,
      ),
    );
  }
}
