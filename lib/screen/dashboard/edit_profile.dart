import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sub_franchisee/screen/widgets/loading.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_config.dart';
import '../../helper/navigations.dart';
import '../../models/profile_model.dart';
import '../../models/state_city_model.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_textfields.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/search_textField.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController altMobile = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pinCode = TextEditingController();
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
      final XFile? selectedImages =
      await imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080, imageQuality: 75);
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
    ProfileModel data = providerListener.profileDetails ?? ProfileModel();
    profilePicUrl = data.userPicture ?? "";
    fName.text = data.userFname ?? "";
    lName.text = data.userLname ?? "";
    email.text = data.userEmail ?? "";
    mobile.text = data.userMobileno1 ?? "";
    altMobile.text = data.userMobileno2 ?? "";
    address.text = data.userHaddress ?? "";
    pinCode.text = data.userPincode ?? "";
    district.text = data.userDistrict ?? "";
    if (data.userStateid != null && data.userStateid != '' && providerListener.stateList.isNotEmpty) {
      state.text =
          providerListener.stateList.singleWhere((element) => element.stateId == data.userStateid!).stateName ?? "";
    }
    if (data.userCityid != null && data.userCityid != '' && providerListener.cityList.isNotEmpty) {
      city.text =
          providerListener.cityList.singleWhere((element) => element.locationId == data.userCityid!).locationCity ?? "";
    }
    addharCard.text = data.userAadharno ?? "";
    panCard.text = data.userPanno ?? "";
    bankName.text = data.userBankname ?? "";
    accountHolderName.text = data.userAccounthname ?? "";
    accountNo.text = data.userAccountno ?? "";
    ifsc.text = data.userIFSCcode ?? "";
    providerListener.cityID = data.userCityid ?? "";
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
              title: "Save",
              onTap: () async {
                ProfileModel data = ProfileModel(
                  userID: providerListener.profileDetails!.userID!,
                  userFname: fName.text,
                  userPicture: profilePicUrl,
                  userLname: lName.text,
                  userEmail: email.text,
                  userHaddress: address.text,
                  userMobileno1: mobile.text,
                  userMobileno2: altMobile.text,
                  userDistrict: district.text,
                  userPincode: pinCode.text,
                  userCityid: providerListener.cityID,
                  userStateid: providerListener.stateID,
                  userAadharno: addharCard.text,
                  userPanno: panCard.text,
                  userBankname: bankName.text,
                  userAccounthname: accountHolderName.text,
                  userAccountno: accountNo.text,
                  userIFSCcode: ifsc.text,
                );
                if (imageFileList != null) {
                  await providerListener.updateProfilePic(
                      imageFileList!.path, providerListener.profileDetails!.userID!);
                }
                await providerListener.updateProfile(data).then((value) => {
                      if (value == "success")
                        {pop(context)}
                      else
                        {snackBar(context, "Unable to update your profile, try again latter")}
                    });
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Edit Profile"),
          Consumer<CustomViewModel>(builder: (context, states, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
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
                                    Container(
                                      height: size.width * 0.2,
                                      width: size.width * 0.2,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withOpacity(0.5),
                                        image: imageFileList == null
                                            ? const DecorationImage(image: AssetImage("assets/user_avatar.png"))
                                            : DecorationImage(
                                                image: FileImage(File(imageFileList!.path)),
                                              ),
                                      ),
                                      child: profilePicUrl != "" && imageFileList == null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl: AppConfig.apiUrl + profilePicUrl,
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) =>
                                                    const Image(image: AssetImage("assets/user_avatar.png")),
                                              ),
                                            )
                                          : const SizedBox(),
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
                            hintText: "First Name",
                            controller: fName,
                            validation: "First Name is required",
                          ),
                          CustomTextFields(
                            hintText: "Last Name",
                            controller: lName,
                            validation: "Last Name is required",
                          ),
                          CustomTextFields(
                            hintText: "Email Id",
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            isEmail: true,
                            validation: "Email Id is required",
                          ),
                          CustomTextFields(
                            hintText: "Phone number",
                            lendth: 10,
                            keyboardType: TextInputType.phone,
                            controller: mobile,
                            validation: "Phone number is required",
                          ),
                          CustomTextFields(
                            hintText: "Alternative Phone number",
                            lendth: 10,
                            keyboardType: TextInputType.phone,
                            controller: altMobile,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: "Address Details"),
                          ),
                          CustomTextFields(hintText: "Address", controller: address, maxLines: 5),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFields(hintText: "District", controller: district),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CustomTextFields(
                                    hintText: "Pin Code", controller: pinCode, keyboardType: TextInputType.phone),
                              ),
                            ],
                          ),
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
