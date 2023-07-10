import 'package:employee_app/models/enquiry_model.dart';
import 'package:flutter/material.dart';

import '../../helper/app_colors.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_widgets.dart';

class EnquiryDetailScreen extends StatelessWidget {
  final EnquiryModel data;

  const EnquiryDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Enquiry Detail"),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                child: Column(
                  children: [
                    CustomContainer(
                      size: size,
                      rad: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Enquiry for",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          divideLine(size: size),
                          columnText(
                              title: "Subject",
                              desc: data.enquirySubject ?? "Subject is best subject forever",
                              size: size),
                          const SizedBox(height: 8),
                          columnText(
                              title: "Message",
                              desc: data.enquiryMessage ??
                                  "Subject is best subject forever "
                                      "Subject is best subject forever "
                                      "Subject is best subject forever "
                                      "Subject is best subject forever ",
                              size: size),
                        ],
                      ),
                    ),
                    CustomContainer(
                      size: size,
                      rad: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Customer Details",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          divideLine(size: size),
                          columnText(title: "Name", desc: data.enquiryName ?? "Surname name", size: size),
                          const SizedBox(height: 8),
                          columnText(title: "Phone no.", desc: "+91 ${data.enquiryPhoneno}", size: size),
                          const SizedBox(height: 8),
                          columnText(title: "Email Id", desc: data.enquiryEmail ?? "demoemail@gmail.com", size: size),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 15, bottom: 5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.primary)),
                              child: textWithIcon(
                                  size: size, text: "Call Now", icon: Icons.call, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget doneContainer({
    required String text,
    required Function onTap,
    required Size size,
    required BuildContext context,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: size.width * 0.4,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: Text(
          text,
          style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
        ),
      ),
    );
  }

  Widget columnText({required String title, required String desc, required Size size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: TextStyle(fontSize: size.width * 0.035, color: Colors.black.withOpacity(0.7)),
        ),
      ],
    );
  }
}
