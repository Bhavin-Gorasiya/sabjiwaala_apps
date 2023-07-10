import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/Widgets/shimmer_loader/image_loader.dart';
import 'package:subjiwala/models/scan_produc_model.dart';
import 'package:subjiwala/screens/dash_board/orders_screen.dart';
import '../../models/review_model.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';
import '../dash_board/order_details.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  double ratings = 0.0;

  Barcode? result;
  bool isFlash = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    }
    controller!.resumeCamera();
  }

  TextEditingController review = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5, bottom: 5),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white)),
                if (result == null)
                  IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        isFlash = await controller!.getFlashStatus() ?? false;
                        setState(() {});
                      },
                      icon: Icon(!isFlash ? Icons.flash_on : Icons.flash_off, color: Colors.white)),
              ],
            ),
          ),
          Builder(builder: (context) {
            if (result == null) {
              log("===>>> code not scan");
              return Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      _buildQrView(context),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)),
                        child: const Text(
                          "Scan the QR code back of the product packet to review the farmer",
                          style: TextStyle(
                            height: 0,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {
              try {
                Map<String, dynamic> data = jsonDecode(result!.code!);
                log("===>>> code  scan $data");
                if (Provider.of<CustomViewModel>(context, listen: false).productDetail.nutritiondata == null) {
                  Provider.of<CustomViewModel>(context, listen: false)
                      .getDataFromQR(farmerID: data['Farmerid'], productID: data['productID']);
                }
                return Consumer<CustomViewModel>(builder: (context, state, build) {
                  return Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Farmer Details",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                CustomContainer(
                                  size: size,
                                  rad: 8,
                                  vertPad: 12,
                                  horPad: 12,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.65,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                text(
                                                  size: size,
                                                  text: "Grown by : ",
                                                ),
                                                text(
                                                  width: size.width * 0.4,
                                                  size: size,
                                                  maxLines: 2,
                                                  text:
                                                      "${state.farmerDetail.userFname} ${state.farmerDetail.userLname}",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                            text(size: size, text: state.farmerDetail.userHaddress ?? "", maxLines: 2),
                                            text(size: size, text: "${state.farmerDetail.userPincode}."),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                pop(context);
                                                              },
                                                              icon: const Icon(Icons.arrow_back, color: Colors.white)),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: CachedNetworkImage(
                                                            fit: BoxFit.contain,
                                                            width: size.width,
                                                            placeholder: (context, url) => ImageLoader(
                                                                height: size.width, width: size.width, radius: 8),
                                                            errorWidget: (context, url, error) =>
                                                                const Icon(Icons.image_not_supported_outlined),
                                                            imageUrl: "https://sabjiwaala.radarsofttech.in/farmerapi/"
                                                                "${state.farmerDetail.userPicture}"),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        child: image(
                                            "https://sabjiwaala.radarsofttech.in/farmerapi/"
                                            "${state.farmerDetail.userPicture}",
                                            size),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  "Product Details",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                CustomContainer(
                                  size: size,
                                  rad: 8,
                                  vertPad: 12,
                                  horPad: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.65,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                text(
                                                  size: size,
                                                  text: "${state.productDetail.productName}",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                text(
                                                    size: size,
                                                    text: state.productDetail.productDescription ?? "",
                                                    maxLines: 2),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    text(
                                                      size: size,
                                                      text: "Harvest Time: ",
                                                      color: Colors.black.withOpacity(0.7),
                                                    ),
                                                    text(
                                                        width: size.width * 0.4,
                                                        maxLines: 2,
                                                        size: size,
                                                        text: "${state.productDetail.productHarvestFrom}"
                                                            " to ${state.productDetail.productHarvestTo}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          image(
                                              "https://sabjiwaala.radarsofttech.in/farmerapi/"
                                              "${state.productDetail.productPic}",
                                              size)
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          text(
                                            size: size,
                                            text: "Category : ",
                                            color: Colors.black.withOpacity(0.7),
                                          ),
                                          text(
                                              width: size.width * 0.4,
                                              maxLines: 2,
                                              size: size,
                                              text: "${state.productDetail.productCatid}"),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          text(
                                            size: size,
                                            text: "Sub Category : ",
                                            color: Colors.black.withOpacity(0.7),
                                          ),
                                          text(
                                              width: size.width * 0.4,
                                              maxLines: 2,
                                              size: size,
                                              text: "${state.productDetail.productSubcatid}"),
                                        ],
                                      ),
                                      /*  const SizedBox(height: 8),

                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                pop(context);
                                                              },
                                                              icon: const Icon(Icons.arrow_back, color: Colors.white)),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: CachedNetworkImage(
                                                            fit: BoxFit.contain,
                                                            placeholder: (context, url) => ImageLoader(
                                                                height: size.width, width: size.width, radius: 8),
                                                            errorWidget: (context, url, error) =>
                                                                const Icon(Icons.image_not_supported_outlined),
                                                            imageUrl: "https://sabjiwaala.radarsofttech.in/farmerapi/"
                                                                "${state.productDetail.productNPic}"),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        child: image(
                                            "https://sabjiwaala.radarsofttech.in/farmerapi/"
                                            "${state.productDetail.productNPic}",
                                            size),
                                      )*/
                                    ],
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
                                      text(
                                        size: size,
                                        text: "Nutrition Details :",
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5, bottom: 8),
                                        color: Colors.black,
                                        width: double.infinity,
                                        height: 0.5,
                                      ),
                                      detailText(name: "Ingredients", weight: "Weight (g.)", size: size, isTitle: true),
                                      const SizedBox(height: 5),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: state.productDetail.nutritiondata!.length,
                                        itemBuilder: (context, index) {
                                          NutritionData data = state.productDetail.nutritiondata![index];
                                          return detailText(
                                              name: data.nutritionType ?? "",
                                              weight: data.nutritionName ?? "5",
                                              size: size);
                                        },
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                                        color: Colors.black,
                                        width: double.infinity,
                                        height: 0.5,
                                      ),
                                      detailText(name: "", weight: "( *In 100 gm )", size: size, isTitle: true),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Send Product Review to Farmer",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                CustomContainer(
                                  size: size,
                                  rad: 8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Give Star :",
                                        style: TextStyle(
                                          fontSize: size.width * 0.045,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          unratedColor: Colors.black26,
                                          glow: false,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: AppColors.primary,
                                          ),
                                          onRatingUpdate: (rating) {
                                            setState(() {
                                              ratings = rating;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      TextField(
                                        maxLines: 3,
                                        maxLength: 2000,
                                        controller: review,
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        cursorColor: Colors.black,
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                      const SizedBox(height: 20),
                                      CustomBtn(
                                        size: size,
                                        title: "Send",
                                        onTap: () async {
                                          if (ratings != 0.0) {
                                            await state
                                                .addReview(ReviewModel(
                                                    reviewCid: state.customerDetail.first.customerId ?? "",
                                                    reviewDesc: review.text,
                                                    reviewPid: state.productDetail.productId ?? "",
                                                    reviewRating: ratings.toString(),
                                                    reviewTag: "Farmer",
                                                    reviewVid: state.productDetail.productFarmerid ?? ''))
                                                .then((value) {
                                              if (value == "success") {
                                                pop(context);
                                                commonToast(context, "Thanks for your feedback!!",
                                                    color: AppColors.primary);
                                              } else {
                                                commonToast(context, "Enable to send your feedback",
                                                    color: AppColors.primary);
                                              }
                                            });
                                          } else {
                                            commonToast(context, "Please give at least one star",
                                                color: AppColors.primary);
                                          }
                                        },
                                        btnColor: ratings == 0.0 ? Colors.black38 : AppColors.primary,
                                        radius: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                });
              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Unable to detect Qr code, Please try again"),
                    backgroundColor: AppColors.red,
                  ));
                });
                return Expanded(flex: 4, child: _buildQrView(context));
              }
            }
          }),
        ],
      ),
    );
  }

  Widget detailText({
    required String name,
    required String weight,
    required Size size,
    bool isTitle = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
            width: size.width * 0.27,
            alignmentGeometry: Alignment.topLeft,
            text: name,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
        text(
            alignmentGeometry: Alignment.center,
            width: size.width * 0.25,
            text: weight,
            size: size,
            isTotal: isTotal,
            color: isTitle ? Colors.black.withOpacity(0.7) : Colors.black,
            vertPad: 2),
      ],
    );
  }

  Widget image(String img, Size size) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            height: size.width * 0.15,
            width: size.width * 0.15,
            placeholder: (context, url) => ImageLoader(height: size.width * 0.15, width: size.width * 0.15, radius: 8),
            errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
            imageUrl: img),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 180.0 : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      this.controller!.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
      openAppSettings();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
