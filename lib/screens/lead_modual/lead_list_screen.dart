import 'package:employee_app/helper/navigations.dart';
import 'package:employee_app/models/lead_model.dart';
import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/lead_modual/add_lead.dart';
import 'package:employee_app/screens/widgets/customBtn.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api/app_preferences.dart';
import '../../helper/app_colors.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/custom_widgets.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  String selectedTab = 'Master Franchise';
  String selectedID = '0';

  @override
  void initState() {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    selectedTab = "Master Franchise";
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        String id = await AppPreferences.getLoggedin() ?? "";
        selectedID = state.userList.first.accessId ?? "";
        await state.getLead(id);
        await state.getAssignUser(empId: id);
      },
    );
    super.initState();
  }

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel provider = Provider.of<CustomViewModel>(context, listen: false);
    String id = await AppPreferences.getLoggedin() ?? "";
    selectedID = provider.userList.first.accessId ?? "";
    await provider.getLead(id);
    await provider.getAssignUser(empId: id);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Total Lead"),
          Container(
            height: 30,
            margin: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: provider.userList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                UserTypeModel data = provider.userList[index];
                return tabContainer(
                  provider: provider,
                  name: data.accessType ?? "",
                  size: size,
                  id: data.accessId ?? "",
                  width: size.width * 0.35,
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<CustomViewModel>(builder: (context, state, child) {
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : state.filterLeadList.isEmpty
                        ? Center(
                            child: Text(
                              "No Lead for $selectedTab",
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            itemCount: state.filterLeadList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              LeadModel data = state.filterLeadList[index];
                              return detailContainer(
                                states: state,
                                size: size,
                                data: data,
                                onTap: () {
                                  push(
                                    context,
                                    AddLead(text: selectedTab, leadModel: data, isEdit: false),
                                  );
                                },
                              );
                            },
                          ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: size.width * 0.05,
                left: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom + 10,
                top: 10),
            child: CustomBtn(
              size: size,
              title: "+  New Lead ($selectedTab)",
              onTap: () {
                push(
                    context,
                    AddLead(
                      text: selectedTab,
                      leadUid: provider.profileDetails!.userID,
                      leadType: selectedID,
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

  Widget tabContainer({
    required String name,
    required Size size,
    required double width,
    required String id,
    required CustomViewModel provider,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = name;
          selectedID = id;
        });
        provider.filterLead(id);
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
              width: width,
              margin: const EdgeInsets.only(top: 5),
              height: 2.5,
              color: selectedTab == name ? AppColors.primary : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget detailContainer({
    required Size size,
    required LeadModel data,
    required CustomViewModel states,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF5F5F5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.68,
                  child: Text(
                    "${data.leadFname} ${data.leadLname}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "📞 +91 ${data.leadMobileno}   \n@  ${data.leadEmail}",
                  style: TextStyle(
                    fontSize: size.width * 0.034,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: size.width * 0.75,
                  child: Text(
                    "📍 ${data.leadHaddress}",
                    style: TextStyle(
                      fontSize: size.width * 0.034,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              color: data.leadStatus!.toLowerCase() == "hot"
                  ? AppColors.red
                  : data.leadStatus!.toLowerCase() == "worm"
                      ? Colors.orangeAccent
                      : Colors.grey,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              data.leadStatus ?? "",
              style: TextStyle(
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: GestureDetector(
              onTap: () {
                popup(
                  size: size,
                  context: context,
                  title: "Are you sure want to Delete your Lead?",
                  isBack: true,
                  onYesTap: () async {
                    await states.deleteLead(data.leadId ?? "").then((value) {
                      if (value == "success") {
                      } else {
                        snackBar(context, "Unable to delete your Lead");
                      }
                    });
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  color: AppColors.red,
                ),
                child: Icon(Icons.delete, color: Colors.white, size: size.width * 0.05),
              ),
            ),
          )
        ],
      ),
    );
  }
}
