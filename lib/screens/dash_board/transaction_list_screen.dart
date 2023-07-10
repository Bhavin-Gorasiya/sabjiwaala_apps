import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/transaction_model.dart';
import 'package:subjiwala_farmer/Widgets/custom_widgets.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import 'package:subjiwala_farmer/utils/helper.dart';

import '../../View Models/CustomViewModel.dart';
import '../../Widgets/custom_appbar.dart';
import '../../theme/colors.dart';
import '../auth/signup_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double progress = 0.0;

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getTransactionList();
      },
    );
    super.initState();
  }

  Future startDownloading(String url) async {
    Dio dio = Dio();
    await [
      Permission.storage,
      //add more permission to request here.
    ].request().then((value) async {
      String fileName = url.split('/').last;
      if (value[Permission.storage]!.isGranted) {
        try {
          String path = await _getFilePath(fileName);
          log('++..$path $url');
          await dio.download(
            "https://www.africau.edu/images/default/sample.pdf",
            path,
            onReceiveProgress: (recivedBytes, totalBytes) {
              setState(() {
                progress = recivedBytes / totalBytes;
              });
            },
            deleteOnError: true,
          ).then((_) {
            Navigator.pop(context);
            snackBar(context, "$fileName Download Successfully", color: AppColors.primary);
          });
        } catch (err) {
          Navigator.pop(context);
          snackBar(context, "Unable to Download PDF", color: AppColors.red);
          log("err===>>> $err");
        }
      } else {
        Navigator.pop(context);
        snackBar(context, "No permission to read and write.", color: AppColors.red);
        log("No permission to read and write.");
      }
    });
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download/$filename";
    } else {
      return "${dir.path}/$filename";
    }
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();
    final DateFormat format = DateFormat('dd MMMM');
    Size size = MediaQuery.of(context).size;
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.transactionHistoryS[state.language]),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            height: 40,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                              icon: const Icon(Icons.date_range_rounded),
                              label: Text(
                                startDate.day == endDate.day
                                    ? format.format(startDate)
                                    : "${format.format(startDate)} - ${format.format(endDate)}",
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
                          const SizedBox(height: 5),
                          state.filtertransactionList.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  height: size.height * 0.5,
                                  child: Text(AppText.noTransactionDataFound[state.language]),
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: state.filtertransactionList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    TransactionList data = state.filtertransactionList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.transactionsPname ?? "",
                                                style: TextStyle(
                                                  fontSize: size.width * 0.039,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('dd MMMM, yyyy')
                                                    .format(data.transactionsDate ?? DateTime.now()),
                                                style: TextStyle(
                                                  fontSize: size.width * 0.028,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              dualText(
                                                  textSize: size.width * 0.028,
                                                  title: AppText.transactionType[state.language],
                                                  desc: data.transactionsPMode ?? "",
                                                  size: size),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                AppText.transaction[state.language],
                                                style: TextStyle(
                                                  fontSize: size.width * 0.028,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${data.transactionsAmount ?? 0} ₹",
                                                style: TextStyle(
                                                    fontSize: size.width * 0.039,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: size.width * 0.03),
                                          GestureDetector(
                                              onTap: () async {
                                                startDownloading(data.transactionsPdf ?? "");
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.black,
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const CircularProgressIndicator.adaptive(),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            "${AppText.downloading[state.language]}: $downloadingprogress%",
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(Icons.download_for_offline,
                                                  size: size.width * 0.09, color: AppColors.primary))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
            );
          })
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
        startDate = pickedDate.start;
        endDate = pickedDate.end;
        state.filterWork(start: startDate, end: endDate);
        int diff = endDate.difference(startDate).inDays;
        log(endDate.difference(startDate).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }
}
