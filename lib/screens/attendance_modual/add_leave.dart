import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:employee_app/models/training_model.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:employee_app/screens/widgets/custom_widgets.dart';
import 'package:employee_app/screens/widgets/custom_widgets.dart';
import 'package:employee_app/screens/widgets/loading.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../api/app_preferences.dart';
import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/customBtn.dart';
import '../widgets/custom_textfields.dart';

class AddLeave extends StatefulWidget {
  final Leave? data;

  const AddLeave({Key? key, this.data}) : super(key: key);

  @override
  State<AddLeave> createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> {
  TextEditingController subject = TextEditingController();
  TextEditingController task = TextEditingController();

  DateTime? start;
  DateTime? end;
  bool empty = false;
  String selectType = "First Half Day";

  @override
  void initState() {
    // TODO: implement initState
    if (widget.data != null) {
      selectType = widget.data!.leaveType ?? "";
      task.text = widget.data!.leaveMessage ?? "";
      start = widget.data!.leaveFromdate;
      end = widget.data!.leaveTodate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Leave Type",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.04),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, right: 3, bottom: 20),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: const Text("Leave Type"),
                              isExpanded: true,
                              items: ['First Half Day', "Second Half Day", "One Day", "More Then One Day"]
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Row(
                                        children: [
                                          Text(
                                            item,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: size.width * 0.034,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: selectType,
                              onChanged: (value) {
                                setState(() {
                                  selectType = value ?? "";
                                });
                              },
                            ),
                          ),
                        ),
                        Text(
                          "Select Time",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.04),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: selectType == "More Then One Day"
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.start,
                          children: [
                            datePicker(
                                context: context,
                                title: selectType == "More Then One Day" ? "From" : "Date",
                                date: start == null
                                    ? "Select date"
                                        ""
                                    : start!.toString(),
                                onTap: (value) {
                                  setState(() {
                                    start = value;
                                    log("$start");
                                  });
                                },
                                size: size),
                            if (selectType == "More Then One Day")
                              datePicker(
                                  title: "To",
                                  date: end == null
                                      ? "Select date"
                                          ""
                                      : end!.toString(),
                                  onTap: (value) {
                                    setState(() {
                                      end = value;
                                    });
                                  },
                                  size: size,
                                  context: context),
                          ],
                        ),
                        const SizedBox(height: 5),
                        if (empty && (start == null || (selectType == "More Then One Day" && end == null)))
                          Text(
                            "*Please select time",
                            style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                          ),
                        textFiled(name: "Reason for leave...", controller: task, size: size, maxLines: 4),
                        if (empty && task.text.isEmpty)
                          Text(
                            "*Leave reason is required",
                            style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                          ),
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10, top: 25),
                          child: CustomBtn(
                            size: size,
                            title: widget.data != null ? "Edit Leave" : "Take Leave",
                            onTap: () async {
                              setState(() {
                                empty = true;
                              });
                              Future.delayed(
                                const Duration(seconds: 3),
                                () {
                                  setState(() {
                                    empty = false;
                                  });
                                },
                              );
                              if (task.text.isNotEmpty &&
                                  (start != null || (selectType != "More Then One Day" && end != null))) {
                                if (widget.data != null) {
                                  await state
                                      .editLeave(
                                          data: EditLeave(
                                              leaveUserid: widget.data!.leaveUserid ?? "",
                                              leaveId: widget.data!.leaveId,
                                              leaveFromdate: DateFormat("yyyy-MM-dd").format(start!),
                                              leaveTodate: end == null ? "" : DateFormat("yyyy-MM-dd").format(end!),
                                              leaveMessage: task.text,
                                              leaveType: selectType),
                                          userID: widget.data!.leaveUserid ?? "")
                                      .then((value) {
                                    if (value == "success") {
                                      pop(context);
                                    } else {
                                      snackBar(context, "Unable to edit task", color: AppColors.red);
                                    }
                                  });
                                } else {
                                  popup(
                                      size: size,
                                      context: context,
                                      title: "Are you sure want to Leave?",
                                      isBack: true,
                                      onYesTap: () async {
                                        String userId = await AppPreferences.getLoggedin() ?? "";
                                        {
                                          await state
                                              .addLeave(
                                                  data: AddLeaveModel(
                                                      leaveUserid: userId,
                                                      leaveFromdate: DateFormat("yyyy-MM-dd").format(start!),
                                                      leaveTodate:
                                                          end == null ? "" : DateFormat("yyyy-MM-dd").format(end!),
                                                      leaveMessage: task.text,
                                                      leaveType: selectType),
                                                  userID: userId)
                                              .then((value) {
                                            if (value == "success") {
                                              pop(context);
                                            } else {
                                              snackBar(context, "Unable to add task", color: AppColors.red);
                                            }
                                          });
                                        }
                                      });
                                }
                              }
                            },
                            btnColor: AppColors.primary,
                            radius: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (state.isLoading) const Loading()
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget datePicker({
  required String title,
  required String date,
  required Function(DateTime?) onTap,
  required Size size,
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$title :',
        style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 5),
      GestureDetector(
        onTap: () async {
          showDatePicker(
            context: context,
            initialDate: DateTime.now().add(const Duration(days: 1)),
            firstDate: DateTime.now().add(const Duration(days: 1)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          ).then((value) {
            if (value != null) {
              onTap(value);
            }
          });
        },
        child: Row(
          children: [
            Container(
              height: size.width * 0.1,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: const Icon(Icons.timer, color: Colors.white),
            ),
            Container(
              alignment: Alignment.center,
              height: size.width * 0.1,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Text(
                date == "Select date" ? "Select date" : DateFormat('dd/MM/yyyy').format(DateTime.parse(date)),
                style: TextStyle(fontSize: size.width * 0.035, color: Colors.black54),
              ),
            )
          ],
        ),
      )
    ],
  );
}
