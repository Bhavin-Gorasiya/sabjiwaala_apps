import 'package:employee_app/helper/app_colors.dart';
import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/widgets/custom_widgets.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestInventory extends StatefulWidget {
  final List<RequestQtyModel> requestQty;
  final String userType;

  const RequestInventory({Key? key, required this.requestQty, required this.userType}) : super(key: key);

  @override
  State<RequestInventory> createState() => _RequestInventoryState();
}

class _RequestInventoryState extends State<RequestInventory> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, _) {
      List<RequestQtyModel> list = widget.userType == "3"
          ? state.franchiseReqInventory
          : widget.userType == "4"
              ? state.subFranchiseReqInventory
              : state.masterReqInventory;
      return list.isEmpty
          ? Container(
              height: size.height * 0.6,
              alignment: Alignment.center,
              child: Text(
                "No Request found",
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
              itemCount: list.length,
              itemBuilder: (context, index) {
                RequestQtyModel data = list[index];
                return data.requestqtyStatus == "0"
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dualText(title: "Product name:- ", desc: data.requestqtyPname ?? "", size: size),
                                  dualText(
                                      title: "Requested qty.:- ", desc: "${data.requestqtyQty ?? " "} kg.", size: size),
                                  dualText(
                                      title: "Date:- ",
                                      desc: DateFormat('dd MMMM, yyyy').format(data.requestqtyDate ?? DateTime.now()),
                                      size: size),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  await state.declineReq(
                                    userID: data.requestqtyFuid ?? "",
                                    userType: widget.userType,
                                    requestqtyID: data.requestqtyId ?? "",
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColors.red,
                                  child: const Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              GestureDetector(
                                onTap: () async {
                                  await state.acceptReq(
                                    productID: data.requestqtyPid ?? "",
                                    Qty: data.requestqtyQty ?? "",
                                    empID: state.profileDetails!.userID ?? "",
                                    userID: data.requestqtyFuid ?? "",
                                    userType: widget.userType,
                                    requestqtyID: data.requestqtyId ?? "",
                                  );
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.check, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          if (index + 1 != widget.requestQty.length)
                            Container(
                              margin: const EdgeInsets.all(15),
                              height: 1,
                              width: size.width,
                              color: Colors.black26,
                            )
                        ],
                      )
                    : index == 0 ? Container(
                        height: size.height * 0.6,
                        alignment: Alignment.center,
                        child: Text(
                          "No Request found",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ) : const SizedBox();
              },
            );
    });
  }
}
