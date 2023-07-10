import 'dart:developer';
import 'dart:io';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice_ex/places.dart';
import 'package:location/location.dart' as locTemp;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/ProfileDetailsParser.dart';
import 'package:subjiwala_farmer/Models/edit_profile_model.dart';
import 'package:subjiwala_farmer/Widgets/loading.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import '../../../Models/state_city_model.dart';
import '../../../View Models/CustomViewModel.dart';
import '../../../Widgets/CustomBtn.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_textfields.dart';
import '../../../Widgets/custom_widgets.dart';
import '../../../Widgets/search_textField.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_config.dart';
import '../../../utils/helper.dart';
import '../../auth/signup_screen.dart';

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
  TextEditingController farmAddress = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController panCard = TextEditingController();
  TextEditingController addharCard = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController farmArea = TextEditingController();
  TextEditingController products = TextEditingController();

  XFile? imageFileList;
  String profilePicUrl = '';
  final ImagePicker imagePicker = ImagePicker();

  Future<bool> selectImages() async {
    try {
      final XFile? selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        setState(() {
          imageFileList = selectedImages;
        });
      }
      return true;
    } on PlatformException catch (e) {
      log("==>> pick image ${e.code}");
      return false;
    }
  }

  @override
  void initState() {
    final providerListener = Provider.of<CustomViewModel>(context, listen: false);
    ProfileDetailsParser data = providerListener.profileDetails ?? ProfileDetailsParser();
    profilePicUrl = data.userPicture ?? "";
    fName.text = data.userFname ?? "";
    lName.text = data.userLname ?? "";
    email.text = data.userEmail ?? "";
    mobile.text = data.userMobileno1 ?? "";
    altMobile.text = data.userMobileno2 ?? "";
    address.text = data.userHaddress ?? "";
    pinCode.text = data.userPincode ?? "";
    district.text = data.userDistrict ?? "";
    if (data.userStateid != '') {
      state.text =
          providerListener.stateList.singleWhere((element) => element.stateId == data.userStateid!).stateName ?? "";
    }
    if (data.userCityid != '') {
      city.text =
          providerListener.cityList.singleWhere((element) => element.locationId == data.userCityid!).locationCity ?? "";
    }
    addharCard.text = data.userAadharno ?? "";
    panCard.text = data.userPanno ?? "";
    bankName.text = data.userBankname ?? "";
    accountHolderName.text = data.userAccounthname ?? "";
    accountNo.text = data.userAccountno ?? "";
    ifsc.text = data.userIFSCcode ?? "";
    products.text = data.userCrops ?? "";
    farmArea.text = data.userLand ?? "";
    farmAddress.text = data.userOfficearea ?? "";
    super.initState();
  }

  late bool _serviceEnabled;
  late locTemp.PermissionStatus _permissionGranted;

  locTemp.Location location = locTemp.Location();

  LatLng? latLng;

  void pickerScreen() {
    latLng = const LatLng(
      20.215526,
      20.612645,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: API_KEY,
            initialPosition: const LatLng(20.215526, 20.612645),
            useCurrentLocation: true,
            /*
            enableMyLocationButton: true,
            selectInitialPosition: true,*/
            onPlacePicked: (result) {
              setState(() {
                farmAddress.text = result.formattedAddress.toString();
                // latitude = result.geometry!.location.lat.toString();
                // longitude = result.geometry!.location.lng.toString();
                // log("lat long lat ==$latitude ==== long= $longitude}");
              });
              pop(context);
            },
          );
        },
      ),
    );
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: API_KEY,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result!.geometry!.location.lat;

    // commonToast(context, "${p.description} - $lat/$lng");

    if ((lat).toString() != "") {
      setState(() {
        farmAddress.text = detail.result!.formattedAddress.toString();
        // latitude = detail.result!.geometry!.location.lat.toString();
        // longitude = detail.result!.geometry!.location.lng.toString();
      });
    } else {
      commonToast(context, "Please try again!");
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    commonToast(context, response.errorMessage ?? "");
  }

  // Future<void> _handlePressButton() async {
  //   Prediction? p = await PlacesAutocomplete.show(
  //     context: context,
  //     apiKey: API_KEY,
  //     mode: _mode,
  //     language: "en",
  //   );

  // displayPrediction(p!);
  // }

  showAlertDialogManually(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text(
        'Yes',
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        // _handlePressButton();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text(
        'No',
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog ask = AlertDialog(
      title: Text(
        'Manually Select Address',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: const Text('You can also search address without permission'),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ask;
      },
    );
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
                right: sizes(size.width * 0.05, 25, size),
                left: sizes(size.width * 0.05, 25, size),
                bottom: MediaQuery.of(context).padding.bottom + 5,
                top: 5),
            child: CustomBtn(
              size: size,
              title: AppText.save[providerListener.language],
              onTap: () async {
                EditProfileModel data = EditProfileModel(
                  userId: providerListener.profileDetails!.userID!,
                  userFname: fName.text,
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
                  userIfsCcode: ifsc.text,
                  userCrops: products.text,
                  userLand: farmArea.text,
                  userOfficearea: farmAddress.text,
                );
                if (imageFileList != null) {
                  await providerListener.updateProfilePic(
                      imageFileList!.path, providerListener.profileDetails!.userID!);
                }
                await providerListener.updateProfile(data).then((value) => {
                      if (value == "success")
                        {
                          pop(context),
                          snackBar(context, AppText.profileUpdatedS[providerListener.language],
                              color: AppColors.primary)
                        }
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
          CustomAppBar(size: size, title: AppText.editProfile[providerListener.language]),
          Consumer<CustomViewModel>(builder: (context, states, child) {
            return Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingText(size: size, texts: AppText.basicDetails[states.language]),
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
                                        image: imageFileList == null
                                            ? null
                                            : DecorationImage(
                                                image: FileImage(File(imageFileList!.path)),
                                              ),
                                      ),
                                      child: profilePicUrl != "" && imageFileList == null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl: AppConfig.apiUrl + profilePicUrl,
                                                errorWidget: (context, url, error) =>
                                                    const Image(image: AssetImage("assets/user_avatar.png")),
                                                placeholder: (context, url) =>
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
                            hintText: AppText.firstName[states.language],
                            controller: fName,
                            validation: AppText.firstNameIsRequired[states.language],
                          ),
                          CustomTextFields(
                            hintText: AppText.lastName[states.language],
                            controller: lName,
                            validation: AppText.lastNameIsRequired[states.language],
                          ),
                          CustomTextFields(
                            hintText: AppText.emailId[states.language],
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            isEmail: true,
                            validation: AppText.emailIdIsRequired[states.language],
                          ),
                          CustomTextFields(
                            hintText: AppText.phoneNumber[states.language],
                            lendth: 10,
                            keyboardType: TextInputType.phone,
                            controller: mobile,
                            validation: AppText.phoneNumberIsRequired[states.language],
                          ),
                          CustomTextFields(
                            hintText: AppText.alternativePhoneNumber[states.language],
                            lendth: 10,
                            keyboardType: TextInputType.phone,
                            controller: altMobile,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: AppText.addressDetails[states.language]),
                          ),
                          CustomTextFields(
                              onTap: () async {
                                _serviceEnabled = await location.serviceEnabled();
                                if (!_serviceEnabled) {
                                  _serviceEnabled = await location.requestService();
                                  if (!_serviceEnabled) {
                                    showAlertDialogManually(context);
                                  } else {}
                                }
                                _permissionGranted = await location.hasPermission();
                                if (_permissionGranted == locTemp.PermissionStatus.denied) {
                                  _permissionGranted = await location.requestPermission();
                                  if (_permissionGranted == locTemp.PermissionStatus.granted) {
                                    pickerScreen();
                                  } else {
                                    showAlertDialogManually(context);
                                  }
                                } else if (_permissionGranted == locTemp.PermissionStatus.granted) {
                                  pickerScreen();
                                }
                              },
                              hintText: AppText.farmAddress[states.language],
                              controller: farmAddress,
                              maxLines: 1,
                              readOnly: true),
                          CustomTextFields(
                            hintText: AppText.farmSize[states.language],
                            controller: farmArea,
                          ),
                          CustomTextFields(
                            hintText: AppText.products[states.language],
                            controller: products,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: AppText.addressDetails[states.language]),
                          ),
                          CustomTextFields(
                              hintText: AppText.address[states.language], controller: address, maxLines: 5),
                          Row(
                            children: [
                              Expanded(
                                child:
                                    CustomTextFields(hintText: AppText.district[states.language], controller: district),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CustomTextFields(
                                    hintText: AppText.pinCode[states.language],
                                    controller: pinCode,
                                    keyboardType: TextInputType.phone),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                // width: size.width * 0.4,
                                child: TextFieldSearch(
                                  label: AppText.state[states.language],
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
                                  isFalse: providerListener.cityNameList.isEmpty,
                                  label: providerListener.cityLoad
                                      ? AppText.loading[states.language]
                                      : AppText.city[states.language],
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
                            child: headingText(size: size, texts: AppText.personalDetails[states.language]),
                          ),
                          CustomTextFields(
                            hintText: AppText.addharCard[states.language],
                            keyboardType: TextInputType.phone,
                            lendth: 12,
                            controller: addharCard,
                          ),
                          CustomTextFields(
                            hintText: AppText.panCard[states.language],
                            lendth: 12,
                            controller: panCard,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: headingText(size: size, texts: AppText.bankDetails[states.language]),
                          ),
                          CustomTextFields(
                            hintText: AppText.bankName[states.language],
                            lendth: 12,
                            controller: bankName,
                          ),
                          CustomTextFields(
                            hintText: AppText.accountHolderName[states.language],
                            lendth: 12,
                            controller: accountHolderName,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  // width: size.width * 0.4,
                                  child: CustomTextFields(
                                controller: accountNo,
                                hintText: AppText.accountNumber[states.language],
                              )),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CustomTextFields(
                                  hintText: AppText.iFSCCode[states.language],
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
