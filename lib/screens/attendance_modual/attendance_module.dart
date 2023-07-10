import 'dart:developer';
import 'package:employee_app/helper/navigations.dart';
import 'package:employee_app/models/training_model.dart';
import 'package:employee_app/screens/attendance_modual/add_leave.dart';
import 'package:employee_app/screens/attendance_modual/popup_menu.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../api/app_preferences.dart';
import '../../helper/app_colors.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/customBtn.dart';

class AttendanceModule extends StatefulWidget {
  const AttendanceModule({Key? key}) : super(key: key);

  @override
  State<AttendanceModule> createState() => _AttendanceModuleState();
}

class _AttendanceModuleState extends State<AttendanceModule> {
  @override
  void initState() {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        String userId = await AppPreferences.getLoggedin() ?? "";
        await state.getLeave(userId);
      },
    );
    super.initState();
  }

  Future<void> _onRefresh() async {
    final state = Provider.of<CustomViewModel>(context, listen: false);
    String userId = await AppPreferences.getLoggedin() ?? "";
    await state.getLeave(userId);
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
          CustomAppBar(size: size, title: "Leave History"),
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
                            state.filterLeaveList.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    height: size.height * 0.7,
                                    child: Text(
                                      "No Leave yet...",
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.filterLeaveList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                                    itemBuilder: (context, index) {
                                      Leave data = state.filterLeaveList[index];
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
                                                      width: size.width * 0.65,
                                                      child: Text(
                                                        data.leaveType ?? "",
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
                                                          data.leaveType == "More Then One Day" ? "From : " : "Date : ",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.03,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat('dd MMMM, yyyy')
                                                              .format(data.leaveFromdate ?? DateTime.now()),
                                                          style: TextStyle(
                                                              fontSize: size.width * 0.03,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black.withOpacity(0.6)),
                                                        ),
                                                      ],
                                                    ),
                                                    if (data.leaveType == "More Then One Day")
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "To : ",
                                                            style: TextStyle(
                                                              fontSize: size.width * 0.03,
                                                            ),
                                                          ),
                                                          Text(
                                                            DateFormat('dd MMMM, yyyy')
                                                                .format(data.leaveTodate ?? DateTime.now()),
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
                                                          "Description : ",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.03,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: size.width * 0.5,
                                                          child: Text(
                                                            data.leaveMessage ?? "",
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
                                          if (isEditable(data.leaveFromdate ?? DateTime.now()))
                                            PopupMenuItems(data: data)
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
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 10,
              top: 10,
              right: size.width * 0.05,
              left: size.width * 0.05,
            ),
            child: CustomBtn(
              size: size,
              title: "Take Leave",
              onTap: () {
                push(context, const AddLeave());
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showDatePicker(CustomViewModel state) async {
    final DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        state.filterLeave(start: _startDate, end: _endDate);
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
