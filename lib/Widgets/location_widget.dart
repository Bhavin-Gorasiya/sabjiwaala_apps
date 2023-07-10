import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:subjiwala/screens/dash_board/search_screen.dart';
import 'package:subjiwala/utils/helper.dart';

import '../theme/colors.dart';

class LocationWidget extends StatelessWidget {
  final Size size;
  final String address;

  const LocationWidget({super.key, required this.size, required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15.0, bottom: 15),
      child: Row(
        children: [
          // icon(onTap: () {}, icon: Icons.menu),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Image.asset(
                  "assets/icon_marker.png",
                  height: 20,
                  color: Colors.green,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Current Location",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700, fontSize: size.width * 0.042, letterSpacing: 1, wordSpacing: 1),
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: size.width * 0.035,
                          letterSpacing: 1,
                          wordSpacing: 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          icon(
              onTap: () {
                // FirebaseCrashlytics.instance.crash();
                push(context, const SearchScreen());
              },
              icon: Icons.search,
              padding: 0),
          const SizedBox(width: 15),
          // icon(onTap: () {}, icon: Icons.notifications, padding: 10),
          // const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget icon({required Function onTap, required IconData icon, double? padding}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 15),
        child: Icon(icon, size: size.width * 0.06, color: AppColors.primary),
      ),
    );
  }
}
