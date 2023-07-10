import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Widgets/CustomBtn.dart';
import '../../../theme/colors.dart';
import '../../auth/signup_screen.dart';

class AddWithdrawScreen extends StatefulWidget {
  final bool isAddMoneyScreen;

  const AddWithdrawScreen({Key? key, this.isAddMoneyScreen = false}) : super(key: key);

  @override
  State<AddWithdrawScreen> createState() => _AddWithdrawScreenState();
}

class _AddWithdrawScreenState extends State<AddWithdrawScreen> {
  TextEditingController money = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.045,
                  vertical: size.width * 0.02,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                ),
                child: TextFormField(
                  autofocus: true,
                  // validator: (String? arg) {
                  //   if (arg!.length < 10) {
                  //     return AppText.mobileValidation;
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  controller: money,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // suffixIcon: Icon(Icons.currency_rupee),
                    isDense: true,
                    hintText: "ex. ₹2000",
                    hintStyle: TextStyle(fontSize: size.width * 0.042),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  '₹',
                  style: TextStyle(fontSize: sizes(size.width * 0.05, 25, size), fontWeight: FontWeight.w500, color: AppColors.primary),
                ),
              )
            ],
          ),
          if (!widget.isAddMoneyScreen)
            Text(
              "*You can withdraw minimum ₹ 1000",
              style: TextStyle(color: AppColors.red),
            ),
          const SizedBox(height: 65),
          CustomBtn(
            size: size,
            title: widget.isAddMoneyScreen ? "Add Money" : "Withdraw",
            onTap: () {},
            btnColor: AppColors.primary,
          )
        ],
      ),
    );
  }
}
