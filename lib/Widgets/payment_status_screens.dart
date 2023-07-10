import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/utils/helper.dart';

import '../View Models/CustomViewModel.dart';
import '../theme/colors.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentSuccess> createState() => PaymentSuccessState();
}

class PaymentSuccessState extends State<PaymentSuccess> {
  Widget _statusIcon() {
    const double _iconSize = 100;
    return const Icon(
      Icons.check_circle_rounded,
      size: _iconSize,
      color: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          state.changeBottomNavIndex(index: 0);
          pop(context);
          pop(context);
          return Future(() => false);
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          state.changeBottomNavIndex(index: 0);
                          pop(context);
                          pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: _statusIcon(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "Order placed successfully!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          "Your order has been placed, please check your mail for confirmation.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Order Id: D154FSFS5415",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomBtn(
                    size: size,
                    title: "Go back",
                    btnColor: AppColors.primary,
                    radius: 10,
                    onTap: () {
                      state.changeBottomNavIndex(index: 0);
                      pop(context);
                      pop(context);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentFailed extends StatefulWidget {
  const PaymentFailed({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentFailed> createState() => PaymentFailedState();
}

class PaymentFailedState extends State<PaymentFailed> {
  Widget _statusIcon() {
    return CircleAvatar(
      backgroundColor: AppColors.red,
      radius: 50,
      child: const Icon(
        Icons.close,
        size: 90,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 60,
          margin: EdgeInsets.all(size.width * 0.05),
          child: CustomBtn(
              size: size,
              title: "Go back",
              onTap: () {
                pop(context);
              },
              btnColor: AppColors.red,
              radius: 10),
        ),
        appBar: AppBar(iconTheme: IconThemeData(color: AppColors.red)),
        body: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: SizedBox(
            height: size.height * 0.65,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: _statusIcon(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "Order failed!, Please try again.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.red,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
