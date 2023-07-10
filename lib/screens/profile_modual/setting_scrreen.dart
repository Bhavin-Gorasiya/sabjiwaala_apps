import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';

import '../../Widgets/app_dialogs.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';

class OtherSetting extends StatelessWidget {
  final bool isLogin;
  const OtherSetting({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          appBar(context: context, title: "Other option", size: size),
          Container(
            width: size.width * 0.9,
            height: 2,
            color: Colors.black.withOpacity(0.1),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
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
                  divider(size: size),
                  common(
                    icon: Icons.share,
                    context: context,
                    title: "Share us",
                    onTap: () async {
                      Share.share('check out my website https://example.com', subject: 'Look what I made!');
                      // await AppDialog.aboutUs(context);
                    },
                  ),
                  divider(size: size),
                  common(
                    icon: Icons.star_rate,
                    context: context,
                    title: "Rate us",
                    onTap: () async {
                      // await AppDialog.aboutUs(context);
                    },
                  ),
                  if (isLogin) divider(size: size),
                  if (isLogin)
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
                            onYesTap: () async {});
                      },
                    ),
                  const SizedBox(height: 35),
                  Text(
                    "Version: 1.0.0$app_version",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(),
                  ),
                ],
              ),
            ),
          ),
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
