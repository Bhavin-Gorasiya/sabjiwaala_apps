import 'package:employee_app/models/attendance_model.dart';
import 'package:employee_app/screens/attendance_modual/attendance_module.dart';
import 'package:employee_app/screens/dashboard_screen/setting_modual.dart';
import 'package:employee_app/screens/dashboard_screen/today_work_screen.dart';
import 'package:employee_app/screens/dashboard_screen/training_list_screen.dart';
import 'package:employee_app/screens/dashboard_screen/work_history.dart';
import 'package:employee_app/screens/farmer/farmer.dart';
import 'package:employee_app/screens/lead_modual/lead_list_screen.dart';
import 'package:employee_app/screens/master_franchise_modual/master_franchise_screen.dart';
import 'package:employee_app/screens/sign_up_modual/signup_screen.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:employee_app/helper/app_colors.dart';
import 'package:employee_app/helper/app_image.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../api/app_preferences.dart';
import '../../helper/navigations.dart';
import '../enquiry_modual/customer_enquiry_screen.dart';
import '../widgets/app_dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoad = false;

  getData() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    setState(() {
      isLoad = true;
    });
    await AppPreferences.setTime(DateTime.now().toString());
    await state.getProfile().then((value) async {
      if (value == "error") {
        await AppPreferences.clearAll().then((value) => pushReplacement(context, const SignUpScreen()));
      }
    });
    await state.getUser();
    await state.getState();
    await state.updateFCM(await FirebaseMessaging.instance.getToken() ?? "");
    if (!await AppPreferences.getAttendance()) {
      DateTime date = DateTime.now();
      await state.setAttendance(
          model: Attendance(
              attendanceDates: "${date.year}-${date.month}-${date.day}",
              attendanceStime: "${date.hour}:${date.minute}",
              attendanceIp: "123",
              attendanceUid: state.profileDetails!.userID,
              type: "checkin"));
    }
    AppPreferences.setAttendance(true);

    if (state.profileDetails!.userCityid != "") {
      await state.getCity(state.profileDetails!.userStateid!);
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await getData();
      },
    );
    super.initState();
  }

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await getData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        popup(
            title: "Are you sure want to exit app?",
            size: size,
            context: context,
            isBack: true,
            onYesTap: () {
              SystemNavigator.pop();
            });
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(right: size.width * 0.05, bottom: 20, top: MediaQuery.of(context).padding.top + 20, left: size.width * 0.05),
              child: Text(
                "Welcome to Subjiwaala",
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: isLoad
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                              child: Text(
                                "Numbers",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width * 0.055,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                numberContainer(name: "Master\nFranchises", number: state.totalMF, size: size, isRight: false),
                                const SizedBox(width: 25),
                                numberContainer(name: "Total\nFranchises", number: state.totalF, size: size),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                numberContainer(name: "Sub\nFranchises", number: state.totalSF, size: size, isRight: false),
                                const SizedBox(width: 25),
                                numberContainer(name: "Total\nFarmers", number: state.totalFM, size: size),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
                              child: Text(
                                "Employee Dashboard",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width * 0.058,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    container(
                                      isRight: false,
                                      name: "Master Franchises",
                                      icon: AppImages.master,
                                      size: size,
                                      onTap: () {
                                        // FirebaseCrashlytics.instance.crash();
                                        push(context, const MasterFranchiseScreen());
                                      },
                                    ),
                                    const SizedBox(width: 25),
                                    container(
                                      name: "Farmers",
                                      icon: AppImages.farmer,
                                      size: size,
                                      onTap: () {
                                        push(context, const FarmerScreen());
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    container(
                                      name: "Customer Enquiry",
                                      icon: AppImages.enquiry,
                                      isRight: false,
                                      size: size,
                                      onTap: () {
                                        push(context, const CustomerEnquiryScreen());
                                      },
                                    ),
                                    const SizedBox(width: 25),
                                    container(
                                      name: "General Settings",
                                      icon: AppImages.settings,
                                      size: size,
                                      onTap: () {
                                        push(context, const SettingScreen());
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    container(
                                      name: "Today's Work",
                                      icon: AppImages.lead,
                                      isRight: false,
                                      size: size,
                                      onTap: () {
                                        push(context, const TodayWorkScreen());
                                      },
                                    ),
                                    const SizedBox(width: 25),
                                    container(
                                      name: "Work History",
                                      icon: AppImages.work,
                                      size: size,
                                      onTap: () {
                                        push(context, const WorkHistory());
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    container(
                                      isRight: false,
                                      name: "Training\nModule",
                                      icon: AppImages.training,
                                      size: size,
                                      onTap: () {
                                        push(context, const TrainingListScreen());
                                      },
                                    ),
                                    const SizedBox(width: 25),
                                    container(
                                      name: "Generate\nLead",
                                      icon: AppImages.leadG,
                                      size: size,
                                      onTap: () {
                                        push(context, const LeadListScreen());
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    container(
                                      isRight: false,
                                      name: "Attendance\nModule",
                                      icon: AppImages.leave,
                                      size: size,
                                      onTap: () {
                                        push(context, const AttendanceModule());
                                      },
                                    ),
                                    const SizedBox(width: 25),
                                    const Expanded(child: SizedBox())
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
                          ],
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget container({required String name, required String icon, String? desc, required Size size, required Function onTap, double? iconWidth, bool isRight = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: isRight ? EdgeInsets.only(right: size.width * 0.05) : EdgeInsets.only(left: size.width * 0.05),
          padding: const EdgeInsets.all(15),
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                offset: const Offset(1, 1),
                blurRadius: 5,
              ),
              const BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                offset: Offset(-1, -1),
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(icon, width: iconWidth ?? size.width * 0.06),
              ),
              SizedBox(
                // width: size.width * 0.2,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.044,
                    fontWeight: FontWeight.w600,
                    // color: AppColors.primary,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget numberContainer({required String name, required String number, String? desc, required Size size, double? iconWidth, bool isRight = true}) {
  return Expanded(
    child: Container(
      margin: isRight ? EdgeInsets.only(right: size.width * 0.05) : EdgeInsets.only(left: size.width * 0.05),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            offset: const Offset(1, 1),
            blurRadius: 5,
          ),
          const BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
            offset: Offset(-1, -1),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.045,
            ),
          ),
          Text(
            number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: size.width * 0.055,
            ),
          ),
        ],
      ),
    ),
  );
}
