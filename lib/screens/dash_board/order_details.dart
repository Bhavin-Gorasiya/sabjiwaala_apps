import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:subjiwala_farmer/Models/order_model.dart';
import 'package:subjiwala_farmer/View%20Models/CustomViewModel.dart';
import 'package:subjiwala_farmer/screens/dash_board/products_screens/product_detail.dart';
import 'package:subjiwala_farmer/screens/dash_board/qr_pdf_screen.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import '../../Models/ProductListParser.dart';
import '../../Models/transaction_model.dart';
import '../../Widgets/CustomBtn.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/custom_widgets.dart';
import '../../Widgets/rating_star.dart';
import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/helper.dart';
import '../auth/signup_screen.dart';

class OrderDetails extends StatefulWidget {
  final int? dueAmount;
  final OrderModel data;

  const OrderDetails({
    Key? key,
    required this.data,
    this.dueAmount,
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController name = TextEditingController();
  TextEditingController pQty = TextEditingController();
  TextEditingController vehicleNu = TextEditingController();
  TextEditingController pdfNumber = TextEditingController(text: "0");
  double progress = 0.0;

  Future startDownloading(String url) async {
    Dio dio = Dio();
    await [
      Permission.storage,
      //add more permission to request here.
    ].request().then((value) async {
      String fileName = url.split('/').last;
      if (value[Permission.storage]!.isGranted) {
        try {
          String path = await _getFilePath(fileName);
          log('==..$path $url');
          await dio.download(
            "https://www.africau.edu/images/default/sample.pdf",
            path,
            onReceiveProgress: (recivedBytes, totalBytes) {
              setState(() {
                progress = recivedBytes / totalBytes;
              });
            },
            deleteOnError: true,
          ).then((_) {
            Navigator.pop(context);
            snackBar(context, "$fileName Download Successfully", color: AppColors.primary);
          });
        } catch (err) {
          Navigator.pop(context);
          snackBar(context, "Unable to Download PDF", color: AppColors.red);
          log("err===>>> $err");
        }
      } else {
        Navigator.pop(context);
        snackBar(context, "No permission to read and write.", color: AppColors.red);
        log("No permission to read and write.");
      }
    });
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download/$filename";
    } else {
      return "${dir.path}/$filename";
    }
  }

  @override
  void initState() {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        await state.getReview(farmerID: widget.data.productFarmerid ?? "", productID: widget.data.productId ?? "");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CustomViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /* bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom / 2 + 15,
            right: size.width * 0.05,
            left: size.width * 0.05,
            top: 10),
        child: CustomBtn(
            title: AppText.deliveryProduct[state.language],
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppText.addDeliveryDetail[state.language],
                            style: TextStyle(
                              fontSize: sizes(size.width * 0.045, 20, size),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          textFiled(name: AppText.deliveryName[state.language], controller: name, size: size),
                          textFiled(name: AppText.vehicleNo[state.language], controller: name, size: size),
                          textFiled(name: AppText.productQty[state.language], controller: name, size: size),
                          const SizedBox(height: 50),
                          CustomBtn(
                              size: size,
                              title: AppText.deliveryProduct[state.language],
                              onTap: () {
                                pop(context);
                              },
                              btnColor: AppColors.primary,
                              radius: 10)
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            size: size,
            radius: 10,
            btnColor: AppColors.primary),
      ),*/
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.orderDetail[state.language]),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: sizes(size.width, 600, size),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        push(context, ProductDetails(product: widget.data));
                      },
                      child: CustomContainer(
                        horPad: sizes(12, 15, size),
                        vertPad: 7,
                        size: size,
                        rad: 8,
                        child: Row(
                          children: [
                            Container(
                              width: sizes(size.width * 0.16, 85, size),
                              height: sizes(size.width * 0.16, 85, size),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.primary.withOpacity(0.4),
                                  border: Border.all(color: Colors.black12)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: AppConfig.apiUrl + (widget.data.productPic ?? ""),
                                  errorWidget: (context, url, error) => Image.asset(
                                    "assets/banner2.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                                  placeholder: (context, url) =>
                                      ImageLoader(width: size.width * 0.16, height: size.width * 0.16, radius: 8),
                                ),
                              ),
                            ),
                            SizedBox(width: sizes(size.width * 0.03, 15, size)),
                            SizedBox(
                              width: sizes(size.width * 0.62, 370, size),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  dualText(
                                      title: AppText.productName[state.language],
                                      desc: "${widget.data.productName}",
                                      size: size),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      dualText(
                                          title: AppText.totalPrice[state.language],
                                          desc: "₹ ${widget.data.productTotalamt}",
                                          size: size),
                                      dualText(
                                          title: "${AppText.qty[state.language]}: ",
                                          desc: "${widget.data.productQty} ${AppText.kg[state.language]}",
                                          size: size),
                                    ],
                                  ),
                                  if (widget.dueAmount != null)
                                    dualText(
                                      title: AppText.duePayment[state.language],
                                      desc: "₹ ${widget.dueAmount}",
                                      size: size,
                                      color: Colors.red,
                                    ),
                                  const SizedBox(height: 2),
                                  dualText(
                                      title: AppText.totalPayment[state.language],
                                      desc: "₹ ${widget.data.transactionAmt}",
                                      size: size),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomContainer(
                      size: size,
                      rad: 8,
                      vertPad: 12,
                      horPad: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.totalTransaction[state.language],
                            style: TextStyle(
                              fontSize: sizes(size.width * 0.04, 20, size),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 8),
                            color: Colors.black,
                            width: double.infinity,
                            height: 0.5,
                          ),
                          detailText(
                              name: AppText.number[state.language],
                              weight: AppText.amountIn[state.language],
                              qty: AppText.transactionType[state.language],
                              size: size,
                              price: AppText.invoice[state.language],
                              isTitle: true),
                          const SizedBox(height: 5),
                          state.transactionList
                                  .where((element) => widget.data.productId == element.transactionsPid)
                                  .isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: size.width,
                                  child: Center(child: Text(AppText.noPayment[state.language])))
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: state.transactionList
                                      .where((element) => widget.data.productId == element.transactionsPid)
                                      .length,
                                  itemBuilder: (BuildContext context, int index) {
                                    TransactionList transaction = state.transactionList
                                        .where((element) => widget.data.productId == element.transactionsPid)
                                        .toList()[index];
                                    if (widget.data.productId == transaction.transactionsPid) {
                                      return detailText(
                                          name: '${index + 1}',
                                          weight: "${transaction.transactionsAmount}/-",
                                          qty: transaction.transactionsPMode ?? "",
                                          price: transaction.transactionsPdf ?? "",
                                          size: size);
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            color: Colors.black,
                            width: double.infinity,
                            height: 0.5,
                          ),
                          Row(
                            children: [
                              text(size: size, text: AppText.total[state.language]),
                              SizedBox(width: size.width * 0.027),
                              text(size: size, text: "₹ ${widget.data.transactionAmt}"),
                              const Spacer(),
                              if (widget.dueAmount != null)
                                dualText(
                                  title: AppText.duePayment[state.language],
                                  desc: "₹ ${widget.dueAmount}",
                                  size: size,
                                  color: Colors.red,
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                    CustomContainer(
                      size: size,
                      rad: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.printQr[state.language],
                            style: TextStyle(
                              fontSize: sizes(size.width * 0.04, 20, size),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (pdfNumber.text != '0') {
                                    int count = int.parse(pdfNumber.text);
                                    count = count - 1;
                                    setState(() {
                                      pdfNumber.text = count.toString();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove, size: 20),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                width: size.width * 0.15,
                                child: TextField(
                                  controller: pdfNumber,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                    border:
                                        const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade100,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    int count = int.parse(pdfNumber.text);
                                    count = count + 1;
                                    setState(() {
                                      pdfNumber.text = count.toString();
                                    });
                                  },
                                  icon: const Icon(Icons.add, size: 20)),
                            ],
                          ),
                          CustomBtn(
                            size: size,
                            title: AppText.generatePDF[state.language],
                            onTap: () {
                              if (pdfNumber.text != '0') {
                                if (int.parse(pdfNumber.text) > 700) {
                                  snackBar(context, AppText.youCan700[state.language]);
                                } else {
                                  List list = List.generate(int.parse(pdfNumber.text), (index) => "1");
                                  PdfViewPage.generateTransactionPDf(
                                      qr: AppConfig.apiUrl + (widget.data.productQrcode ?? ""), list: list);
                                }
                              }
                            },
                            btnColor: pdfNumber.text == '0' ? Colors.grey : AppColors.primary,
                            radius: 10,
                          ),
                        ],
                      ),
                    ),
                    Consumer<CustomViewModel>(builder: (context, state, child) {
                      double ratings = 0.0;
                      for(Review data in state.reviewList){
                        ratings += double.parse(data.reviewRating ?? "0.0");
                      }
                      return state.isLoading
                          ? Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: size.width,
                              child: const Center(child: CircularProgressIndicator()))
                          : state.reviewList.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: size.width,
                                  child: Center(child: Text(AppText.noReview[state.language])))
                              : Card(
                                  elevation: 3,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: ExpansionTile(
                                    textColor: Colors.black,
                                    iconColor: Colors.black,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Text(
                                            AppText.reviews[state.language],
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: size.width * 0.04,
                                                letterSpacing: 1,
                                                wordSpacing: 1),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        RatingStar(rating: ratings /state.reviewList.length, size: size),
                                      ],
                                    ),
                                    children: [
                                      ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: state.reviewList.length,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            Review data = state.reviewList[index];
                                            return Container(
                                              margin: const EdgeInsets.only(left: 15, right: 15),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                color: AppColors.bgColorCard,
                                              ),
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      RatingStar(
                                                          rating: double.parse(data.reviewRating ?? "0.0"), size: size),
                                                      const SizedBox(width: 7),
                                                      Text(
                                                        "${double.parse(data.reviewRating ?? "0.0")}",
                                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                            fontWeight: FontWeight.w800,
                                                            fontSize: size.width * 0.032,
                                                            letterSpacing: 0.7),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    data.reviewDesc ?? "",
                                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: size.width * 0.032,
                                                        letterSpacing: 0.7),
                                                  ),
                                                  const SizedBox(height: 4),
                                                ],
                                              ),
                                            );
                                          }),
                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailText({
    required String name,
    required String weight,
    required String qty,
    String? price,
    required Size size,
    bool isTitle = false,
    bool isTotal = false,
  }) {
    String downloadingprogress = (progress * 100).toInt().toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
            width: sizes(size.width * 0.06, 45, size),
            alignmentGeometry: Alignment.center,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: sizes(size.width * 0.26, 150, size),
            text: weight,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: sizes(size.width * 0.29, 160, size),
            text: qty,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        isTitle
            ? text(
                alignmentGeometry: Alignment.center,
                width: sizes(size.width * 0.2, 120, size),
                text: price ?? "",
                size: size,
                isTotal: isTotal,
                color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
                vertPad: 2)
            : GestureDetector(
                onTap: () async {
                  startDownloading(price ?? "");
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator.adaptive(),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Downloading: $downloadingprogress%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: sizes(size.width * 0.2, 120, size),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: text(
                      alignmentGeometry: Alignment.center,
                      width: sizes(size.width * 0.18, 10, size),
                      text: "Download",
                      size: size,
                      color: Colors.white,
                      vertPad: 2),
                ),
              ),
      ],
    );
  }

  Widget swipeBtm({required Function onSlide, required String text, required Size size, required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.05),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(15)),
      child: HorizontalSlidableButton(
        height: 45,
        isRestart: true,
        initialPosition: SlidableButtonPosition.start,
        buttonWidth: 60.0,
        color: Colors.transparent,
        width: double.infinity,
        onChanged: (SlidableButtonPosition position) {
          if (position == SlidableButtonPosition.end) {
            onSlide();
          }
        },
        label: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          margin: const EdgeInsets.all(5),
          height: 50,
          width: 60,
          child: const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ),
    );
  }
}

class AssignDeliverySheet extends StatefulWidget {
  final Size size;

  const AssignDeliverySheet({Key? key, required this.size}) : super(key: key);

  @override
  State<AssignDeliverySheet> createState() => _AssignDeliverySheetState();
}

class _AssignDeliverySheetState extends State<AssignDeliverySheet> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05, vertical: 15),
            child: Text(
              "Select Delivery boy",
              style: TextStyle(fontSize: widget.size.width * 0.05, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.05),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.03, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: selectedIndex == index ? AppColors.primary.withOpacity(0.4) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: widget.size.width * 0.06,
                          child: Image.asset("assets/user.png"),
                        ),
                        SizedBox(width: widget.size.width * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Boy",
                              style: TextStyle(
                                fontSize: widget.size.width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: widget.size.width * 0.01),
                            Text(
                              "+91 5654644646",
                              style: TextStyle(
                                  fontSize: widget.size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          CustomBtn(
              size: widget.size,
              title: "Full fill order",
              onTap: () {
                popup(
                  size: widget.size,
                  context: context,
                  onYesTap: () {
                    pop(context);
                  },
                  title: "Are you sure want to Fulfill Order?",
                );
              },
              btnColor: AppColors.primary)
        ],
      ),
    );
  }
}
