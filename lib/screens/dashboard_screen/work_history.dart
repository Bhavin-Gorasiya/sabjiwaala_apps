import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_app/helper/app_config.dart';
import 'package:employee_app/screens/master_franchise_modual/customer_enquiry_screen.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:employee_app/screens/widgets/image_loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../api/app_preferences.dart';
import '../../helper/app_colors.dart';
import '../../models/work_model.dart';
import '../../view model/CustomViewModel.dart';

class WorkHistory extends StatefulWidget {
  const WorkHistory({Key? key}) : super(key: key);

  @override
  State<WorkHistory> createState() => _WorkHistoryState();
}

class _WorkHistoryState extends State<WorkHistory> {
  @override
  void initState() {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        String userId = await AppPreferences.getLoggedin() ?? "";
        await state.getWork(userId);
      },
    );
    super.initState();
  }

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMMM');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Work History"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
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
                          state.filterWorkList.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  height: size.height * 0.7,
                                  child: Text(
                                    "No Task found",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.filterWorkList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                                  itemBuilder: (context, index) {
                                    WorkModel model = state.filterWorkList[index];
                                    return CustomContainer(
                                      size: size,
                                      rad: 8,
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.65,
                                                  child: Text(
                                                    model.workhistorySubject ?? "",
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.045,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppColors.primary),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Time : ",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.03,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${model.workhistoryTfrom} To ${model.workhistoryTto}",
                                                          style: TextStyle(
                                                              fontSize: size.width * 0.03,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black.withOpacity(0.6)),
                                                        ),
                                                      ],
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
                                                          "${model.workhistoryDate!.day}-${model.workhistoryDate!.month}-"
                                                          "${model.workhistoryDate!.year}",
                                                          style: TextStyle(
                                                              fontSize: size.width * 0.03,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black.withOpacity(0.6)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        tilePadding: EdgeInsets.zero,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Image : ",
                                                      style: TextStyle(
                                                          fontSize: size.width * 0.035, color: AppColors.primary),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Center(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  ConstrainedBox(
                                                                    constraints:
                                                                        BoxConstraints(maxHeight: size.height * 0.7),
                                                                    child: CachedNetworkImage(
                                                                      imageUrl: AppConfig.apiUrl +
                                                                          (model.workhistoryPic ?? ''),
                                                                      placeholder: (context, url) => const Center(
                                                                          child: CircularProgressIndicator(
                                                                              backgroundColor: AppColors.primary)),
                                                                      errorWidget: (context, url, error) =>
                                                                          const Center(child: Icon(Icons.file_present)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl: AppConfig.apiUrl + model.workhistoryPic!,
                                                          width: size.width * 0.15,
                                                          height: size.width * 0.15,
                                                          placeholder: (context, url) => ImageLoader(
                                                              height: size.width * 0.15,
                                                              width: size.width * 0.15,
                                                              radius: 10),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "task : ",
                                                      style: TextStyle(
                                                          fontSize: size.width * 0.035, color: AppColors.primary),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.6,
                                                      child: Text(
                                                        model.workhistoryMsg ??
                                                            "" /*"Description is the pattern of narrative "
                                                  "development that aims to make vivid a place, "
                                                  "object, character, or group. Description is "
                                                  "one of four rhetorical modes, along with exposition, "
                                                  "argumentation, and narration. In practice it would be "
                                                  "difficult to write literature that drew on just one of "
                                                  "the four basic modes"*/
                                                        ,
                                                        style: TextStyle(
                                                          fontSize: size.width * 0.035,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black.withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ],
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
        state.filterWork(start: _startDate, end: _endDate);
        int diff = _endDate.difference(_startDate).inDays;
        log(_endDate.difference(_startDate).inDays.toString());
        log(DateTime.now().difference(DateTime.now().subtract(Duration(days: diff + 1))).inDays.toString());
      });
    }
  }
}
