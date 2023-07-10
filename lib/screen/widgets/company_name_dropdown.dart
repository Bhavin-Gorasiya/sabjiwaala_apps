import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../../view model/CustomViewModel.dart';

final GlobalKey<PopupMenuButtonState> dropdownKey = GlobalKey<PopupMenuButtonState>();

class CompanyDropDown extends StatelessWidget {
  final String selectedValue;
  final Key dropdownKey;
  final Function(String org, String img) onTap;

  const CompanyDropDown({Key? key, required this.selectedValue, required this.onTap, required this.dropdownKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return state.inventoryData.isEmpty
          ? const Text("No Company")
          : PopupMenuButton<int>(
              key: dropdownKey,
              tooltip: '',
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.04)),
              color: AppColors.primary,
              iconSize: size.width * 0.1,
              offset: Offset.zero,
              padding: EdgeInsets.zero,
              position: PopupMenuPosition.under,
              itemBuilder: (context) => state.unitList
                  .map(
                    (item) => PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      height: 10,
                      enabled: false,
                      value: 1,
                      child: InkWell(
                        onTap: () {
                          onTap(item.unitsName ?? "", item.unitsID ?? "");
                          pop(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          child: Row(
                            children: [
                              SizedBox(width: size.width * 0.02),
                              SizedBox(
                                child: Text(
                                  item.unitsName ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.036,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black26)),
                child: Row(
                  children: [
                    Text(selectedValue, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
