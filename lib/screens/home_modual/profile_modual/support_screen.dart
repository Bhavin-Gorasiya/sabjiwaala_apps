import 'package:delivery_app/screens/widgets/custom_appbar.dart';
import 'package:delivery_app/screens/widgets/name_textfields.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Support"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                child: Column(
                  children: [
                    NameTextField(size: size, controller: name, hintText: "Enter your name", name: "Name"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
