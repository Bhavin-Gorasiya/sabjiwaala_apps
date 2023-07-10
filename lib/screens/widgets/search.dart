import 'package:flutter/material.dart';

import '../../helper/app_colors.dart';

class Search extends StatelessWidget {
  final Function onTap;
  final Function(String? value) onChange;
  final Size size;
  // final
  const Search({Key? key, required this.onTap, required this.size, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: size.width * 0.05),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          autofocus: true,
          cursorColor: AppColors.primary,
          onChanged: (String? value){
            onChange(value);
          },
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                onTap();
              },
              child: const Icon(Icons.close, color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.only(top: 15, left: 15),
            hintText: "Search items here...",
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
}
