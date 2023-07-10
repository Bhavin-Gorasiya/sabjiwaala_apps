// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:subjiwala_farmer/api/app_preferences.dart';
import 'package:subjiwala_farmer/screens/approved_order.dart';
import 'package:subjiwala_farmer/screens/auth/signup_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/categories_list_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/notification.dart';
import 'package:subjiwala_farmer/screens/dash_board/setting_modual/send_enquiry.dart';
import 'package:subjiwala_farmer/screens/dash_board/setting_modual/setting_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/training_modual/training_list_screen.dart';
import 'package:subjiwala_farmer/screens/dash_board/transaction_list_screen.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import '../../View Models/CustomViewModel.dart';
import '../../Widgets/custom_widgets.dart';
import '../../theme/colors.dart';
import '../../utils/app_image.dart';
import '../../utils/helper.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoad = false;
  RefreshController controller = RefreshController();

  Future<void> _onRefresh() async {
    await getData();
    controller.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getData();
      },
    );
    super.initState();
  }

  getData() async {
    final providerListener = Provider.of<CustomViewModel>(context, listen: false);
    setState(() {
      isLoad = true;
    });
    await providerListener.getProfile().then((value) async {
      if (value == "error") {
        await AppPreferences.clearAll().then((value) => pushReplacement(context, const LoginScreen()));
      }
    });
    await providerListener.getState();
    if (providerListener.profileDetails!.userCityid != "") {
      await providerListener.getCity(providerListener.profileDetails!.userStateid!);
    }
    await providerListener.getOrder();
    await providerListener.getAppVersion();
    await providerListener.getTransactionHistory();
    await providerListener.updateFCM(await FirebaseMessaging.instance.getToken() ?? "");
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // debugPrint("===>> width ${size.width}");
    // debugPrint("===>> height ${size.height}");
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
      child: isLoad
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Scaffold(
              backgroundColor: AppColors.primary,
              body: Center(
                child: Consumer<CustomViewModel>(builder: (context, providerListener, _) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).padding.top),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppText.farmer[providerListener.language],
                                  style: TextStyle(
                                    fontSize: sizes(size.width * 0.07, 30, size),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    push(context, const NotificationScreen());
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: sizes(size.width * 0.15, 25, size),
                                    height: sizes(size.width * 0.1, 35, size),
                                    child: Icon(Icons.notifications,
                                        color: Colors.white, size: sizes(size.width * 0.06, 30, size)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: sizes(size.width * 0.035, 35, size)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  // height: size.width * 0.26,
                                  padding: EdgeInsets.all(pad(8, 12, size)),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: sizes(size.width * 0.4, 200, size),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        AppText.totalApproved[providerListener.language],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: sizes(size.width * 0.045, 23, size),
                                        ),
                                      ),
                                      Text(
                                        providerListener.totalProduct,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: sizes(size.width * 0.055, 32, size),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // height: size.width * 0.26,
                                  padding: EdgeInsets.all(size.width > 500 ? 12 : 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: sizes(size.width * 0.4, 200, size),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        AppText.totalPendingAmount[providerListener.language],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: sizes(size.width * 0.045, 23, size),
                                        ),
                                      ),
                                      Text(
                                        "₹ ${providerListener.transactionModel.remainingAmt ?? "0"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: sizes(size.width * 0.055, 32, size),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (size.width > 500) const SizedBox(height: 25)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: SmartRefresher(
                            controller: controller,
                            onRefresh: _onRefresh,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                        child: Text(
                                          AppText.farmerDashBoard[providerListener.language],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: sizes(size.width * 0.07, 32, size),
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width > 500 ? 25 : 10),
                                  SizedBox(
                                    width: sizes(size.width, 600, size),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            container(
                                              isRight: false,
                                              name: AppText.pendingProducts[providerListener.language],
                                              icon: AppImages.orders,
                                              size: size,
                                              onTap: () {
                                                push(context, const OrderScreen());
                                              },
                                            ),
                                            const SizedBox(width: 25),
                                            container(
                                              name: AppText.inventory[providerListener.language],
                                              icon: AppImages.inventory,
                                              size: size,
                                              onTap: () async {
                                                // FirebaseCrashlytics.instance.crash();

                                                push(context, const CategoriesListScreen());
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 25),
                                        Row(
                                          children: [
                                            container(
                                              isRight: false,
                                              name: AppText.approvedProduct[providerListener.language],
                                              icon: AppImages.approved,
                                              size: size,
                                              onTap: () {
                                                push(context, const ApprovedOrder());
                                              },
                                            ),
                                            const SizedBox(width: 25),
                                            container(
                                              name: AppText.transactionHistory[providerListener.language],
                                              icon: AppImages.transaction,
                                              size: size,
                                              onTap: () {
                                                push(context, const TransactionListScreen());
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 25),
                                        Row(
                                          children: [
                                            container(
                                              isRight: false,
                                              name: AppText.sendEnquiry[providerListener.language],
                                              icon: AppImages.enquiry,
                                              size: size,
                                              onTap: () {
                                                push(context, const SendEnquiry());
                                              },
                                            ),
                                            const SizedBox(width: 25),
                                            container(
                                              name: AppText.generalSetting[providerListener.language],
                                              icon: AppImages.settings,
                                              size: size,
                                              onTap: () {
                                                push(context, const SettingScreen());
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 25),
                                        Row(
                                          children: [
                                            container(
                                              isRight: false,
                                              name: AppText.trainingModule[providerListener.language],
                                              icon: AppImages.training,
                                              size: size,
                                              onTap: () {
                                                push(context, const TrainingListScreen());
                                              },
                                            ),
                                            const SizedBox(width: 25),
                                            const Expanded(child: SizedBox())
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).padding.bottom + 60)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
    );
  }

  Widget container(
      {required String name,
      required String icon,
      String? desc,
      required Size size,
      required Function onTap,
      bool isRight = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: isRight ? EdgeInsets.only(right: size.width * 0.05) : EdgeInsets.only(left: size.width * 0.05),
          padding: const EdgeInsets.all(10),
          height: sizes(size.width * 0.32, 200, size),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                offset: const Offset(1, 1),
                blurRadius: 5,
              ),
              const BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                offset: Offset(-1, -1),
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8, bottom: 10),
                padding: EdgeInsets.all(size.width > 500 ? 12 : 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(icon, width: sizes(size.width * 0.06, 40, size)),
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sizes(size.width * 0.044, 24, size),
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/theme/colors.dart';
import 'package:subjiwala_farmer/utils/app_config.dart';
import 'package:subjiwala_farmer/utils/size_config.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/location_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        LocationWidget(size: size),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hi, Welcome!",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontSize: size.width * 0.045,
                            letterSpacing: 1,
                            wordSpacing: 1),
                      ),
                    ],
                  ),
                ),
                // const SearchProductWidget(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: false,
                        // aspectRatio: 2.0,
                        // height: 400,
                        viewportFraction: 1.0,
                        // enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: [0, 1]
                        .map(
                          (index) => Container(
                            padding:
                                EdgeInsets.only(top: 12, bottom: 5, right: sizes(size.width * 0.05, 25, size), left: size.width * 0.05),
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  color: AppColors.bgColorCard,
                                ),
                                height: SizeConfig.screenWidth! / 2,
                                width: SizeConfig.screenWidth!,
                                child: Image.network(
                                  index == 0
                                      ? "https://askmeguy.com/wp-content/uploads/2021/11/Fraazo-Referral-Code.jpg.webp"
                                      : "https://askmeguy.com/wp-content/uploads/2021/12/Fraazo-Rs-50-Off-Coupon-1024x426.jpg.webp",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1].asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: _current != entry.key
                          ? Container(
                              width: size.width * 0.022,
                              height: size.width * 0.022,
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                            )
                          : Container(
                              width: size.width * 0.022,
                              height: size.width * 0.022,
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customContainer(size: size, title: "Orders", desc: "123", color: const Color(0xff1B4C43)),
                      customContainer(size: size, title: "Operators", desc: "11", color: const Color(0xff717171)),
                      customContainer(size: size, title: "Franchise", desc: "22", color: const Color(0xffBA895D)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customContainer(size: size, title: "Vendors", desc: "12", color: const Color(0xffD22D3D)),
                      customContainer(size: size, title: "Customers", desc: "231", color: const Color(0xff2C323F)),
                      customContainer(size: size, title: "Inventory", desc: "67", color: const Color(0xffE2C636)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: size.width * 0.045,
                              letterSpacing: 1,
                              wordSpacing: 1,
                            ),
                      ),
                      Text(
                        "View All",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.underline,
                            fontSize: size.width * 0.038,
                            letterSpacing: 1,
                            wordSpacing: 1),
                      ),
                    ],
                  ),
                ),
                */
/*Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GridView.builder(
                        itemCount: 8,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 4.0),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: AppColors.bgColorCard,
                                ),
                                width: 65,
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                                child: index == 0 || index == 5 || index == 7
                                    ? Image.network(
                                        "http://clipart-library.com/image_gallery/327825.png",
                                        fit: BoxFit.contain,
                                      )
                                    : index % 2 == 0
                                        ? Image.network(
                                            "https://freepngimg.com/thumb/onion/164056-onion-free-transparent-image-hd.png",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            "https://image.similarpng.com/very-thumbnail/2020/06/Lemon-vector-transparent-PNG.png",
                                            fit: BoxFit.contain,
                                          ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  index % 2 == 0 ? "Garlic" : "Onions",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          wordSpacing: 1),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ),*/ /*

                providerListener.mainCategoryList.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(bottom: 5, left: sizes(size.width * 0.05, 25, size), right: size.width * 0.05),
                        child: SizedBox(
                          width: SizeConfig.screenWidth,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                              itemCount: providerListener.mainCategoryList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 4.0),
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        color: AppColors.bgColorCard,
                                      ),
                                      width: size.width * 0.17,
                                      height: size.width * 0.17,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          "https://upload.wikimedia.org/wikipedia/commons/9/90/Hapus_Mango.jpg"
                                          */
/*AppConfig.apiUrl +
                                              (providerListener.mainCategoryList[index].maincategoryPic ?? "")*/ /*
,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        providerListener.mainCategoryList[index].maincategoryName ?? "",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.headline3?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 1,
                                            wordSpacing: 1),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customContainer({required Size size, required String title, required String desc, required Color color}) {
    return Container(
      width: SizeConfig.screenWidth! / 3.7,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: size.width * 0.035,
                      letterSpacing: 0.7,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                alignment: Alignment.center,
                width: size.width * 0.15,
                height: size.width * 0.15,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: AppColors.bgColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    desc,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontWeight: FontWeight.w900, fontSize: size.width * 0.043, letterSpacing: 0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
*/
