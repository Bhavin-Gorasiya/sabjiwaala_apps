import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/colors.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';
import '../cart_screen.dart';
import '../widgets/payment_popup.dart';
import 'add_address.dart';

class AddressScreen extends StatefulWidget {
  final String userId;
  final bool isCartScreen;
  final int? totalPrice;
  final Widget? widget;

  const AddressScreen({
    Key? key,
    required this.userId,
    required this.isCartScreen,
    this.widget,
    this.totalPrice,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String payment = "COD";

  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, right: 15, left: 10, bottom: 4),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const SizedBox(width: 5),
                Text(
                  "Address details",
                  style: GoogleFonts.poppins(fontSize: size.width * 0.045),
                )
              ],
            ),
          ),
          Container(
            width: size.width * 0.9,
            height: 2,
            color: Colors.black.withOpacity(0.1),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.width < 350 ? size.width * 0.01 : 15, vertical: 10),
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: size.width * 0.03,
                                backgroundColor: Colors.black.withOpacity(0.1),
                                child: !widget.isCartScreen
                                    ? Text(
                                        '${index + 1}',
                                        style: const TextStyle(color: Colors.black, fontSize: 14),
                                      )
                                    : CircleAvatar(
                                        radius: size.width * 0.017,
                                        backgroundColor:
                                            selectedIndex == index ? AppColors.primary : Colors.black.withOpacity(0.1),
                                      ),
                              ),
                              SizedBox(width: size.width < 350 ? size.width * 0.01 : 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.65,
                                    child: Text(
                                      "state.addressList[index].addressesAddress",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.038, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    "Pin code: 356489.",
                                    style:
                                        GoogleFonts.poppins(fontSize: size.width * 0.032, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            customContainer(
                                                size: size,
                                                name: "Edit address",
                                                icon: Icons.edit,
                                                color: Colors.black.withOpacity(0.6),
                                                onTap: () {}),
                                            const SizedBox(height: 5),
                                            customContainer(
                                                size: size,
                                                name: "Delete address",
                                                icon: Icons.delete,
                                                color: Colors.red.withOpacity(0.6),
                                                onTap: () async {
                                                  pop(context);
                                                }),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      push(context, const EditAddress(tag: "", landmark: "", address: "", addressID: ""));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: size.width * 0.03,
                            backgroundColor: Colors.black.withOpacity(0.1),
                            child: Icon(Icons.add, size: sizes(size.width * 0.05, 25, size), color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Add new address",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.isCartScreen
              ? cartContainer(
                  totalPrice: "65",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                      builder: (context) {
                        return const PaymentPopup(isSubscription: false);
                      },
                    );
                  },
                  size: size,
                  isAddressScreen: true,
                  bottomPad: MediaQuery.of(context).padding.bottom + 10)
              : const SizedBox()
        ],
      ),
    );
  }

  Widget customContainer({
    required String name,
    required IconData icon,
    required Color color,
    required Function onTap,
    required Size size,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: size.width * 0.06,
            ),
            const SizedBox(width: 15),
            Text(
              name,
              style: GoogleFonts.poppins(fontSize: size.width * 0.045),
            )
          ],
        ),
      ),
    );
  }
}
