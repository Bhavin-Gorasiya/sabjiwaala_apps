import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/helper/app_colors.dart';
import 'package:sub_franchisee/helper/navigations.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/screen/widgets/custom_textfields.dart';
import 'package:sub_franchisee/screen/widgets/custom_widgets.dart';
import 'package:sub_franchisee/screen/widgets/loading.dart';

import '../../../helper/app_config.dart';
import '../../../models/delivery_model.dart';
import '../../../models/profile_model.dart';
import '../../../models/state_city_model.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/search_textField.dart';

class DeliveryBoyDetail extends StatefulWidget {
  final bool isNew;
  final DeliveryModel? data;

  const DeliveryBoyDetail({Key? key, required this.isNew, this.data}) : super(key: key);

  @override
  State<DeliveryBoyDetail> createState() => _DeliveryBoyDetailState();
}

class _DeliveryBoyDetailState extends State<DeliveryBoyDetail> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController aboutUs = TextEditingController();
  TextEditingController panCard = TextEditingController();
  TextEditingController addharCard = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController accountNo = TextEditingController();

  XFile? imageFileList;
  String profilePicUrl = '';
  final ImagePicker imagePicker = ImagePicker();

  Future<bool> selectImages() async {
    try {
      final XFile? selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList = selectedImages;
      }
      setState(() {});
      return true;
    } on PlatformException catch (e) {
      log("==>> pick image ${e.code}");
      return false;
    }
  }

  @override
  void initState() {
    final providerListener = Provider.of<CustomViewModel>(context, listen: false);
    if (widget.data != null) {
      profilePicUrl = widget.data!.deliverypersonPic ?? "";
      fName.text = widget.data!.deliverypersonFname ?? "";
      lName.text = widget.data!.deliverypersonLname ?? "";
      email.text = widget.data!.deliverypersonEmail ?? "";
      mobile.text = widget.data!.deliverypersonMobileno1 ?? "";
      address.text = widget.data!.deliverypersonHaddress ?? "";
      if (widget.data!.deliverypersonStateid != '' && providerListener.stateList.isNotEmpty) {
        state.text = providerListener.stateList
                .singleWhere((element) => element.stateId == widget.data!.deliverypersonStateid!)
                .stateName ??
            "";
      }
      if (widget.data!.deliverypersonCityid != '' && providerListener.cityList.isNotEmpty) {
        city.text = providerListener.cityList
                .singleWhere((element) => element.locationId == widget.data!.deliverypersonCityid!)
                .locationCity ??
            "";
      }
      addharCard.text = widget.data!.deliverypersonAadharno ?? "";
      panCard.text = widget.data!.deliverypersonPanno ?? "";
      bankName.text = widget.data!.deliverypersonBankname ?? "";
      accountHolderName.text = widget.data!.deliverypersonAccounthname ?? "";
      accountNo.text = widget.data!.deliverypersonAccountno ?? "";
      ifsc.text = widget.data!.deliverypersonIfsCcode ?? "";
      providerListener.cityID = widget.data!.deliverypersonCityid ?? "";
    }
    // providerListener.changeCityId(data.userCityid ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: size.width * 0.05,
                left: size.width * 0.05,
                bottom: MediaQuery.of(context).padding.bottom + 5,
                top: 5),
            child: CustomBtn(
              size: size,
              title: widget.isNew ? "Add" : "Update",
              onTap: () async {
                DeliveryModel data = DeliveryModel(
                  deliverypersonId: widget.data == null ? "" : widget.data!.deliverypersonId ?? "",
                  deliverypersonSfid: providerListener.profileDetails!.userID!,
                  deliverypersonFname: fName.text,
                  deliverypersonPic: profilePicUrl,
                  deliverypersonLname: lName.text,
                  deliverypersonEmail: email.text,
                  deliverypersonHaddress: address.text,
                  deliverypersonMobileno1: mobile.text,
                  deliverypersonCityid: providerListener.cityID,
                  deliverypersonStateid: providerListener.stateID,
                  deliverypersonAadharno: addharCard.text,
                  deliverypersonPanno: panCard.text,
                  deliverypersonBankname: bankName.text,
                  deliverypersonAccounthname: accountHolderName.text,
                  deliverypersonAccountno: accountNo.text,
                  deliverypersonIfsCcode: ifsc.text,
                );
                if (widget.data != null) {
                  await providerListener.updateDeliveryBoy(model: data).then((value) => {
                        if (value == "success")
                          {pop(context)}
                        else
                          {snackBar(context, "Unable to update data, try again latter")}
                      });
                } else {
                  if (imageFileList != null &&
                      fName.text.isNotEmpty &&
                      email.text.isNotEmpty &&
                      mobile.text.isNotEmpty) {
                    await providerListener.addDeliveryBoy(model: data, img: imageFileList!.path).then((value) => {
                          if (value == "success")
                            {
                              pop(context),
                              snackBar(context, "Delivery Boy added successfully", color: AppColors.primary),
                            }
                          else
                            {snackBar(context, "Unable to add Delivery Boy, try again latter")}
                        });
                  } else {
                    snackBar(context, "Please add ' * ' fields and Image");
                  }
                }
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            alignment: FractionalOffset.centerRight,
            children: [
              CustomAppBar(size: size, title: widget.data != null ? "Details" : "Add new Delivery Boy"),
              if (widget.data != null)
                GestureDetector(
                  onTap: () async {
                    popup(
                        size: size,
                        context: context,
                        title: "Are you sure want to delete ${widget.data!.deliverypersonFname} Data",
                        isBack: true,
                        onYesTap: () async {
                          await providerListener.deleteDeliveryBoy(widget.data!.deliverypersonId!).then((value) {
                            if (value == "success") {
                              snackBar(context, "Removed successfully", color: AppColors.primary);
                              pop(context);
                            } else {
                              snackBar(context, "Unable to Delete Delivery boy");
                            }
                          });
                        });
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      right: size.width * 0.05,
                      left: size.width * 0.05,
                      bottom: 20,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                )
            ],
          ),
          Consumer<CustomViewModel>(builder: (context, states, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingText(size: size, texts: "Basic Details"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await selectImages().then((value) async {
                                    if (!value) {
                                      if (await Permission.photos.shouldShowRequestRationale) {
                                        await selectImages();
                                      } else {
                                        openAppSettings();
                                      }
                                    }
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    profilePicUrl != "" && imageFileList == null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              width: size.width * 0.2,
                                              height: size.width * 0.2,
                                              imageUrl: AppConfig.apiUrl + profilePicUrl,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => const Image(
                                                image: AssetImage("assets/user.png"),
                                              ),
                                            ),
                                          )
                                        : imageFileList == null
                                            ? CircleAvatar(
                                                radius: size.width * 0.1,
                                                backgroundColor: AppColors.primary.withOpacity(0.5),
                                                backgroundImage: const AssetImage("assets/user.png"),
                                              )
                                            : CircleAvatar(
                                                radius: size.width * 0.1,
                                                backgroundColor: AppColors.primary.withOpacity(0.5),
                                                backgroundImage: FileImage(File(imageFileList!.path)),
                                              ),
                                    CircleAvatar(
                                      backgroundColor: AppColors.primary,
                                      radius: size.width * 0.03,
                                      child: Icon(
                                        Icons.edit,
                                        size: size.width * 0.035,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          CustomTextFields(
                            hintText: "First Name*",
                            controller: fName,
                            validation: "First Name is required",
                          ),
                          CustomTextFields(
                            hintText: "Last Name",
                            controller: lName,
                            validation: "Last Name is required",
                          ),
                          CustomTextFields(
                            hintText: "Email Id*",
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            isEmail: true,
                            validation: "Email Id is required",
                          ),
                          CustomTextFields(
                            hintText: "Phone number*",
                            lendth: 10,
                            keyboardType: TextInputType.phone,
                            controller: mobile,
                            validation: "Phone number is required",
                          ),
                          CustomTextFields(hintText: "About Delivery boy", controller: aboutUs, maxLines: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: "Address Details"),
                          ),
                          CustomTextFields(hintText: "Address", controller: address, maxLines: 5),
                          Row(
                            children: [
                              Expanded(
                                // width: size.width * 0.4,
                                child: TextFieldSearch(
                                  label: 'State',
                                  controller: state,
                                  initialList: providerListener.stateNameList,
                                  getValue: (String value) async {
                                    StateModel state =
                                        providerListener.stateList.firstWhere((element) => element.stateName == value);
                                    await providerListener.getCity(state.stateId!);
                                    log("${state.stateId}");
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFieldSearch(
                                  isFalse: providerListener.cityList.isEmpty,
                                  label: providerListener.cityLoad ? "loading..." : "City",
                                  controller: city,
                                  initialList: providerListener.cityNameList,
                                  getValue: (String value) async {
                                    CityModel state = providerListener.cityList
                                        .firstWhere((element) => element.locationCity == value);
                                    log("${state.locationCity}");
                                    providerListener.changeCityId(state.locationId ?? "");
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: "Personal Details"),
                          ),
                          CustomTextFields(
                            hintText: "Addhar Card",
                            keyboardType: TextInputType.phone,
                            lendth: 12,
                            controller: addharCard,
                          ),
                          CustomTextFields(
                            hintText: "Pan Card",
                            lendth: 12,
                            controller: panCard,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: "Bank Details"),
                          ),
                          CustomTextFields(
                            hintText: "Bank Name",
                            lendth: 12,
                            controller: bankName,
                          ),
                          CustomTextFields(
                            hintText: "Account holder Name",
                            lendth: 12,
                            controller: accountHolderName,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  // width: size.width * 0.4,
                                  child: CustomTextFields(
                                controller: accountNo,
                                hintText: "Account number",
                              )),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CustomTextFields(
                                  hintText: "IFSC code",
                                  controller: ifsc,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                  if (states.isLoading) const Loading()
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
