import 'dart:io';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:employee_app/api/app_preferences.dart';
import 'package:employee_app/helper/app_config.dart';
import 'package:employee_app/helper/navigations.dart';
import 'package:employee_app/models/work_model.dart';
import 'package:employee_app/screens/dashboard_screen/camera_screen.dart';
import 'package:employee_app/screens/widgets/customBtn.dart';
import 'package:employee_app/screens/widgets/custom_appbar.dart';
import 'package:employee_app/screens/widgets/custom_textfields.dart';
import 'package:employee_app/screens/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_colors.dart';
import '../../view model/CustomViewModel.dart';

class TodayWorkScreen extends StatefulWidget {
  const TodayWorkScreen({Key? key}) : super(key: key);

  @override
  State<TodayWorkScreen> createState() => _TodayWorkScreenState();
}

class _TodayWorkScreenState extends State<TodayWorkScreen> {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Today's Work"),
          Consumer<CustomViewModel>(
            builder: (context, state, child) {
              return Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : state.todayWork.isEmpty
                        ? Center(
                            child: Text(
                              "No Task for today",
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.todayWork.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              WorkModel model = state.todayWork[index];
                              return GestureDetector(
                                onTap: () {
                                  state.changeCamImg(null);
                                  push(context, BottomSheet(workModel: model, isNew: false));
                                },
                                child: CustomContainer(
                                  vertPad: 15,
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
                                              model.workhistorySubject ?? "Subject",
                                              style: TextStyle(
                                                  fontSize: size.width * 0.045,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
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
                                        ],
                                      ),
                                      const Spacer(),
                                      Icon(Icons.arrow_forward_ios_outlined,
                                          color: AppColors.primary, size: size.width * 0.05)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 10,
              top: 10,
              right: size.width * 0.05,
              left: size.width * 0.05,
            ),
            child: CustomBtn(
              size: size,
              title: "Add New Task",
              onTap: () {
                final state = Provider.of<CustomViewModel>(context, listen: false);
                state.changeCamImg(null);
                push(context, const BottomSheet());
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          )
        ],
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  final WorkModel? workModel;
  final bool isNew;

  const BottomSheet({Key? key, this.workModel, this.isNew = true}) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  TextEditingController subject = TextEditingController();
  TextEditingController task = TextEditingController();

  String? start;
  String? end;
  bool empty = false;

  bool isCamera = false;

  @override
  void initState() {
    if (widget.workModel != null) {
      start = widget.workModel!.workhistoryTfrom!;
      end = widget.workModel!.workhistoryTto!;
      subject.text = widget.workModel!.workhistorySubject!;
      task.text = widget.workModel!.workhistoryMsg!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: widget.workModel != null ? "Today's Work" : "Add new task"),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                child: Consumer<CustomViewModel>(builder: (context, state, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workModel != null ? "Image" : "Add Image",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.048),
                      ),
                      Row(
                        children: [
                          if (!widget.isNew || (state.camImg != null && state.camImg != ''))
                            Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(8),
                                image: state.camImg == null || state.camImg == ''
                                    ? widget.workModel == null || widget.workModel!.workhistoryPic == ''
                                        ? null
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              AppConfig.apiUrl + widget.workModel!.workhistoryPic!,
                                            ),
                                          )
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                          File(state.camImg!),
                                        ),
                                      ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () async {
                              List<CameraDescription> camera = await availableCameras();
                              if (camera.isNotEmpty) {
                                push(context, CameraPage(cameras: camera));
                              } else {
                                setState(() {
                                  isCamera = true;
                                });
                                Future.delayed(const Duration(seconds: 2)).then((value) {
                                  setState(() {
                                    isCamera = false;
                                  });
                                });
                              }
                            },
                            child: Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(8),
                                /*  image: state.camImg == '' || isEdit
                                    ? null
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                          File(state.camImg),
                                        ),
                                      ),*/
                              ),
                              child: Icon(
                                Icons.camera,
                                size: size.width * 0.08,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isCamera)
                        Text(
                          "*No Camera Available",
                          style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                        ),
                      if (empty && state.camImg == null)
                        Text(
                          "*Please select image",
                          style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        "Select Time",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.048),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          timePicker(
                              context: context,
                              title: "From",
                              date: start == null
                                  ? "Select date"
                                      ""
                                  : start!,
                              onTap: (value) {
                                setState(() {
                                  start = value!.format(context);
                                  log("$start");
                                });
                              },
                              size: size),
                          timePicker(
                              context: context,
                              title: "To",
                              date: end == null
                                  ? "Select date"
                                      ""
                                  : end!,
                              onTap: (value) {
                                setState(() {
                                  end = value!.format(context);
                                });
                              },
                              size: size),
                        ],
                      ),
                      if (empty && (start == null || end == null))
                        Text(
                          "*Please select time",
                          style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                        ),
                      const SizedBox(height: 20),
                      CustomTextFields(hintText: "Subject", controller: subject),
                      if (empty && subject.text.isEmpty)
                        Text(
                          "*Subject is required",
                          style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                        ),
                      CustomTextFields(hintText: "Explain Task here", controller: task, maxLines: 4),
                      if (empty && task.text.isEmpty)
                        Text(
                          "*Please explain your task here",
                          style: TextStyle(fontSize: size.width * 0.03, color: AppColors.red),
                        ),
                      const SizedBox(height: 50),
                      CustomBtn(
                        size: size,
                        title: widget.workModel != null ? "Update" : "Add",
                        onTap: () async {
                          if (widget.workModel != null) {
                            pop(context);
                            await state
                                .editWork(
                                    model: WorkModel(
                                      workhistoryDate: widget.workModel!.workhistoryDate,
                                      workhistoryUid: widget.workModel!.workhistoryUid,
                                      workhistoryId: widget.workModel!.workhistoryId,
                                      workhistoryMsg: task.text,
                                      workhistorySubject: subject.text,
                                      workhistoryTfrom: start,
                                      workhistoryTto: end,
                                    ),
                                    img: state.camImg)
                                .then((value) {
                              if (value == "error") {
                                snackBar(context, "Unable to update task, Please try again");
                              }
                            });
                          } else {
                            if (state.camImg == null ||
                                start == null ||
                                end == null ||
                                subject.text.isEmpty ||
                                task.text.isEmpty) {
                              setState(() {
                                empty = true;
                              });
                            } else {
                              String userId = await AppPreferences.getLoggedin() ?? "";
                              pop(context);
                              await state
                                  .addWork(
                                      model: WorkModel(
                                        workhistoryUid: userId,
                                        workhistoryMsg: task.text,
                                        workhistorySubject: subject.text,
                                        workhistoryTfrom: start,
                                        workhistoryTto: end,
                                      ),
                                      img: state.camImg!)
                                  .then((value) {
                                if (value == "error") {
                                  snackBar(context, "Unable to add task, Please try again");
                                }
                              });
                            }
                          }
                        },
                        radius: 10,
                        btnColor: AppColors.primary,
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom)
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget timePicker({
  required String title,
  required String date,
  required Function(TimeOfDay?) onTap,
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
          showTimePicker(context: context, initialTime: const TimeOfDay(hour: 00, minute: 00)).then((value) {
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
                date,
                style: TextStyle(fontSize: size.width * 0.035, color: Colors.black54),
              ),
            )
          ],
        ),
      )
    ],
  );
}

String convertToYMDFormat(DateTime time) {
  String date = "${time.day < 10 ? '0${time.day}' : '${time.day}'}-"
      "${time.month < 10 ? '0${time.month}' : '${time.month}'}-"
      "${time.year}";
  return date;
}
