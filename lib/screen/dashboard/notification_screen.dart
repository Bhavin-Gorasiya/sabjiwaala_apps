import 'package:flutter/material.dart';
import 'package:sub_franchisee/screen/dashboard/inventory_modual/inventory_screen.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../widgets/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            size: size,
            title: "Notification",
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    push(context, const InventoryScreen());
                  },
                  child: CustomContainer(
                    horPad: 12,
                    vertPad: 12,
                    size: size,
                    rad: 8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.15,
                          height: size.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primary.withOpacity(0.4),
                          ),
                          child: Image.asset(
                            "assets/bg.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        SizedBox(
                          width: size.width * 0.62,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "This is the best product forever in world",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: size.width * 0.036,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "This is the best product forever in world",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: size.width * 0.032,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Required Qty.:",
                                    style: TextStyle(
                                        fontSize: size.width * 0.035, fontWeight: FontWeight.w400, color: Colors.black),
                                  ),
                                  Text(
                                    "15 Kg.",
                                    style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "View Stock",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: size.width * 0.034,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
