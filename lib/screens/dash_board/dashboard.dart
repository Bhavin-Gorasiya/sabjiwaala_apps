import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/cloase_app_popup.dart';
import 'package:subjiwala/screens/dash_board/cart_screen.dart';
import 'package:subjiwala/screens/dash_board/profile_screen.dart';
import 'package:subjiwala/theme/colors.dart';
import '../../utils/size_config.dart';
import 'categories_list_screen.dart';
import 'home_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation?.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    Future.delayed(
      const Duration(seconds: 0),
          () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getAllProduct();
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<Widget> screens = [
    const HomeScreen(),
    const CategoriesListScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return WillPopScope(
        onWillPop: () {
          showDialog(
            context: context,
            builder: (context) => CloseAppPopup(onTapYes: () {
              SystemNavigator.pop();
            }),
          );
          return Future.value(false);
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.bgColor,
                  child: screens[state.bottomNavIndex],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
                        padding: 8),
                    btmBtn(
                        size: size,
                        icon: "assets/icon_list.png",
                        index: 1,
                        isSelect: state.bottomNavIndex == 1,
                        padding: 10),
                    btmBtn(size: size, icon: "assets/icon_cart.png", index: 2, isSelect: state.bottomNavIndex == 2),
                    // btmBtn(
                    //     size: size,
                    //     icon: "assets/icon_fav.png",
                    //     index: 3,
                    //     isSelect: state.bottomNavIndex == 3,
                    //     padding: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: btmBtn(
                          size: size,
                          icon: "assets/icon_profile.png",
                          index: 3,
                          isSelect: state.bottomNavIndex == 3,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget btmBtn(
      {required String icon, required int index, required bool isSelect, double? padding, required Size size}) {
    return GestureDetector(
      onTap: () {
        Provider.of<CustomViewModel>(context, listen: false).changeBottomNavIndex(index: index);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(padding ?? 8),
        width: size.width * 0.15,
        height: size.width * 0.095,
        child: Image.asset(
          icon,
          color: isSelect ? AppColors.primary : Colors.black,
        ),
      ),
    );
  }
}
