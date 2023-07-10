import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../../models/enquiry.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_textfields.dart';
import '../widgets/loading.dart';

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
    if (state.profileDetails != null) {
      name.text = "${state.profileDetails!.userFname ?? ""} ${state.profileDetails!.userLname ?? ""}";
      email.text = state.profileDetails!.userEmail ?? "";
      phone.text = state.profileDetails!.userMobileno1 ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).padding.bottom + 70,
        padding: EdgeInsets.only(
            right: size.width * 0.05,
            left: size.width * 0.05,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            top: 10),
        child: CustomBtn(
          size: size,
          title: "Send",
          btnColor: AppColors.primary,
          radius: 10,
          onTap: () async {
            CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
            if (subject.text.isNotEmpty || enquiry.text.isNotEmpty) {
              await state
                  .addEnquiry(
                model: Enquiry(
                  enquiryEmail: email.text,
                  enquiryMessage: enquiry.text,
                  enquiryName: name.text,
                  enquiryPhoneno: phone.text,
                  enquirySubject: subject.text,
                ),
              )
                  .then((value) {
                if (value == "success") {
                  snackBar(context, "Enquiry send successfully", color: AppColors.primary);
                  pop(context);
                } else {
                  snackBar(context, "Unable to send enquiry");
                }
              });
            } else {
              snackBar(context, "Please fill all fields");
            }
          },
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Send Enquiry"),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                            hintText: "Enter your full name", controller: name, readOnly: name.text.isNotEmpty),
                        const SizedBox(height: 5),
                        Text(
                          "Email ID",
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                          hintText: "Enter your mail id",
                          controller: email,
                          readOnly: email.text.isNotEmpty,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Mobile number",
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(
                          hintText: "Enter your mobile number",
                          controller: phone,
                          readOnly: phone.text.isNotEmpty,
                          lendth: 10,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Subject",
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(hintText: "Subject for enquiry", controller: subject),
                        const SizedBox(height: 5),
                        Text(
                          "Enquiry",
                          style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w500),
                        ),
                        CustomTextFields(hintText: "Explain Enquiry here...", controller: enquiry, maxLines: 5),
                        const SizedBox(height: 15),
                        Text(
                          "Send Enquiry to",
                          style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.w500),
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
