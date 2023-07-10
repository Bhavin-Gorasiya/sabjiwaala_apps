import 'package:employee_app/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../helper/app_colors.dart';
import '../widgets/custom_widgets.dart';

class DetailScreen extends StatelessWidget {
  final UserModel data;
  final List inventory;
  final bool? isFranchise;

  const DetailScreen({Key? key, required this.data, required this.inventory, this.isFranchise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black38),
    );
    Size size = MediaQuery.of(context).size;
    return Padding(
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
                  "${data.userFname ?? ""} ${data.userLname ?? ""}",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  "📞 +91 ${data.userMobileno1}\n@  ${data.userEmail}",
                  style: TextStyle(
                    fontSize: size.width * 0.034,
                  ),
                ),
                Text(
                  "📍 ${data.userDistrict}, ${data.cityName}, ${data.stateName}",
                  style: TextStyle(
                    fontSize: size.width * 0.034,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Availability area :- ${data.userOfficearea}",
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
                    child: textWithIcon(size: size, text: "Call Now", icon: Icons.call, color: AppColors.primary),
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
                  "Total Items ( ${inventory.length} )",
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
                  itemCount: inventory.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return rowText(
                      isLow: isFranchise == null
                          ? int.parse(inventory[index].inventorysfrQty) < 5
                          : isFranchise!
                              ? int.parse(inventory[index].inventoryfrQty) < 40
                              : int.parse(inventory[index].inventorymfrQty) < 100,
                      item: isFranchise == null
                          ? inventory[index].inventorysfrPname ?? ""
                          : isFranchise!
                              ? inventory[index].inventoryfrPname ?? ""
                              : inventory[index].inventorymfrPname ?? "",
                      qty: int.parse(isFranchise == null
                          ? inventory[index].inventorysfrQty ?? "0"
                          : isFranchise!
                              ? inventory[index].inventoryfrQty ?? "0"
                              : inventory[index].inventorymfrQty ?? "0"),
                      size: size,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
        ],
      ),
    );
  }

  rowText({required String item, required int qty, required Size size, required bool isLow}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.4,
            child: Text(
              item,
              style: TextStyle(fontSize: size.width * 0.038, color: isLow ? AppColors.red : Colors.black),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.2,
            child: Text(
              "$qty Kg",
              style: TextStyle(fontSize: size.width * 0.038, color: isLow ? AppColors.red : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
