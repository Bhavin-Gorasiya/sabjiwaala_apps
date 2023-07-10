import 'package:delivery_app/screens/home_modual/home_screen.dart';
import 'package:delivery_app/screens/home_modual/order_history.dart';
import 'package:delivery_app/screens/home_modual/profile_modual/profile_screen.dart';
import 'package:delivery_app/screens/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../helper/app_colors.dart';
import '../../provider/custom_view_model.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> screens = const [
    HomeScreen(),
    OrderHistory(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        popup(
            title: "Are you sure want to exit app?",
            size: size,
            context: context,
            isBack: true,
            onYesTap: () {
              SystemNavigator.pop();
            });
        return Future(() => false);
      },
      child: Consumer<CustomViewModel>(builder: (context, state, child) {
        return Scaffold(
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 15, top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(0.0, 1.0), //(x,y)
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                btmBtn(
                  size: size,
                  icon: "assets/icon_home.png",
                  index: 0,
                  isSelect: state.bottomNavIndex == 0,
                  padding: 8,
                ),
                btmBtn(
                  size: size,
                  icon: "assets/order_his.png",
                  index: 1,
                  padding: 1.5,
                  isSelect: state.bottomNavIndex == 1,
                ),
                btmBtn(
                  size: size,
                  icon: "assets/icon_profile.png",
                  index: 2,
                  padding: 6,
                  isSelect: state.bottomNavIndex == 2,
                ),
              ],
            ),
          ),
          body: screens[state.bottomNavIndex],
        );
      }),
    );
  }

  Widget btmBtn(
      {required String icon, required int index, required bool isSelect, double? padding, required Size size}) {
    return GestureDetector(
      onTap: () {
        Provider.of<CustomViewModel>(context, listen: false).changeBottomNavIndex(index: index);
      },
      child: Container(
        padding: EdgeInsets.all(padding ?? 8),
        width: size.width * 0.2,
        height: size.width * 0.095,
        child: Image.asset(
          icon,
          color: isSelect ? AppColors.primary : Colors.black,
        ),
      ),
    );
  }
}
