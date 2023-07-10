import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subjiwala_farmer/screens/dash_board/wallet_modual/transection_screen.dart';
import 'package:subjiwala_farmer/utils/helper.dart';
import '../../../theme/colors.dart';
import '../../auth/signup_screen.dart';
import 'add_withdraw_screen.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screenList = [
      const TransactionScreen(),
      AddWithdrawScreen(
        isAddMoneyScreen: screenIndex == 1,
      ),
      AddWithdrawScreen(
        isAddMoneyScreen: screenIndex == 1,
      )
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.width * 0.65,
            child: Stack(
              // alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: size.width * 0.55,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.045, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(size.width * 0.02),
                      bottomLeft: Radius.circular(size.width * 0.02),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: size.width * 0.07),
                          ),
                          SizedBox(width: size.width * 0.28),
                          Text(
                            "My wallet",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: sizes(size.width * 0.05, 25, size),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.07),
                      Text(
                        "39.542 ₹",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.082,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.035),
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.045, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        container(
                            onTap: () {
                              setState(() {
                                screenIndex = 0;
                              });
                            },
                            icon: "assets/icons/transection.png",
                            name: "Transaction",
                            size: size),
                        Container(
                          height: size.width * 0.1,
                          width: 1,
                          color: Colors.black.withOpacity(0.1),
                        ),
                        container(
                            onTap: () {
                              setState(() {
                                screenIndex = 1;
                              });
                            },
                            icon: "assets/icons/addmoney.png",
                            name: "Add money",
                            size: size),
                        Container(
                          height: size.width * 0.1,
                          width: 1,
                          color: Colors.black.withOpacity(0.1),
                        ),
                        container(
                            onTap: () {
                              setState(() {
                                screenIndex = 2;
                              });
                            },
                            icon: "assets/icons/getmoney.png",
                            name: "Withdraw",
                            size: size)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          screenList[screenIndex],
        ],
      ),
    );
  }

  Widget container(
      {required String icon, required String name, required Size size, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.transparent,
        width: size.width * .25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: size.width * 0.06,
              // height: size.width * 0.06,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: size.width * 0.038),
            ),
          ],
        ),
      ),
    );
  }
}
