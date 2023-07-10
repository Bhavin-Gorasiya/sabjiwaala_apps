import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/utils/size_config.dart';

import '../theme/colors.dart';

class SearchProductWidget extends StatelessWidget {
  final Size size;
  const SearchProductWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width / 1.3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: AppColors.bgColorCard,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_outlined,
                    size: 25,
                    color: Colors.grey,
                  ),
                  Text(
                    "Search Your Product",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.grey,
                        letterSpacing: 1,
                        wordSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child:
                Icon(Icons.filter_list_alt, size: 22, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
