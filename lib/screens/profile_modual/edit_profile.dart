import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_btn.dart';
import 'package:subjiwala/Widgets/name_textfields.dart';
import 'package:subjiwala/utils/app_config.dart';
import 'package:subjiwala/utils/helper.dart';
import '../../models/customer_detail_model.dart';
import '../../models/register_model.dart';
import '../../theme/colors.dart';

class EditProfile extends StatefulWidget {
  final List<CustomerDetailModel> data;

  const EditProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String gender = '';
  String? dob = '';
  XFile? image;
  String? networkImg;

  @override
  void initState() {
    // getData();
    setState(() {
      fName.text = widget.data[0].customerFirstname ?? '';
      lName.text = widget.data[0].customerLastname ?? '';
      email.text = widget.data[0].customerEmail ?? '';
      mobile.text = widget.data[0].customerPhoneno ?? '';
      gender = widget.data[0].customerGender ?? '';
      dob = widget.data[0].customerDob ?? '';
      networkImg = widget.data[0].customerPic ?? '';
    });
    super.initState();
  }

  Future<bool> selectImages() async {
    try {
      final XFile? selectedImages =
          await _picker.pickImage(source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080, imageQuality: 75);
      if (selectedImages != null) {
        image = selectedImages;
      }
      setState(() {});
      return true;
    } on PlatformException catch (e) {
      log("==>> pick image ${e.code}");
      return false;
    }
  }

  getData() async {
    String uid = Provider.of<CustomViewModel>(context, listen: false).uid ?? '';
    await Provider.of<CustomViewModel>(context, listen: false).getCustomerProfile(userId: uid);
  }

  @override
  Widget build(BuildContext context) {
    log('=== $networkImg');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          appBar(context: context, title: "Edit Profile", size: size),
          Container(
            width: size.width * 0.9,
            height: 2,
            color: Colors.black.withOpacity(0.1),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black.withOpacity(0.03)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.55,
                              child: NameTextField(
                                size: size,
                                controller: fName,
                                hintText: "Enter your first name",
                                name: "First name",
                              ),
                            ),
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
                              child: Container(
                                width: size.width * 0.2,
                                height: size.width * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black.withOpacity(0.3))),
                                child: image == null
                                    ? networkImg == "" || networkImg == "../img/profile/"
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add, size: 15, color: Colors.black.withOpacity(0.3)),
                                              Text(
                                                'Add image',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 8, color: Colors.black.withOpacity(0.3)),
                                              )
                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: AppConfig.apiUrl + networkImg!,
                                              errorWidget: (context, url, error) => Icon(
                                                Icons.image_not_supported_outlined,
                                                color: Colors.black.withOpacity(0.3),
                                              ),
                                            ),
                                          )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(image!.path),
                                          ),
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                        NameTextField(
                          size: size,
                          controller: lName,
                          hintText: "Enter your last name",
                          name: "Last name",
                        ),
                        NameTextField(
                          size: size,
                          controller: email,
                          keyBoardType: TextInputType.emailAddress,
                          hintText: "Enter your email address",
                          name: "Email",
                        ),
                        /*NameTextField(
                          size: size,
                          controller: mobile,
                          keyBoardType: TextInputType.phone,
                          hintText: "Enter your mobile number",
                          name: "Mobile number",
                        ),*/
                        Text(
                          "Gender",
                          style: TextStyle(
                            fontSize: size.width * 0.038,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            genderContainer(
                                name: "Male",
                                size: size,
                                onTap: () {
                                  setState(() {
                                    gender = gender != 'Male' ? "Male".toLowerCase() : '';
                                  });
                                }),
                            genderContainer(
                                name: "Female",
                                size: size,
                                onTap: () {
                                  setState(() {
                                    gender = gender != 'Female' ? "Female".toLowerCase() : '';
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Date of birth",
                          style: TextStyle(
                            fontSize: size.width * 0.038,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now())
                                .then((value) {
                              setState(() {
                                dob = value == null ? dob : "${value.day}/${value.month}/${value.year}";
                              });
                            });
                            // showDateRangePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2025));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 14),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(size.width * 0.03),
                                border: Border.all(color: Colors.black.withOpacity(0.3))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dob == '' ? 'Select your date of birth' : dob!,
                                  style: GoogleFonts.poppins(
                                    color: dob == '' ? Colors.black.withOpacity(0.3) : Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(right: 15, left: 15, bottom: MediaQuery.of(context).padding.bottom + 15),
                    child: CustomBtn(
                        size: size,
                        title: "Save",
                        onTap: () async {
                          log("networkImg $networkImg");
                          await Provider.of<CustomViewModel>(context, listen: false)
                              .updateProfile(
                                  model: RegisterRequiredModel(
                                    customerLastname: lName.text,
                                    customerFirstname: fName.text,
                                    customerEmail: email.text,
                                    customerDob: dob,
                                    customerGender: gender,
                                    customerPhoneno: mobile.text,
                                    customerPic: image == null ? networkImg : null,
                                  ),
                                  imagePath: image == null ? null : image!.path)
                              .then((value) {
                            pop(context);
                          });
                        },
                        btnColor: AppColors.primary,
                        radius: 5),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget genderContainer({required String name, required Size size, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            gender != name.toLowerCase()
                ? Container(
                    width: size.width * 0.04,
                    height: size.width * 0.04,
                    decoration: BoxDecoration(border: Border.all(color: AppColors.primary), shape: BoxShape.circle),
                  )
                : CircleAvatar(backgroundColor: AppColors.primary, radius: size.width * 0.02),
            const SizedBox(width: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
