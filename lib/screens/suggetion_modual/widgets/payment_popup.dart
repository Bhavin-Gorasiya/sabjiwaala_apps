import 'package:flutter/material.dart';
import '../../../Widgets/CustomBtn.dart';
import '../../../theme/colors.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';

class PaymentPopup extends StatefulWidget {
  final bool isSubscription;

  const PaymentPopup({Key? key, required this.isSubscription}) : super(key: key);

  @override
  State<PaymentPopup> createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {
  String payment = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Options",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: sizes(size.width * 0.05, 25, size),
              ),
            ),
            const SizedBox(height: 10),
            container(name: "Cash on Delivery", grpValue: "COD", size: size),
            container(name: "Online Payment", grpValue: "Online", size: size),
            SizedBox(height: widget.isSubscription ? 50 :25),
            CustomBtn(
                size: size,
                title: payment == "call" ? "Call Now" : "Proceed",
                onTap: () {
                  pop(context);
                  pop(context);
                },
                btnColor: AppColors.primary,
                radius: 10),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }

  Widget container({required String name, required String grpValue, required Size size}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          payment = grpValue;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: payment == grpValue ? AppColors.primary : Colors.black54),
        ),
        child: Row(
          children: [
            Radio(
              value: payment,
              groupValue: grpValue,
              onChanged: (_) {
                setState(() {
                  payment = grpValue;
                });
              },
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: payment == grpValue ? FontWeight.w600 : FontWeight.w500,
                color: payment == grpValue ? AppColors.primary : Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }
}
