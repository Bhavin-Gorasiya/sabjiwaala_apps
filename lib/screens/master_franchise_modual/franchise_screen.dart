import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/master_franchise_modual/history_req.dart';
import 'package:employee_app/screens/master_franchise_modual/customer_enquiry_screen.dart';
import 'package:employee_app/screens/master_franchise_modual/detail_screen.dart';
import 'package:employee_app/screens/master_franchise_modual/sub_franchise.dart';
import 'package:employee_app/screens/widgets/customBtn.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:employee_app/screens/widgets/request_inventory.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../widgets/search.dart';
import 'detail_container.dart';

class FranchiseScreen extends StatefulWidget {
  final String title;
  final String tabString;
  final bool isFranchise;
  final UserModel data;

  const FranchiseScreen(
      {Key? key, required this.title, required this.tabString, this.isFranchise = false, required this.data})
      : super(key: key);

  @override
  State<FranchiseScreen> createState() => _FranchiseScreenState();
}

class _FranchiseScreenState extends State<FranchiseScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getData();
      },
    );
    super.initState();
  }

  Future getData() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getMasterDetails(
      empid: state.profileDetails!.userID ?? "0",
      empType: state.userList
              .where((element) => element.accessType == (widget.isFranchise ? "Sub Franchise" : "Franchise"))
              .first
              .accessId ??
          "0",
      upperId: widget.data.userId ?? "",
    );
    await state.getInventoryDetails(
        userID: widget.data.userId ?? "",
        userType: state.userList
                .where((element) => element.accessType == (widget.isFranchise ? "Franchise" : "Master Franchise"))
                .first
                .accessId ??
            "0");
  }

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await getData();
    _refreshController.refreshCompleted();
  }

  bool isEdit = false;
  bool isSearch = false;

  String selectedTab = 'Details';
  String search = '';

  @override
  Widget build(BuildContext context) {
    CustomViewModel provider = Provider.of<CustomViewModel>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getEnquiryById(
            enquiryEmp: state.profileDetails!.userID ?? "", enquiryUid: widget.data.userId ?? "", enquiryUtype: "2");
        return Future(() => false);
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
                size: size,
                title: widget.title,
                onTap: () async {
                  CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                  await state.getEnquiryById(
                      enquiryEmp: state.profileDetails!.userID ?? "",
                      enquiryUid: widget.data.userId ?? "",
                      enquiryUtype: "2");
                }),
            const SizedBox(height: 5),
            SizedBox(
              height: 30,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tabContainer(name: "Details", size: size, width: size.width * 0.25),
                    tabContainer(name: widget.tabString, size: size, width: size.width * 0.35),
                    tabContainer(name: "Request Inventory", size: size, width: size.width * 0.4),
                    tabContainer(name: "Enquiry", size: size, width: size.width * 0.25),
                  ],
                ),
              ),
            ),
            Consumer<CustomViewModel>(builder: (context, state, child) {
              // List<UserModel> list =
              return Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              selectedTab == "Request Inventory"
                                  ? state.masterReqInventory.isEmpty
                                      ? Container(
                                          height: size.height * 0.6,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No Inventory Request found",
                                            style: TextStyle(
                                              fontSize: size.width * 0.035,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : RequestInventory(
                                          requestQty: widget.isFranchise
                                              ? provider.franchiseReqInventory
                                              : provider.masterReqInventory,
                                          userType: widget.isFranchise ? "3" : "2")
                                  : selectedTab == "Details"
                                      ? DetailScreen(
                                          data: widget.data,
                                          isFranchise: widget.isFranchise,
                                          inventory:
                                              widget.isFranchise ? state.franchiseInventory : state.masterInventory)
                                      : selectedTab == "Enquiry"
                                          ? CustomerEnquiryScreen(
                                              enquiryUtype: widget.isFranchise ? "3" : "2",
                                              enquiryUid: widget.data.userId ?? "")
                                          : (widget.isFranchise
                                                  ? state.subFranchiseData.isEmpty
                                                  : state.franchiseData.isEmpty)
                                              ? Container(
                                                  height: size.height * 0.6,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "No '${widget.isFranchise ? "Sub Franchises" : "Franchises"}' found",
                                                    style: TextStyle(
                                                      fontSize: size.width * 0.035,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              : Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    isSearch
                                                        ? Search(
                                                            onChange: (value) {
                                                              state.searchUser(value!.toLowerCase(), "3");
                                                            },
                                                            onTap: () {
                                                              setState(() {
                                                                isSearch = false;
                                                                state.searchUser('', "3");
                                                              });
                                                            },
                                                            size: size)
                                                        : Padding(
                                                            padding: EdgeInsets.only(left: size.width * 0.05),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Total ${widget.tabString} "
                                                                  "( ${(widget.isFranchise ? state.subFranchiseData.length : state.franchiseData.length)} )",
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
                                                                      top: 8,
                                                                      right: size.width * 0.05,
                                                                      left: size.width * 0.05,
                                                                      bottom: 5,
                                                                    ),
                                                                    child:
                                                                        const Icon(Icons.search, color: Colors.black),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: (widget.isFranchise
                                                          ? state.searchSubFranchiseData.length
                                                          : state.searchFranchiseData.length),
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: size.width * 0.05, vertical: 10),
                                                      itemBuilder: (context, index) {
                                                        UserModel data = (widget.isFranchise
                                                            ? state.searchSubFranchiseData[index]
                                                            : state.searchFranchiseData[index]);
                                                        return DetailContainer(
                                                          index: index,
                                                          size: size,
                                                          data: data,
                                                          onTap: () {
                                                            if (widget.isFranchise) {
                                                              push(
                                                                context,
                                                                SubFranchiseScreen(
                                                                  title: "Name of Sub-Franchise",
                                                                  data: data,
                                                                ),
                                                              );
                                                            } else {
                                                              push(
                                                                context,
                                                                FranchiseScreen(
                                                                  title: "Name of Franchise",
                                                                  tabString: "Sub-Franchises",
                                                                  isFranchise: true,
                                                                  data: data,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                                                  ],
                                                ),
                            ],
                          ),
                        ),
                ),
              );
            }),
            if (selectedTab == "Request Inventory")
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    bottom: MediaQuery.of(context).padding.bottom + 10,
                    right: size.width * 0.05,
                    top: 10),
                child: CustomBtn(
                  size: size,
                  title: "History",
                  onTap: () {
                    push(
                        context,
                        ReqQtyHistory(
                          requestQty: widget.isFranchise ? provider.franchiseReqInventory : provider.masterReqInventory,
                        ));
                  },
                  btnColor: AppColors.primary,
                  radius: 10,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget tabContainer({required String name, required Size size, double? width}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = name;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 2.5,
              width: width ?? size.width / 3 - 25,
              color: selectedTab == name ? AppColors.primary : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
