// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:subjiwala_farmer/Models/order_model.dart';
//
// import '../../../View Models/CustomViewModel.dart';
// import '../../../Widgets/custom_appbar.dart';
// import '../../../theme/colors.dart';
// import '../../../utils/helper.dart';
// import 'enquiry_detail_screen.dart';
//
// class CustomerEnquiryScreen extends StatefulWidget {
//   const CustomerEnquiryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CustomerEnquiryScreen> createState() => _CustomerEnquiryScreenState();
// }
//
// class _CustomerEnquiryScreenState extends State<CustomerEnquiryScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     Future.delayed(
//       const Duration(seconds: 0),
//       () async {
//         CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
//         await state.getEnquiry();
//       },
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomAppBar(size: size, title: "Customer Enquiry"),
//           Consumer<CustomViewModel>(builder: (context, state, child) {
//             return Expanded(
//               child: state.isLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(color: AppColors.primary),
//                     )
//                   : ListView.builder(
//                       itemCount: state.enquiryList.length,
//                       physics: const BouncingScrollPhysics(),
//                       padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
//                       itemBuilder: (context, index) {
//                         EnquiryModel data = state.enquiryList[index];
//                         return GestureDetector(
//                           onTap: () {
//                             push(context, EnquiryDetailScreen(data : data));
//                           },
//                           child: CustomContainer(
//                             size: size,
//                             rad: 8,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       data.enquiryName ?? "Customer Name",
//                                       style: TextStyle(
//                                           fontSize: size.width * 0.045,
//                                           fontWeight: FontWeight.w700,
//                                           color: AppColors.primary),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "subject : ",
//                                           style: TextStyle(
//                                             fontSize: size.width * 0.035,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: size.width * 0.58,
//                                           child: Text(
//                                             data.enquirySubject ?? "subject",
//                                             style: TextStyle(
//                                                 fontSize: size.width * 0.035,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black.withOpacity(0.6)),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Icon(
//                                   Icons.arrow_forward_ios_outlined,
//                                   size: sizes(size.width * 0.05, 25, size),
//                                   color: AppColors.primary,
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             );
//           })
//         ],
//       ),
//     );
//   }
// }
