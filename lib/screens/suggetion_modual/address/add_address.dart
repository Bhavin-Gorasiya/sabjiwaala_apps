import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_webservice_ex/places.dart';
import 'package:location/location.dart' as locTemp;
import 'package:provider/provider.dart';

import '../../../Widgets/CustomBtn.dart';
import '../../../theme/colors.dart';
import '../../../utils/helper.dart';

class EditAddress extends StatefulWidget {
  final String addressID, address, landmark, tag;
  final bool isUpdate;
  final int? index;

  const EditAddress({
    super.key,
    required this.addressID,
    required this.address,
    required this.landmark,
    required this.tag,
    this.isUpdate = false,
    this.index,
  });

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final tagController = TextEditingController();
  final landmark = TextEditingController();

  var latitude, longitude;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final Mode _mode = Mode.fullscreen;

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
                addressController.text = result.formattedAddress.toString();
                latitude = result.geometry!.location.lat.toString();
                longitude = result.geometry!.location.lng.toString();
              });
              pop(context);
            },
          );
        },
      ),
    );
  }

  Future<void> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: API_KEY,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result!.geometry!.location.lat;
      final lng = detail.result!.geometry!.location.lng;

      // commonToast(context, "${p.description} - $lat/$lng");

      if ((lat).toString() != "") {
        setState(() {
          addressController.text = detail.result!.formattedAddress.toString();
          latitude = detail.result!.geometry!.location.lat.toString();
          longitude = detail.result!.geometry!.location.lng.toString();
        });
      } else {
        commonToast(context, "Please try again!");
      }
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
        style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      addressController.text = widget.address;
      landmark.text = widget.landmark;
      tagController.text = widget.tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, right: 15, left: 10, bottom: 4),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  const SizedBox(width: 5),
                  Text(
                    "Add address",
                    style: GoogleFonts.poppins(fontSize: size.width * 0.045),
                  )
                ],
              ),
            ),
            Container(
              width: size.width * 0.9,
              height: 2,
              color: Colors.black.withOpacity(0.1),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        TextInput(
                          title: "House / Office Location",
                          readOnly: true,
                          controller: addressController,
                          icon: const Icon(Icons.location_searching),
                          hintText: "e.g., Pul Pehladpur, Badarpur, New Delhi 110044",
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
                        ),
                        TextInput(
                          title: "Pin code",
                          textInputType: TextInputType.phone,
                          controller: landmark,
                          icon: const Icon(Icons.location_city),
                          hintText: "e.g., 123456",
                        ),
                        TextInput(
                          title: "Save As",
                          controller: tagController,
                          icon: const Icon(Icons.discount),
                          hintText: "e.g., Home / Office / Delhi Home",
                        ),
                        const SizedBox(height: 20),
                        CustomBtn(
                          size: size,
                          title: "Save",
                          btnColor: AppColors.primary,
                          radius: 10,
                          onTap: () async {},
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.readOnly = false,
    this.onTap,
    required this.title,
    this.textInputType,
  }) : super(key: key);
  final String hintText;
  final Widget icon;
  final bool readOnly;
  final String title;
  final TextInputType? textInputType;
  final Function()? onTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: size.width * 0.036),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 0),
            padding: const EdgeInsets.only(right: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.03),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: TextFormField(
              onTap: onTap,
              readOnly: readOnly,
              controller: controller,
              keyboardType: textInputType ?? TextInputType.name,
              decoration: InputDecoration(
                prefixIcon: icon,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
