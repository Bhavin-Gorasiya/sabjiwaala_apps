import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';

import '../../../Models/ProfileDetailsParser.dart';
import '../../../View Models/CustomViewModel.dart';
import '../../../Widgets/CustomBtn.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_textfields.dart';
import '../../../Widgets/loading.dart';
import '../../../theme/colors.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';

class SendEnquiry extends StatefulWidget {
  const SendEnquiry({Key? key}) : super(key: key);

  @override
  State<SendEnquiry> createState() => _SendEnquiryState();
}

class _SendEnquiryState extends State<SendEnquiry> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController enquiry = TextEditingController();

  @override
  void initState() {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    name.text = "${state.profileDetails!.userFname} ${state.profileDetails!.userLname}";
    email.text = state.profileDetails!.userEmail ?? "";
    phone.text = state.profileDetails!.userMobileno1 ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).padding.bottom + 70,
        padding: EdgeInsets.only(
            right: sizes(size.width * 0.05, 25, size),
            left: sizes(size.width * 0.05, 25, size),
            bottom: MediaQuery.of(context).padding.bottom + 10,
            top: 10),
        child: CustomBtn(
          size: size,
          title: AppText.send[state.language],
          btnColor: AppColors.primary,
          radius: 10,
          onTap: () async {
            CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
            if (subject.text.isNotEmpty || enquiry.text.isNotEmpty) {
              await state
                  .addEnquiry(
                model: Enquiry(
                  enquiryUtype: "4",
                  enquiryUid: state.profileDetails!.userID,
                  enquiryEmp: state.profileDetails!.userEmpid,
                  enquiryEmail: email.text,
                  enquiryMessage: enquiry.text,
                  enquiryName: name.text,
                  enquiryPhoneno: phone.text,
                  enquirySubject: subject.text,
                ),
              )
                  .then((value) {
                if (value == "success") {
                  snackBar(context, AppText.enquirySendSuccessfully[state.language], color: AppColors.primary);
                  pop(context);
                } else {
                  snackBar(context, AppText.unableSendEnquiry[state.language]);
                }
              });
            } else {
              snackBar(context, AppText.pleaseFillFields[state.language]);
            }
          },
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.sendEnquiryS[state.language]),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.names[state.language],
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                            hintText: AppText.enterYourFullName[state.language],
                            controller: name,
                            readOnly: name.text.isNotEmpty),
                        const SizedBox(height: 5),
                        Text(
                          AppText.emailId[state.language],
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                          hintText: AppText.enterMailId[state.language],
                          controller: email,
                          readOnly: email.text.isNotEmpty,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          AppText.mobileNumber[state.language],
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                          hintText: AppText.enterMobileNumber[state.language],
                          controller: phone,
                          readOnly: phone.text.isNotEmpty,
                          lendth: 10,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          AppText.subject[state.language],
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(hintText: AppText.subjectEnquiry[state.language], controller: subject),
                        const SizedBox(height: 5),
                        Text(
                          AppText.enquiry[state.language],
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                            hintText: AppText.explainEnquiryHere[state.language], controller: enquiry, maxLines: 5),
                        const SizedBox(height: 15),
                        Text(
                          AppText.sendEnquiryTo[state.language],
                          style: TextStyle(fontSize: sizes(size.width * 0.05, 25, size), fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        CustomContainer(
                          size: size,
                          rad: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sabjiwaala",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2, width: size.width),
                              Text(
                                "📞 +91 9856741235   \n@  masterfranchisesemailid@gmail.com",
                                style: TextStyle(
                                  fontSize: size.width * 0.034,
                                ),
                              ),
                            ],
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
