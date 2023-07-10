import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/screen/dashboard/statistics_modual/customer_review_screen.dart';
import 'package:sub_franchisee/screen/dashboard/statistics_modual/revenue_screen.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/navigations.dart';
import '../../../view model/CustomViewModel.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    await state.onlineState();
    await state.offlineState();
    await state.getAllProductName();
    await state.getReview();
    state.filterStatsList("Today");
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.onlineState();
        await state.offlineState();
        await state.getAllProductName();
        await state.getReview();
        state.filterStatsList("Today");
      },
    );
    super.initState();
  }

  String selectedTab = 'Online Sell';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 18,
                bottom: 20,
                right: size.width * 0.05,
                left: size.width * 0.05),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Text(
                      "Statistics",
                      style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    container(name: "Online Sell", size: size),
                    container(name: "Offline Sell", size: size),
                    container(name: "Customer Review", size: size),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: Consumer<CustomViewModel>(
                builder: (context, state, child) {
                  return state.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : selectedTab == "Customer Review"
                          ? const CustomerReview()
                          : RevenueGeneratedScreen(isOnline: selectedTab == "Online Sell");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget container({required String name, required Size size}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = name;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: size.width * 0.16,
        width: size.width * 0.28,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(selectedTab == name ? 0.3 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.width * 0.042,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
