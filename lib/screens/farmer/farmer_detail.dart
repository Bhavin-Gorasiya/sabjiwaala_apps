import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../../models/user_model.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_widgets.dart';

class FarmerDetailScreen extends StatefulWidget {
  final UserModel data;

  const FarmerDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<FarmerDetailScreen> createState() => _FarmerDetailScreenState();
}

class _FarmerDetailScreenState extends State<FarmerDetailScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getInventoryDetails(
            userID: widget.data.userId ?? "",
            userType: state.userList.where((element) => element.accessType == ("Farmer")).first.accessId ?? "0");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black38),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, bottom: 15),
                      child: Text(
                        "Farmer",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: GestureDetector(
                  onTap: () {
                    pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: size.width * 0.05),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Consumer<CustomViewModel>(builder: (context, state, _) {
            return Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 10),
                                  decoration: boxDecoration,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.data.userFname ?? ""} ${widget.data.userLname ?? ""}",
                                        style: TextStyle(
                                          fontSize: size.width * 0.045,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        "📞 +91 ${widget.data.userMobileno1}   \n@  ${widget.data.userEmail}",
                                        style: TextStyle(
                                          fontSize: size.width * 0.034,
                                        ),
                                      ),
                                      Text(
                                        "📍 ${widget.data.userDistrict}, ${widget.data.cityName}, ${widget.data.stateName}",
                                        style: TextStyle(
                                          fontSize: size.width * 0.034,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Availability area :- ${widget.data.userOfficearea}",
                                        style: TextStyle(fontSize: size.width * 0.034),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            border: Border.all(color: AppColors.primary),
                                          ),
                                          child: textWithIcon(
                                              size: size, text: "Call Now", icon: Icons.call, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: boxDecoration,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Items ( ${state.farmerInventory.length} )",
                                        style: TextStyle(
                                          fontSize: size.width * 0.045,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Text(
                                              "Item Name",
                                              style: TextStyle(fontSize: size.width * 0.032, color: Colors.black54),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: size.width * 0.2,
                                            child: Text(
                                              "Qty. ( Kg. )",
                                              style: TextStyle(fontSize: size.width * 0.032, color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                      divideLine(size: size),
                                      ListView.builder(
                                        itemCount: state.farmerInventory.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return rowText(
                                            item: state.farmerInventory[index].inventoryfmPname ?? "",
                                            qty: int.parse(state.farmerInventory[index].inventoryfmQty ?? "0"),
                                            size: size,
                                            price: state.farmerInventory[index].inventoryfmPrice ?? "0",
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }

  rowText({required String item, required int qty, required Size size, required String price}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.4,
            child: Text(
              item,
              style: TextStyle(fontSize: size.width * 0.038, color: Colors.black),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.2,
            child: Text(
              "$qty Kg",
              style: TextStyle(fontSize: size.width * 0.038, color: Colors.black),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.22,
            child: Text(
              "₹$price /-",
              style: TextStyle(fontSize: size.width * 0.038, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
