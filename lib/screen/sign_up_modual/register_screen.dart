import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/screen/dashboard/home_screen.dart';

import '../../helper/app_colors.dart';
import '../../helper/navigations.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_textfields.dart';

class RegisterScreen extends StatefulWidget {
  final String mobile;

  const RegisterScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // FilePickerResult? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        // Provider.of<CustomViewModel>(context, listen: false).isLoading = false;
        pop(context);
        return Future(() => false);
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: const Image(
                  image: AssetImage("assets/background.png"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15),
                          padding: const EdgeInsets.only(bottom: 10, right: 10, top: 5),
                          child: const Icon(Icons.arrow_back, color: AppColors.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50, top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enter your details",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '+91 ${widget.mobile}',
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomTextFields(
                              controller: fName,
                              hintText: "First name*",
                              validation: "Please enter your first name",
                            ),
                            CustomTextFields(
                              controller: lName,
                              hintText: "Last name*",
                              validation: "Please enter your last name",
                            ),
                            CustomTextFields(
                              controller: email,
                              hintText: "Email address*",
                              isEmail: true,
                              keyboardType: TextInputType.emailAddress,
                              validation: EmailValidator.validate(email.text)
                                  ? "Please enter valid email address"
                                  : "Please enter your email",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: AppColors.primary,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 15,
                    right: 15,
                    left: 15,
                  ),
                  height: 50,
                  child: CustomBtn(
                    btnColor: AppColors.primary,
                    size: size,
                    title: "Submit",
                    onTap: () async {
                        push(context, const HomeScreen());
                      if (email.text.isNotEmpty && fName.text.isNotEmpty && lName.text.isNotEmpty) {
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Please fill all required fields",
                              style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    },
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
