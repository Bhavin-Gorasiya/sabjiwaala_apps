import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/master_franchise_modual/customer_enquiry_screen.dart';
import 'package:employee_app/screens/master_franchise_modual/detail_screen.dart';
import 'package:employee_app/screens/widgets/request_inventory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/customBtn.dart';
import 'history_req.dart';

class SubFranchiseScreen extends StatefulWidget {
  final String title;
  final UserModel data;

  const SubFranchiseScreen({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  State<SubFranchiseScreen> createState() => _SubFranchiseScreenState();
}

class _SubFranchiseScreenState extends State<SubFranchiseScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getInventoryDetails(
            userID: widget.data.userId ?? "",
            userType: state.userList.where((element) => element.accessType == ("Sub Franchise")).first.accessId ?? "0");
      },
    );
    super.initState();
  }

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getInventoryDetails(
        userID: widget.data.userId ?? "",
        userType: state.userList.where((element) => element.accessType == ("Sub Franchise")).first.accessId ?? "0");
    _refreshController.refreshCompleted();
  }

  bool isEdit = false;

  String selectedTab = 'Details';

  @override
  Widget build(BuildContext context) {
    CustomViewModel provider = Provider.of<CustomViewModel>(context, listen: false);
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
                        widget.title,
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
          const SizedBox(height: 5),
          SizedBox(
            height: 30,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tabContainer(name: "Details", size: size),
                  tabContainer(name: "Request Inventory", size: size),
                  tabContainer(name: "Enquiry", size: size),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<CustomViewModel>(builder: (context, state, child) {
              return SmartRefresher(
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
                                        requestQty: state.subFranchiseReqInventory,
                                        userType: '4',
                                      )
                                : selectedTab == "Enquiry"
                                    ? CustomerEnquiryScreen(enquiryUtype: "4", enquiryUid: widget.data.userId ?? "")
                                    : DetailScreen(
                                        data: widget.data, inventory: state.subFranchiseInventory, isFranchise: null),
                          ],
                        ),
                      ),
              );
            }),
          ),
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
                        requestQty: provider.subFranchiseReqInventory,
                      ));
                },
                btnColor: AppColors.primary,
                radius: 10,
              ),
            )
        ],
      ),
    );
  }

  Widget tabContainer({required String name, required Size size}) {
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
              width: size.width / 3,
              color: selectedTab == name ? AppColors.primary : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
