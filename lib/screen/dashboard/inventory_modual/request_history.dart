import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sub_franchisee/models/product_model.dart';
import '../../../helper/app_colors.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_appbar.dart';

class RequestMoreHistory extends StatefulWidget {
  const RequestMoreHistory({Key? key}) : super(key: key);

  @override
  State<RequestMoreHistory> createState() => _RequestMoreHistoryState();
}

class _RequestMoreHistoryState extends State<RequestMoreHistory> {
  @override
  void initState() {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await state.getRequestMore();
      },
    );
    super.initState();
  }

  Future<void> _onRefresh() async {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    await state.getRequestMore();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _refreshController.refreshCompleted();
  }

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMMM');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Product Request History"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              width: size.width,
                              margin: EdgeInsets.only(right: size.width * 0.05),
                              height: 40,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                icon: const Icon(Icons.date_range_rounded),
                                label: Text(
                                  _startDate.day == _endDate.day
                                      ? format.format(_startDate)
                                      : "${format.format(_startDate)} - ${format.format(_endDate)}",
                                  style: TextStyle(
                                    fontSize: size.width * 0.035,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    // color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  await _showDatePicker(state);
                                },
                              ),
                            ),
                            state.filterRequestHistory.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    height: size.height * 0.7,
                                    child: Text(
                                      "No Request yet...",
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.filterRequestHistory.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                                    itemBuilder: (context, index) {
                                      GetRequestMore data = state.filterRequestHistory[index];
                                      return Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          CustomContainer(
                                            size: size,
                                            rad: 8,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.55,
                                                      child: Text(
                                                        data.requestqtyPname ?? "",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.04,
                                                            fontWeight: FontWeight.w700,
                                                            color: AppColors.primary),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Date : ",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.03,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat('dd MMMM, yyyy')
                                                              .format(data.requestqtyDate ?? DateTime.now()),
                                                          style: TextStyle(
                                                              fontSize: size.width * 0.03,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black.withOpacity(0.6)),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Requested Qty.: ",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.03,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: size.width * 0.5,
                                                          child: Text(
                                                            "${data.requestqtyQty ?? "0"} kg",
                                                            style: TextStyle(
                                                                fontSize: size.width * 0.03,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black.withOpacity(0.6)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8, right: 15),
                                            child: (data.requestqtyStatus == "0")
                                                ? Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.04,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.orange),
                                                  )
                                                : (data.requestqtyStatus == "1")
                                                    ? Text(
                                                        "Approved",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.04,
                                                            fontWeight: FontWeight.w700,
                                                            color: AppColors.primary),
                                                      )
                                                    : Text(
                                                        "Cancelled",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.04,
                                                            fontWeight: FontWeight.w700,
                                                            color: AppColors.red),
                                                      ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(CustomViewModel state) async {
    final DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: Colors.grey,
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onSurface: Colors.grey,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate.start;
        _endDate = pickedDate.end;
        state.filterRequestMore(start: _startDate, end: _endDate);
        int diff = _endDate.difference(_startDate).inDays;
        log(_endDate.difference(_startDate).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }

  bool isEditable(DateTime date) {
    if ((date.difference(DateTime.now()).inDays > 0)) {
      return true;
    } else {
      return false;
    }
  }
}
