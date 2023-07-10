import 'package:employee_app/models/enquiry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_appbar.dart';
import 'enquiry_detail_screen.dart';

class CustomerEnquiryScreen extends StatefulWidget {
  const CustomerEnquiryScreen({Key? key}) : super(key: key);

  @override
  State<CustomerEnquiryScreen> createState() => _CustomerEnquiryScreenState();
}

class _CustomerEnquiryScreenState extends State<CustomerEnquiryScreen> {
  String selectedTab = 'Master Franchise';
  String selectedID = '';

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel provider = Provider.of<CustomViewModel>(context, listen: false);
        await provider.getEnquiry(enquiryEmp: provider.profileDetails!.userID ?? "", enquiryUtype: "2");
      },
    );
    super.initState();
  }


  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel provider = Provider.of<CustomViewModel>(context, listen: false);
    await provider.getEnquiry(enquiryEmp: provider.profileDetails!.userID ?? "", enquiryUtype: "2");
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    CustomViewModel provider = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Customer Enquiry"),
          const SizedBox(height: 10),
          Row(
            children: [
              tabContainer(name: 'Master Franchise', size: size, width: size.width / 2, id: '2', provider: provider),
              tabContainer(name: 'Farmer', size: size, width: size.width / 2, id: '5', provider: provider),
            ],
          ),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.enquiryList.isEmpty
                        ? Center(
                            child: Text(
                              "No Enquiry for $selectedTab",
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.enquiryList.length,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            itemBuilder: (context, index) {
                              EnquiryModel data = state.enquiryList[index];
                              return GestureDetector(
                                onTap: () {
                                  push(context, EnquiryDetailScreen(data: data));
                                },
                                child: CustomContainer(
                                  size: size,
                                  rad: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.enquiryName ?? "Customer Name",
                                            style: TextStyle(
                                                fontSize: size.width * 0.045,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "subject : ",
                                                style: TextStyle(
                                                  fontSize: size.width * 0.035,
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.58,
                                                child: Text(
                                                  data.enquirySubject ?? "Subject is best subject forever",
                                                  style: TextStyle(
                                                      fontSize: size.width * 0.035,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black.withOpacity(0.6)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: size.width * 0.05,
                                        color: AppColors.primary,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            );
          })
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
      onTap: () async {
        setState(() {
          selectedTab = name;
          selectedID = id;
        });
        await provider.getEnquiry(enquiryEmp: provider.profileDetails!.userID ?? "", enquiryUtype: id);
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
}
