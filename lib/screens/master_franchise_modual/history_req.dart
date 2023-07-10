import 'dart:developer';

import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper/app_colors.dart';
import '../../models/user_model.dart';
import '../widgets/custom_widgets.dart';

class ReqQtyHistory extends StatefulWidget {
  final List<RequestQtyModel> requestQty;

  const ReqQtyHistory({Key? key, required this.requestQty}) : super(key: key);

  @override
  State<ReqQtyHistory> createState() => _ReqQtyHistoryState();
}

class _ReqQtyHistoryState extends State<ReqQtyHistory> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMMM');

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "History"),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
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
                        startDate == null
                            ? "Select Date"
                            : startDate!.day == endDate!.day
                                ? format.format(startDate!)
                                : "${format.format(startDate!)} - ${format.format(endDate!)}",
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          // color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await _showDatePicker();
                      },
                    ),
                  ),
                  widget.requestQty.isEmpty
                      ? Container(
                          height: size.height * 0.6,
                          alignment: Alignment.center,
                          child: Text(
                            "No History found",
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                          itemCount: widget.requestQty.length,
                          itemBuilder: (context, index) {
                            RequestQtyModel data = widget.requestQty[index];
                            if (data.requestqtyDate!.difference(startDate ?? DateTime(2000)).inDays > 0 &&
                                data.requestqtyDate!.difference(endDate ?? DateTime.now()).inDays <= 0) {
                              log("done");
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dualText(
                                              title: "Product name:- ", desc: data.requestqtyPname ?? "", size: size),
                                          dualText(
                                              title: "Requested qty.:- ",
                                              desc: "${data.requestqtyQty ?? " "} kg.",
                                              size: size),
                                          dualText(
                                              title: "Date:- ",
                                              desc: DateFormat('dd MMMM, yyyy')
                                                  .format(data.requestqtyDate ?? DateTime.now()),
                                              size: size),
                                        ],
                                      ),
                                      const Spacer(),
                                      data.requestqtyStatus == '0'
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5), color: Colors.grey),
                                              child: const Text(
                                                "Pending",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            )
                                          : data.requestqtyStatus == '1'
                                              ? Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5), color: AppColors.primary),
                                                  child: const Text(
                                                    "Accepted",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                )
                                              : Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5), color: AppColors.red),
                                                  child: const Text(
                                                    "Cancelled",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                )
                                    ],
                                  ),
                                  if (index + 1 != widget.requestQty.length)
                                    Container(
                                      margin: const EdgeInsets.all(15),
                                      height: 1,
                                      width: size.width,
                                      color: Colors.black26,
                                    )
                                ],
                              );
                            } else if (data.requestqtyDate!.difference(startDate ?? DateTime(2000)).inDays < 0 &&
                                data.requestqtyDate!.difference(endDate ?? DateTime.now()).inDays >= 0) {
                              return const SizedBox();
                            } else {
                              return index == 0
                                  ? Container(
                                      height: size.height * 0.6,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No History found",
                                        style: TextStyle(
                                          fontSize: size.width * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            }
                          },
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
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
        startDate = pickedDate.start;
        endDate = pickedDate.end;
        // state.filterWork(start: startDate, end: endDate);
        int diff = endDate!.difference(startDate!).inDays;
        log(endDate!.difference(startDate!).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }
}
