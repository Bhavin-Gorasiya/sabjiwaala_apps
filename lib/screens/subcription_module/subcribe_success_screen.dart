import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';

class SubscribeSuccess extends StatelessWidget {
  final String date;

  const SubscribeSuccess({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            // color: AppColors.primary,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 3, right: 15, left: 10, bottom: 3),
            child: Row(
              children: [
                IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      pop(context);
                      pop(context);
                      pop(context);
                    },
                    icon: const Icon(Icons.close, color: AppColors.primary)),
                const SizedBox(width: 5),
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    "Subscription Successful",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: size.width * 0.048,
                        letterSpacing: 1,
                        wordSpacing: 1,
                        color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045, vertical: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width,
                    margin: const EdgeInsets.only(top: 10,bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Image.asset("assets/success.png", width: 160),
                        Text(
                          "You subscription will start from $date",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: size.width * 0.035, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Text("How it works",
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: size.width * 0.042)),
                  Container(
                    width: size.width,
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        commonRow(
                            size: size,
                            title: "Hang a bag on your door",
                            desc: "Don't forget to hang a bag on your door everyday. This will ensure"
                                "that the items will remain fresh and intact.",
                            image: "assets/thella.png"),
                        Container(height: 2, color: Colors.black12),
                        commonRow(
                            size: size,
                            title: "Prepaid Wallet Service",
                            desc: "Maintain a positive balance in your wallet, else your subscription"
                                "might go on hold.",
                            image: "assets/wallet.png"),
                        Container(height: 2, color: Colors.black12),
                        commonRow(
                            size: size,
                            title: "Reserve Money",
                            desc: "You can reserve some amount in your wallet for uninturupted"
                                "subscription deliveries.",
                            image: "assets/piggy-bank.png"),
                        Container(height: 2, color: Colors.black12),
                        commonRow(
                            size: size,
                            title: "Simple and easy modification",
                            desc: "You can modify your orders by 10:00 PM to change the delivery for"
                                "the next day.",
                            image: "assets/refresh-button.png"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  commonRow({required Size size, required String title, required String desc, required String image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset(image, width: 25),
          const SizedBox(width: 15),
          SizedBox(
            width: size.width * 0.72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.6),
                        fontSize: size.width * 0.032)),
                Text(
                  desc,
                  style: TextStyle(color: Colors.black54, fontSize: size.width * 0.028),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
