import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/MainCategoryListParser.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import '../View Models/CustomViewModel.dart';
import '../theme/colors.dart';

class CompanyDropDown extends StatefulWidget {
  final String selectedValue;

  const CompanyDropDown({Key? key, required this.selectedValue}) : super(key: key);

  @override
  State<CompanyDropDown> createState() => _CompanyDropDownState();
}

class _CompanyDropDownState extends State<CompanyDropDown> {
  String selectedValue = "";

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return state.categoryList.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Text(
                AppText.inventory[state.language],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                ),
              ),
            )
          : SizedBox(
              width: size.width * 0.35,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.04),
                    color: AppColors.primary,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.white),
                  hint: Text(
                    widget.selectedValue,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  items: state.categoryList
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item.categoryName,
                          child: Text(
                            item.categoryName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    CategoryModel data = state.categoryList.where((element) => element.categoryName == value).first;
                    state.changeCatId(data.categoryId ?? "1");
                    state.filterSubCatList(data.categoryId ?? "1");
                    state.changeIndex(0);
                    state.changeSubCatId(state.filterSubCategoryList[0].subcategoryId ?? "1");
                    state.filterProduct(catId: data.categoryId ?? "1", subCatId: state.subCategoryId ?? "5");
                    setState(() {
                      selectedValue = value ?? widget.selectedValue;
                    });
                    // state.categoryList(
                    //   organization:
                    //       state.organizationByCandList.where((element) => element.organization == value).toList(),
                    // );
                    // log("====>>>${state.selectedOrganization[0].hrMail}");
                    // widget.onTap(value);
                  },
                  buttonHeight: 44,
                  buttonWidth: size.width * 0.5,
                  itemHeight: size.width * 0.12,
                ),
              ),
            );
    });
  }
}
