import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/utils.dart';

class ItemsInCartWidget extends StatelessWidget {
  const ItemsInCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        color: AppColors.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "1 item in cart",
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 1,
                      wordSpacing: 1),
                ),
                Text(
                  rupeeSign + " " + "70.00/Kg",
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 1,
                      wordSpacing: 1),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7.0),
                ),
                color: AppColors.bgColorCard,
              ),
              child: SizedBox(
                width: 100,
                height: 35,
                child: Center(
                  child: Text(
                    "View cart",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 1,
                        wordSpacing: 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
