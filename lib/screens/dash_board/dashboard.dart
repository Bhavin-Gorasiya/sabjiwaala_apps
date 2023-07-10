// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:provider/provider.dart';
// import 'package:subjiwala_farmer/screens/dash_board/setting_modual/profile.dart';
//
// import '../../View Models/CustomViewModel.dart';
// import '../../Widgets/app_dialogs.dart';
// import '../../theme/colors.dart';
// import '../../utils/size_config.dart';
// import 'PostsWidget.dart';
// import 'categories_list_screen.dart';
// import 'home_screen.dart';
//
// class DashBoard extends StatefulWidget {
//   @override
//   _DashBoardState createState() => _DashBoardState();
// }
//
// class _DashBoardState extends State<DashBoard>
//     with SingleTickerProviderStateMixin {
//   late int currentPage;
//   late TabController tabController;
//
//   late Stream<StepCount> _stepCountStream;
//   late Stream<PedestrianStatus> _pedestrianStatusStream;
//   int steps = 0;
//
//   void onStepCount(StepCount event) {
//     /// Handle step count changed
//     print("steps");
//     print(steps);
//     setState(() {
//       steps = event.steps;
//     });
//     DateTime timeStamp = event.timeStamp;
//   }
//
//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     /// Handle status changed
//     String status = event.status;
//     DateTime timeStamp = event.timeStamp;
//   }
//
//   void onPedestrianStatusError(error) {
//     /// Handle the error
//   }
//
//   void onStepCountError(error) {
//     /// Handle the error
//   }
//
//   Future<void> initPlatformState() async {
//     /// Init streams
//     _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
//     _stepCountStream = await Pedometer.stepCountStream;
//
//     /// Listen to streams and handle errors
//     _stepCountStream.listen(onStepCount).onError(onStepCountError);
//     _pedestrianStatusStream
//         .listen(onPedestrianStatusChanged)
//         .onError(onPedestrianStatusError);
//   }
//
//   @override
//   void initState() {
//     currentPage = 0;
//
//     Provider.of<CustomViewModel>(context, listen: false).getProfile();
//     Provider.of<CustomViewModel>(context, listen: false).getAllProducts();
//     Provider.of<CustomViewModel>(context, listen: false).getAllMainCategory();
//     tabController = TabController(length: 3, vsync: this);
//     tabController.animation?.addListener(
//       () {
//         final value = tabController.animation!.value.round();
//         if (value != currentPage && mounted) {
//           changePage(value);
//         }
//       },
//     );
//     super.initState();
//     // initPlatformState();
//   }
//
//   void changePage(int newPage) {
//     setState(() {
//       currentPage = newPage;
//     });
//   }
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size  = MediaQuery.of(context).size;
//     SizeConfig().init(context);
//     return WillPopScope(
//       onWillPop: (){
//         popup(
//             title: "Are you sure want to exit app?",
//             size: size,
//             context: context,
//             isBack: true,
//             onYesTap: () {
//               SystemNavigator.pop();
//             });
//         return Future(() => false);
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.primary,
//         body: BottomBar(
//           clip: Clip.none,
//           fit: StackFit.expand,
//           borderRadius: BorderRadius.circular(0),
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.decelerate,
//           width: MediaQuery.of(context).size.width,
//           barColor: AppColors.bgColor,
//           start: 2,
//           end: 0,
//           bottom: -MediaQuery.of(context).padding.bottom,
//           alignment: Alignment.bottomCenter,
//           iconHeight: 30,
//           iconWidth: 30,
//           reverse: false,
//           hideOnScroll: true,
//           scrollOpposite: false,
//           onBottomBarHidden: () {},
//           onBottomBarShown: () {},
//           body: (context, controller) => Container(
//             color: AppColors.bgColor,
//             child: TabBarView(
//               controller: tabController,
//               dragStartBehavior: DragStartBehavior.down,
//               physics: const BouncingScrollPhysics(),
//               children: ["Home", "Inventory", "Profile"].map(
//                 (value) {
//                   if (value == "Home") {
//                     return const HomeScreen();
//                   } else if (value == "Inventory") {
//                     return const CategoriesListScreen();
//                   } else if (value == "Profile") {
//                     return const Profile(); //Profile();
//                   } else {
//                     return const HomeScreen();
//                   }
//                 },
//               ).toList(),
//             ),
//           ),
//           child: Container(
//             padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0.0, 1.0), //(x,y)
//                   blurRadius: 4.0,
//                 ),
//               ],
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               clipBehavior: Clip.none,
//               children: [
//                 TabBar(
//                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                   controller: tabController,
//                   indicatorColor: Colors.transparent,
//                   tabs: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       child: Center(
//                         child: Image.asset(
//                           "assets/icon_home.png",
//                           height: 25,
//                           color: currentPage == 0
//                               ? AppColors.primary
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       child: Center(
//                         child: Image.asset(
//                           "assets/icon_list.png",
//                           height: 20,
//                           color: currentPage == 1
//                               ? AppColors.primary
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       child: Center(
//                         child: Image.asset(
//                           "assets/icon_profile.png",
//                           height: 25,
//                           color: currentPage == 2
//                               ? AppColors.primary
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 /*tabController.index == 1
//                     ? Positioned(
//                         top: -60,
//                         child: SizedBox(
//                             width: SizeConfig.screenWidth,
//                             child: ItemsInCartWidget()))
//                     :
//                 Positioned(
//                   top: -25,
//                   child: FloatingActionButton(
//                     elevation: 0,
//                     backgroundColor: AppColors.primary,
//                     onPressed: () {},
//                     child: Image.asset(
//                       "assets/icon_cart.png",
//                       height: 25,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )*/
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
