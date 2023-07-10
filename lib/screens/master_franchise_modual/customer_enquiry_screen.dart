import 'package:employee_app/models/enquiry_model.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_colors.dart';
import '../widgets/custom_appbar.dart';

class CustomerEnquiryScreen extends StatefulWidget {
  final String enquiryUtype;
  final String enquiryUid;

  const CustomerEnquiryScreen({Key? key, required this.enquiryUtype, required this.enquiryUid}) : super(key: key);

  @override
  State<CustomerEnquiryScreen> createState() => _CustomerEnquiryScreenState();
}

class _CustomerEnquiryScreenState extends State<CustomerEnquiryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getEnquiryById(
            enquiryEmp: state.profileDetails!.userID ?? "",
            enquiryUid: widget.enquiryUid,
            enquiryUtype: widget.enquiryUtype);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CustomViewModel>(builder: (context, state, child) {
      return state.enqLoad
          ? Container(
              height: size.height * 0.6,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : state.enquiryListById.isEmpty
              ? Container(
                  height: size.height * 0.6,
                  alignment: Alignment.center,
                  child: Text(
                    "No Enquiry found",
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.enquiryListById.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                  itemBuilder: (context, index) {
                    EnquiryModel data = state.enquiryListById[index];
                    return CustomContainer(
                      size: size,
                      rad: 8,
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.enquiryName ?? "Customer Name",
                                  style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "subject : ",
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: Text(
                                        data.enquirySubject ?? "Subject is best subject forever",
                                        style: TextStyle(
                                            fontSize: size.width * 0.035,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.6)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        tilePadding: EdgeInsets.zero,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Message : ",
                                  style: TextStyle(fontSize: size.width * 0.035, color: AppColors.primary),
                                ),
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: Text(
                                    data.enquiryMessage ??
                                        "Description is the pattern of narrative "
                                            "development that aims to make vivid a place, "
                                            "object, character, or group. Description is "
                                            "one of four rhetorical modes, along with exposition, "
                                            "argumentation, and narration. In practice it would be "
                                            "difficult to write literature that drew on just one of "
                                            "the four basic modes",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
    });
  }
}
