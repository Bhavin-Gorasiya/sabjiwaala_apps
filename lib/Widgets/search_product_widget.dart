import 'package:flutter/material.dart';

import '../theme/colors.dart';

class SearchProductWidget extends StatelessWidget {
  const SearchProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: AppColors.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search_outlined, size: 25, color: Colors.white),
              Text(
                "Search Your Product",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 1,
                    wordSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
