import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/models/product_model.dart';
import 'package:sub_franchisee/screen/widgets/custom_textfields.dart';
import 'package:sub_franchisee/view%20model/CustomViewModel.dart';
import '../../../helper/navigations.dart';
import 'edit_inventory.dart';

class PopupMenuItems extends StatefulWidget {
  final Color color;
  final InventoryModel data;

  const PopupMenuItems({Key? key, required this.color, required this.data}) : super(key: key);

  @override
  State<PopupMenuItems> createState() => _PopupMenuItemsState();
}

class _PopupMenuItemsState extends State<PopupMenuItems> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopupMenuButton<int>(
      tooltip: '',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      color: widget.color,
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          height: 10,
          enabled: false,
          value: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vegetables',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                  const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 1,
                color: Colors.white,
              )
            ],
          ),
        ),
        const PopupMenuItem(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          height: 1,
          child: SizedBox(height: 1),
        ),
        popupMenu(
            value: 1,
            name: 'Details',
            size: size,
            onTap: () {
              pop(context);
              push(context, EditInventory(data: widget.data));
            }),
        popupMenu(
            value: 2,
            name: 'Request more',
            size: size,
            onTap: () {
              final state = Provider.of<CustomViewModel>(context, listen: false);
              pop(context);
              showDialog(
                // useSafeArea: false,
                context: context,
                builder: (context) => customPopup(
                  contex: context,
                  onTap: () async {
                    await state.requestMore(RequestMore(
                        requestqtyUname: "${state.profileDetails!.userFname} ${state.profileDetails!.userLname}",
                        requestqtyPname: widget.data.userproductPname ?? "",
                        requestqtyPid: widget.data.userproductId ?? "0",
                        requestqtyQty: qty.text,
                        requestqtyFuid: state.profileDetails!.userID ?? "",
                        requestqtyTuid: state.profileDetails!.userUid ?? "",
                        requestqtyTag: "SF")).then((value) => pop(context));
                  },
                  size: size,
                  desc: 'Enter Quantity of items in Kg. you want to request from your Franchise',
                  heading: 'Request more items',
                  btnName: 'Add new request',
                ),
              );
            }),
      ],
    );
  }

  PopupMenuItem<int> popupMenu({
    required String name,
    required Size size,
    required Function onTap,
    required int value,
  }) {
    return PopupMenuItem(
      value: value,
      height: 8,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          color: Colors.transparent,
          width: double.infinity,
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.045,
            ),
          ),
        ),
      ),
    );
  }

  Widget customPopup({
    required Size size,
    required String desc,
    required String heading,
    required String btnName,
    required BuildContext contex,
    Function? onTap,
  }) {
    log("${MediaQuery.of(context).viewPadding.bottom}");
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: _key,
        child: Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading,
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.red,
                            radius: size.width * 0.04,
                            child: const Icon(Icons.clear, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: size.width * 0.038,
                      ),
                    ),
                    CustomTextFields(
                      hintText: "Qty. in Kg.",
                      controller: qty,
                      keyboardType: TextInputType.phone,
                      validation: "Enter some values",
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          pop(contex);
                          if (onTap != null) onTap();
                        }
                      },
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(size.width * 0.2),
                        ),
                        child: Text(
                          btnName,
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 15)
            ],
          ),
        ),
      ),
    );
  }
}
