import 'dart:developer';
import 'package:employee_app/helper/navigations.dart';
import 'package:employee_app/models/lead_model.dart';
import 'package:employee_app/models/user_model.dart';
import 'package:employee_app/screens/widgets/customBtn.dart';
import 'package:employee_app/screens/widgets/search_textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/app_colors.dart';
import '../../models/state_city_model.dart';
import '../../view model/CustomViewModel.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_search_drop.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/name_textfields.dart';

class AddLead extends StatefulWidget {
  final LeadModel? leadModel;
  final bool isEdit;
  final String text;
  final String? leadId;
  final String? leadUid;
  final String? leadType;

  const AddLead({Key? key, this.leadModel, this.isEdit = true, required this.text, this.leadId, this.leadUid, this.leadType}) : super(key: key);

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  bool isEdit = true;
  String radio = "";
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController district = TextEditingController();

  @override
  void initState() {
    final provider = Provider.of<CustomViewModel>(context, listen: false);
    isEdit = widget.isEdit;
    if (widget.leadModel != null) {
      radio = widget.leadModel!.leadStatus ?? "";
      fName.text = "${widget.leadModel!.leadFname}";
      lName.text = "${widget.leadModel!.leadLname}";
      email.text = widget.leadModel!.leadEmail ?? "";
      mobile.text = widget.leadModel!.leadMobileno ?? "";
      address.text = widget.leadModel!.leadHaddress ?? "";
      district.text = widget.leadModel!.leadArea ?? "";
      if (widget.leadModel!.leadStateid != '' && widget.leadModel!.leadStateid != "0") {
        state.text = provider.stateList.singleWhere((element) => element.stateId == widget.leadModel!.leadStateid).stateName ?? "";
      }
      if (widget.leadModel!.leadCityid != '' && widget.leadModel!.leadCityid != "0") {
        city.text = provider.cityList.singleWhere((element) => element.locationId == widget.leadModel!.leadCityid).locationCity ?? "";
      }
      provider.cityID = widget.leadModel!.leadCityid ?? "";
    } else {
      provider.cityNameList = [];
    }
    super.initState();
  }

  String selectedId = '0';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: "Add ${widget.text} Lead"),
          Expanded(
            child: Consumer<CustomViewModel>(builder: (context, states, child) {
              /* String user = widget.leadModel != null
                  ? states.userList
                          .where((element) => element.accessId == widget.leadModel!.leadType)
                          .first
                          .accessType ??
                      ""
                  : "";
              log(user);*/
              List<AssignUser> list = widget.text == "Franchise" ? states.mFUser : states.fUser;
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameTextField(readOnly: !isEdit, controller: fName, size: size, name: 'First name'),
                          NameTextField(readOnly: !isEdit, controller: lName, size: size, name: 'Last name'),
                          NameTextField(
                            readOnly: !isEdit,
                            controller: email,
                            size: size,
                            name: 'Email Id',
                            isEmail: true,
                            keyBoardType: TextInputType.emailAddress,
                          ),
                          NameTextField(
                            readOnly: !isEdit,
                            controller: mobile,
                            size: size,
                            name: 'Phone number',
                            maxNum: 10,
                            keyBoardType: TextInputType.phone,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: headingText(size: size, texts: "Status"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              radioBtn(name: "Hot", size: size),
                              radioBtn(name: "Worm", size: size),
                              radioBtn(name: "Cold", size: size),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              radioBtn(name: "Make Client", size: size),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (radio.toLowerCase() == "make client" && widget.text != "Farmer") NameTextField(readOnly: !isEdit, controller: pass, size: size, name: 'Password'),
                          if (radio.toLowerCase() == "make client" && widget.text != "Master Franchise" && widget.text != "Farmer")
                            if (list.isNotEmpty)
                              CustomSearchableDropDown(
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width * 0.04,
                                ),
                                items: list,
                                dropdownItemStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.04,
                                  height: 1.3,
                                ),
                                label: 'Select ${widget.text == "Franchise" ? "Master Franchise" : "Frachise"}',
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black54),
                                ),
                                dropDownMenuItems: list.map((item) {
                                  return "${item.userName}${'Area : ${item.area}'}";
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    selectedId = value.userId;
                                    log("selectedId $selectedId ${value.userId}");
                                  } else {
                                    selectedId = "";
                                  }
                                },
                              )
                            else
                              Text(
                                "* Please first add ate least one "
                                "${widget.text == "Franchise" ? "Master Franchise" : "Frachise"}, without"
                                " it you can't make ${widget.text} as a client.",
                                style: TextStyle(color: AppColors.red),
                              ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: headingText(size: size, texts: "Address Details"),
                          ),
                          NameTextField(readOnly: !isEdit, controller: address, size: size, name: 'Address'),
                          NameTextField(
                            readOnly: !isEdit,
                            controller: district,
                            size: size,
                            name: 'Availability area',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldSearch(
                                  controller: state,
                                  title: "State",
                                  isRound: true,
                                  initialList: states.stateNameList,
                                  getValue: (String value) async {
                                    StateModel state = states.stateList.firstWhere((element) => element.stateName == value);
                                    await states.getCity(state.stateId!);
                                    log("${state.stateId}");
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFieldSearch(
                                  isFalse: states.cityList.isEmpty,
                                  controller: city,
                                  title: "City",
                                  isRound: true,
                                  initialList: states.cityNameList,
                                  getValue: (String value) async {
                                    CityModel state = states.cityList.firstWhere((element) => element.locationCity == value);
                                    log("${state.locationCity}");
                                    states.changeCityId(state.locationId ?? "");
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                  if (states.isLoading)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black26,
                        ),
                        padding: const EdgeInsets.all(15),
                        child: const CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                ],
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05, left: size.width * 0.05, bottom: MediaQuery.of(context).padding.bottom + 10, top: 10),
            child: CustomBtn(
              size: size,
              title: isEdit
                  ? widget.leadModel != null
                      ? "Update"
                      : "Add"
                  : "Edit",
              onTap: () async {
                final provider = Provider.of<CustomViewModel>(context, listen: false);
                if (isEdit) {
                  if (widget.leadModel != null) {
                    if (radio.toLowerCase() == "make client") {
                      if (pass.text.isNotEmpty && selectedId != '') {
                        log("==>>> ${provider.stateID} ${radio.toLowerCase() == "make client" || pass.text.isNotEmpty}");
                        await provider
                            .makeClient(
                                empId: provider.profileDetails!.userID ?? "", leadId: widget.leadModel!.leadId ?? "", pass: pass.text, leadType: widget.leadModel!.leadType ?? "", assignId: selectedId)
                            .then((value) async {
                          if (value == "success") {
                            await provider
                                .editLead(
                                    model: LeadModel(
                                        leadArea: district.text,
                                        leadCityid: provider.cityID,
                                        leadStateid: provider.stateID,
                                        leadEmail: email.text,
                                        leadFname: fName.text,
                                        leadLname: lName.text,
                                        leadStatus: radio,
                                        leadHaddress: address.text,
                                        leadMobileno: mobile.text,
                                        leadId: widget.leadModel!.leadId,
                                        leadType: widget.leadModel!.leadType,
                                        leadUid: widget.leadModel!.leadUid))
                                .then((value) {
                              pop(context);
                            });
                          } else {
                            snackBar(context, "Unable to edit your Lead");
                          }
                        });
                      } else {
                        if (selectedId != '') {
                          snackBar(context, "Please enter password");
                        } else {
                          snackBar(context, "Please select ${widget.text == "Franchise" ? "Master Franchise" : "Franchise"}");
                        }
                      }
                    } else {
                      provider
                          .editLead(
                              model: LeadModel(
                                  leadArea: district.text,
                                  leadCityid: provider.cityID,
                                  leadStateid: provider.stateID,
                                  leadEmail: email.text,
                                  leadFname: fName.text,
                                  leadLname: lName.text,
                                  leadStatus: radio,
                                  leadHaddress: address.text,
                                  leadMobileno: mobile.text,
                                  leadId: widget.leadModel!.leadId,
                                  leadType: widget.leadModel!.leadType,
                                  leadUid: widget.leadModel!.leadUid))
                          .then((value) {
                        if (value == "success") {
                          pop(context);
                        } else {
                          snackBar(context, "Unable to edit your Lead");
                        }
                      });
                    }
                  } else {
                    if (fName.text.isNotEmpty ||
                        email.text.isNotEmpty ||
                        mobile.text.isNotEmpty ||
                        district.text.isNotEmpty ||
                        address.text.isNotEmpty ||
                        state.text.isNotEmpty ||
                        city.text.isNotEmpty) {
                      provider
                          .addLead(
                              model: LeadModel(
                                  leadArea: district.text,
                                  leadCityid: provider.cityID,
                                  leadStateid: provider.stateID,
                                  leadEmail: email.text,
                                  leadFname: fName.text,
                                  leadLname: lName.text,
                                  leadStatus: radio,
                                  leadHaddress: address.text,
                                  leadMobileno: mobile.text,
                                  leadType: widget.leadType,
                                  leadUid: widget.leadUid))
                          .then((value) {
                        if (value == "success") {
                          log("== >> ${widget.leadType ?? "no"}");
                          pop(context);
                        } else {
                          snackBar(context, "Unable to add new Lead");
                        }
                      });
                    } else {
                      snackBar(context, "Please fill all filed");
                    }
                  }
                } else {
                  setState(() {
                    isEdit = !isEdit;
                  });
                }
              },
              btnColor: AppColors.primary,
              radius: 10,
            ),
          )
        ],
      ),
    );
  }

  Widget radioBtn({required String name, required Size size}) {
    return GestureDetector(
      onTap: () {
        if (isEdit) {
          setState(() {
            radio = name;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: size.width * 0.045,
              height: size.width * 0.045,
              decoration: BoxDecoration(
                color: radio.toLowerCase() == name.toLowerCase() ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary),
              ),
            ),
            Text(
              name,
              style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
