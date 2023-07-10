import 'package:employee_app/helper/navigations.dart';
import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/master_franchise_modual/detail_container.dart';
import 'package:employee_app/screens/master_franchise_modual/franchise_screen.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:employee_app/screens/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view model/CustomViewModel.dart';

class MasterFranchiseScreen extends StatefulWidget {
  const MasterFranchiseScreen({Key? key}) : super(key: key);

  @override
  State<MasterFranchiseScreen> createState() => _MasterFranchiseScreenState();
}

class _MasterFranchiseScreenState extends State<MasterFranchiseScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getMasterDetails(
            empid: state.profileDetails!.userID ?? "0",
            empType: state.userList.where((element) => element.accessType == "Master Franchise").first.accessId ?? "0");
      },
    );
    super.initState();
  }

  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Master Franchises"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.masterData.isEmpty
                      ? Center(
                          child: Text(
                          "No Master Franchises found",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              isSearch
                                  ? Search(
                                      onChange: (value) {
                                        state.searchUser(value!.toLowerCase(), "2");
                                      },
                                      onTap: () {
                                        setState(() {
                                          state.searchUser("", "2");
                                          isSearch = false;
                                        });
                                      },
                                      size: size)
                                  : Padding(
                                      padding: EdgeInsets.only(left: size.width * 0.05),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total Master Franchise ( ${state.masterData.length} )",
                                            style: TextStyle(
                                              fontSize: size.width * 0.05,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSearch = true;
                                              });
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              padding: EdgeInsets.only(
                                                top: 5,
                                                right: size.width * 0.05,
                                                left: size.width * 0.05,
                                                bottom: 5,
                                              ),
                                              child: const Icon(Icons.search, color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.searchMasterData.length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                                itemBuilder: (context, index) {
                                  UserModel data = state.searchMasterData[index];
                                  return DetailContainer(
                                    index: index,
                                    size: size,
                                    data: data,
                                    onTap: () {
                                      push(
                                        context,
                                        FranchiseScreen(
                                          data: data,
                                          title: "${data.userFname ?? ""} ${data.userLname ?? ""}",
                                          tabString: "Franchises",
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: MediaQuery.of(context).padding.bottom),
                            ],
                          ),
                        ),
            );
          }),
          /*  Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom,
                right: size.width * 0.05,
                top: 10),
            child: CustomBtn(
              size: size,
              title: "+  Add New Master Franchises",
              onTap: () {
                push(context, const AddFranchise(title: "New Master Franchise"));
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          )*/
        ],
      ),
    );
  }
}
