import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../api/app_preferences.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/navigations.dart';
import '../../../models/leave_model.dart';
import '../../../provider/custom_view_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/loading.dart';

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
      selectType = widget.data!.leavedeliveryType ?? "";
      task.text = widget.data!.leavedeliveryMessage ?? "";
      start = widget.data!.leavedeliveryFromdate;
      end = widget.data!.leavedeliveryTodate;
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
                                              leavedeliveryID: widget.data!.leavedeliveryID ?? "",
                                              leavedeliveryDbid: widget.data!.leavedeliveryDbid,
                                              leavedeliverySubfid: DateFormat("yyyy-MM-dd").format(start!),
                                              leavedeliveryType:
                                                  end == null ? "" : DateFormat("yyyy-MM-dd").format(end!),
                                              leavedeliveryMessage: task.text,
                                              leavedeliveryFromdate: task.text,
                                              leavedeliveryTodate: selectType),
                                          userID: widget.data!.leavedeliveryDbid ?? "")
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
                                        final state = Provider.of<CustomViewModel>(context, listen: false);
                                        String userId = await AppPreferences.getLoggedin() ?? "";
                                        {
                                          await state
                                              .addLeave(
                                                  data: AddLeaveModel(
                                                      leavedeliveryDbid: userId,
                                                      leavedeliverySubfid: state.profileDetails!.sfId,
                                                      leavedeliveryType: selectType,
                                                      leavedeliveryMessage: task.text,
                                                      leavedeliveryFromdate: DateFormat("yyyy-MM-dd").format(start!),
                                                      leavedeliveryTodate:
                                                          end == null ? "" : DateFormat("yyyy-MM-dd").format(end!)),
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

  Widget textFiled({
    required String name,
    required TextEditingController controller,
    required Size size,
    int? maxLines,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 15),
      // width: size.width - size.width * 0.11,
      // height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          labelText: name,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
        ),
        maxLines: maxLines ?? 1,
        textCapitalization: TextCapitalization.words,
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
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
