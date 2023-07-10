import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subjiwala_farmer/Widgets/CustomBtn.dart';
import 'package:subjiwala_farmer/theme/colors.dart';
import 'package:subjiwala_farmer/utils/helper.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
                ],
              ),
              Image.asset("assets/refer.png", width: size.width * 0.85),
              Text(
                "Refer Your Friends and Earn Cashback",
                style: TextStyle(fontSize: size.width * 0.045, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    margin: const EdgeInsets.only(top: 35, bottom: 55),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                    child: Text(
                      "2S4DDW514",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        fontSize: size.width * 0.048,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(const ClipboardData(text: "2S4DDW514"))
                          .then((value) => snackBar(context, "Copy to clipboard successfully", color: Colors.grey));
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 15),
                      margin: const EdgeInsets.only(top: 35, bottom: 55),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: Text(
                        "COPY",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          fontSize: size.width * 0.048,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Text(
                "Refer Your Friends to join Subjiwaala Farmer app and get Rs. "
                "50 Cashback on your app Wallet for each friend that join using your Referral Code",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.04, color: Colors.white),
              ),
              const Spacer(),
              Text(
                "Refer Your Friends also get Rs. "
                "50 Cashback on his app Wallet",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.04, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: CustomBtn(size: size, title: "INVITE NOW", onTap: () {}, btnColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
