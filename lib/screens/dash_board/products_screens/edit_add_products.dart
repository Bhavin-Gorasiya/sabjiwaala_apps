import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Models/ProductListParser.dart';
import 'package:subjiwala_farmer/Widgets/CustomBtn.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/Widgets/loading.dart';
import 'package:subjiwala_farmer/Widgets/shimmer_loader/image_loader.dart';
import 'package:subjiwala_farmer/screens/auth/signup_screen.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import '../../../View Models/CustomViewModel.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_config.dart';
import '../../../utils/helper.dart';

class AddEditProductScreen extends StatefulWidget {
  final bool isNew;
  final ProductListParser? product;
  final int? index;

  const AddEditProductScreen({super.key, this.isNew = false, this.product, this.index});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  String? start;
  String? end;

  List<TextEditingController> nutritionList = [];
  TextEditingController nutrition = TextEditingController();
  List<TextEditingController> calorieList = [];
  TextEditingController calorie = TextEditingController();
  int listIndex = 1;

  // List<TextEditingController> calorieList = [];

  TextEditingController name = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  XFile? productImg;
  String productImgUrl = '';
  XFile? nutritionImg;
  String nutritionImgUrl = '';
  final ImagePicker imagePicker = ImagePicker();

  Future<bool> selectProductImages() async {
    try {
      final XFile? selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        productImg = selectedImages;
      }
      setState(() {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> selectNutrImages() async {
    try {
      final XFile? selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        nutritionImg = selectedImages;
      }
      setState(() {});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isEdit = false;

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      nutritionList.add(TextEditingController());
      calorieList.add(TextEditingController());
    }

    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    if (widget.product != null) {
      listIndex = widget.product!.nutritiondata!.length;
      log("===>>> listIndex= $listIndex");
      for (Nutritiondatum data in widget.product!.nutritiondata!) {
        nutritionList[widget.product!.nutritiondata!.indexOf(data)].text = data.nutritionType ?? "";
        calorieList[widget.product!.nutritiondata!.indexOf(data)].text = data.nutritionName ?? "";
      }

      productImgUrl = widget.product!.productPic ?? "";
      selectedValue = state.categoryList[0].categoryName ?? "";
      name.text = widget.product!.productName ?? "";
      priceController.text = widget.product!.productPrice.toString();
      descController.text = widget.product!.productDescription ?? "";
      qtyController.text = widget.product!.productQty.toString();
      start = widget.product!.productHarvestFrom;
      end = widget.product!.productHarvestTo;
      subCatID = widget.product!.productSubcatid;
      subCategory = state.subCategoryList.where((element) => element.subcategoryId == subCatID).first.subcategoryName;
      catID = widget.product!.productCatid;
      selectedValue =
          state.categoryList.where((element) => element.categoryId == widget.product!.productCatid).first.categoryName;
      // state.filterSubCatList(catID ?? "0");
      // catID = widget.product!.productCatid!;
    } else {
      state.clearSubCategory();
    }
    super.initState();
  }

  String? selectedValue;
  String? subCategory;
  String? catID;
  String? subCatID;

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    // state.changeLoading();
    return WillPopScope(
      onWillPop: () {
        subCatID = null;
        selectedValue = null;
        subCategory = null;
        catID = null;
        state.filterSubCatList(state.categoryId ?? "1");
        return Future(() => false);
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            top: 10,
            right: sizes(size.width * 0.05, 25, size),
            left: sizes(size.width * 0.05, 25, size),
          ),
          height: 60,
          child: CustomBtn(
              title: widget.isNew ? AppText.add[state.language] : AppText.save[state.language],
              size: size,
              onTap: () async {
                List<Map<String, dynamic>> nutritionData = [];
                for (int i = 0; i < 10; i++) {
                  if (nutritionList[i].text.isNotEmpty && calorieList[i].text.isNotEmpty) {
                    nutritionData.add({"nutritionType": nutritionList[i].text, "nutritionName": calorieList[i].text});
                  }
                }

                log("==>> nutritionData ${nutritionData.toString()}");

                if (nutritionData.length != (listIndex)) {
                  snackBar(context, AppText.pleaseAddProper[state.language]);
                }

                if (!state.isLoading) {
                  if (widget.product != null) {
                    if (name.text.isNotEmpty &&
                        start != null &&
                        end != null &&
                        priceController.text.isNotEmpty &&
                        qtyController.text.isNotEmpty &&
                        (productImg != null || productImgUrl != '') &&
                        nutritionData.isNotEmpty) {
                      await state
                          .updateProduct(
                            model: EditProductModel(
                                productCatid: catID.toString(),
                                productSubcatid: subCatID.toString(),
                                productFarmerid: state.profileDetails!.userID,
                                productDescription: descController.text,
                                productHarvestFrom: start,
                                productHarvestTo: end,
                                productID: widget.product!.productId.toString(),
                                productName: name.text,
                                productPrice: priceController.text,
                                productQty: qtyController.text,
                                productTotalamt:
                                    (int.parse(priceController.text) * int.parse(qtyController.text)).toString(),
                                productPic: productImg != null ? productImg!.path : null,
                                nutritiondata: nutritionData),
                          )
                          .then((value) => {
                                if (value == "success")
                                  {
                                    snackBar(context, AppText.productUpdateSu[state.language],
                                        color: AppColors.primary),
                                    state.filterProduct(
                                        catId: state.categoryId ?? "1", subCatId: state.subCategoryId ?? "1"),
                                    pop(context),
                                  }
                              });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(AppText.pleaseAddAll[state.language]),
                        backgroundColor: AppColors.red,
                      ));
                    }
                  } else {
                    log("==>>> subCat$subCatID ==catId$catID ==${state.profileDetails!.userID}");
                    if (name.text.isNotEmpty &&
                        start != null &&
                        end != null &&
                        priceController.text.isNotEmpty &&
                        qtyController.text.isNotEmpty &&
                        subCatID != null &&
                        (productImg != null || productImgUrl != '') &&
                        nutritionData.isNotEmpty) {
                      await state
                          .addProduct(
                            model: AddProductModel(
                                productSubcatid: subCatID,
                                productCatid: catID,
                                productFarmerid: state.profileDetails!.userID,
                                productDescription: descController.text,
                                productHarvestFrom: start,
                                productHarvestTo: end,
                                productName: name.text,
                                productPrice: priceController.text,
                                productQty: qtyController.text,
                                productTotalamt:
                                    (int.parse(priceController.text) * int.parse(qtyController.text)).toString(),
                                productPic: productImg == null ? null : productImg!.path,
                                nutritiondata: nutritionData),
                          )
                          .then((value) => {
                                if (value == "success")
                                  {
                                    snackBar(context, AppText.productAddSu[state.language], color: AppColors.primary),
                                    state.filterProduct(
                                        catId: state.categoryId ?? "1", subCatId: state.subCategoryId ?? "1"),
                                    // pop(context),
                                    showDialog(
                                      // barrierDismissible: false,
                                      context: context,
                                      builder: (context) => Center(
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(size.width * 0.07),
                                              width: size.width * 0.8,
                                              height: size.width * 0.8,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    AppConfig.apiUrl + (state.productList.last.productQrcode ?? ""),
                                                placeholder: (context, url) => ImageLoader(
                                                    width: size.width * 0.8, height: size.width * 0.8, radius: 0),
                                                errorWidget: (context, url, error) => Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * 0.8,
                                                  height: size.width * 0.8,
                                                  color: Colors.white,
                                                  child: Text(
                                                    AppText.failToLoadQr[state.language],
                                                    style: TextStyle(
                                                      fontSize: sizes(size.width * 0.05, 24, size),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: size.width * 0.06,
                                              backgroundColor: Colors.red,
                                              child: IconButton(
                                                onPressed: () {
                                                  pop(context);
                                                  // pop(context);
                                                },
                                                icon: const Icon(Icons.close, color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  }
                              });
                    } else {
                      log("===>> nutrition data ${nutritionData.length} =${name.text}= ==$start= ==$end= "
                          "==${priceController.text}= ==${qtyController.text}= ==$subCatID= ==");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(AppText.pleaseAddAll[state.language]),
                        backgroundColor: AppColors.red,
                      ));
                    }
                  }
                }
              },
              btnColor: AppColors.primary),
        ),
        backgroundColor: AppColors.bgColor,
        body: Column(
          children: [
            CustomAppBar(
                size: size,
                title: widget.isNew ? AppText.addProduct[state.language] : AppText.editProduct[state.language],
                onTap: () {
                  subCatID = null;
                  selectedValue = null;
                  subCategory = null;
                  catID = null;
                  state.filterSubCatList(state.categoryId ?? "1");
                }),
            Consumer<CustomViewModel>(builder: (context, state, child) {
              return Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppText.addImage[state.language],
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (productImg != null || productImgUrl != "")
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                            color: AppColors.bgColorCardDarkGrey,
                                            image: productImgUrl != ""
                                                ? DecorationImage(image: NetworkImage(AppConfig.apiUrl + productImgUrl))
                                                : DecorationImage(
                                                    image: FileImage(File(productImg!.path)),
                                                  ),
                                          ),
                                          height: size.width * 0.15,
                                          width: size.width * 0.15,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productImg = null;
                                            productImgUrl = '';
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          radius: size.width * 0.025,
                                          child: Icon(
                                            Icons.close,
                                            size: size.width * 0.04,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                else
                                  GestureDetector(
                                    onTap: () async {
                                      await selectProductImages().then((value) async {
                                        log("==>> image $value");
                                        if (!value) {
                                          if (await Permission.photos.shouldShowRequestRationale) {
                                            await selectProductImages();
                                          } else {
                                            openAppSettings();
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                            color: AppColors.bgColorCardDarkGrey,
                                          ),
                                          height: size.width * 0.15,
                                          width: size.width * 0.15,
                                          child: const Icon(Icons.cloud_upload_rounded)),
                                    ),
                                  ),
                              ],
                            ),
                            /*const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Add Nutrition's Image",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (nutritionImg != null || nutritionImgUrl != '')
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                            color: AppColors.bgColorCardDarkGrey,
                                            image: nutritionImgUrl != ""
                                                ? DecorationImage(
                                                    image: NetworkImage(AppConfig.apiUrl + nutritionImgUrl))
                                                : DecorationImage(
                                                    image: FileImage(File(nutritionImg!.path)),
                                                  ),
                                          ),
                                          height: size.width * 0.15,
                                          width: size.width * 0.15,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            nutritionImg = null;
                                            nutritionImgUrl = '';
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          radius: size.width * 0.025,
                                          child: Icon(
                                            Icons.close,
                                            size: size.width * 0.04,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                else
                                  GestureDetector(
                                    onTap: () async {
                                      await selectNutrImages().then((value) async {
                                        if (!value) {
                                          if (await Permission.photos.shouldShowRequestRationale) {
                                            await selectNutrImages();
                                          } else {
                                            openAppSettings();
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                            color: AppColors.bgColorCardDarkGrey,
                                          ),
                                          height: size.width * 0.15,
                                          width: size.width * 0.15,
                                          child: const Icon(Icons.cloud_upload_rounded)),
                                    ),
                                  ),
                              ],
                            ),*/
                            Container(
                              margin: const EdgeInsets.only(top: 20, right: 3),
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Text(AppText.selectCat[state.language]),
                                  isExpanded: true,
                                  items: state.categoryList
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item.categoryName,
                                          child: Row(
                                            children: [
                                              Text(
                                                item.categoryName ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: size.width * 0.034,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      catID = state.categoryList
                                          .firstWhere((element) => element.categoryName == value)
                                          .categoryId!;
                                      subCatID = null;
                                      subCategory = null;
                                      selectedValue = value!;
                                    });
                                    state.filterSubCatList(catID ?? "1");
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, right: 3, bottom: 10),
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Text(AppText.selectSubCat[state.language]),
                                  isExpanded: true,
                                  items: state.filterSubCategoryList
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item.subcategoryName,
                                          child: Row(
                                            children: [
                                              Text(
                                                item.subcategoryName ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: size.width * 0.034,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  value: subCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      subCatID = state.filterSubCategoryList
                                          .firstWhere((element) => element.subcategoryName == value)
                                          .subcategoryId!;
                                      subCategory = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            textFiled(name: AppText.productNameS[state.language], controller: name, size: size),
                            textFiled(
                                name: AppText.pricePKg[state.language],
                                controller: priceController,
                                size: size,
                                keyboardType: TextInputType.phone),
                            textFiled(
                                name: AppText.quantity[state.language],
                                controller: qtyController,
                                size: size,
                                keyboardType: TextInputType.phone),
                            const SizedBox(height: 10),
                            TextField(
                              maxLines: 4,
                              maxLength: 2000,
                              controller: descController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: AppText.aboutProduct[state.language],
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(7.0),
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppText.harvestingTime[state.language],
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: size.width * 0.04,
                                          letterSpacing: 1,
                                          wordSpacing: 1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                datePicker(
                                    title: AppText.from[state.language],
                                    date: start == null || start == '' ? AppText.selectDate[state.language] : start!,
                                    onTap: (value) {
                                      setState(() {
                                        start = convertToYMDFormat(value!);
                                      });
                                    },
                                    size: size),
                                datePicker(
                                    title: AppText.to[state.language],
                                    date: end == null || end == '' ? AppText.selectDate[state.language] : end!,
                                    onTap: (value) {
                                      setState(() {
                                        end = convertToYMDFormat(value!);
                                      });
                                    },
                                    size: size),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 5),
                              child: Text(
                                AppText.addNutrition[state.language],
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.width * 0.04,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: listIndex,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${index + 1}"),
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: textFiled(
                                        name: "${AppText.nutritionName[state.language]}*",
                                        controller: nutritionList[index],
                                        size: size,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: textFiled(
                                          name: "${AppText.kCal[state.language]}*",
                                          controller: calorieList[index],
                                          size: size,
                                          keyboardType: TextInputType.phone),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (index != 0) {
                                              nutritionList.removeAt(index);
                                              calorieList.removeAt(index);
                                              listIndex = listIndex - 1;
                                              nutritionList.add(TextEditingController(text: ""));
                                              calorieList.add(TextEditingController(text: ""));
                                            }
                                          });
                                        },
                                        highlightColor: index == 0 ? Colors.transparent : null,
                                        splashColor: index == 0 ? Colors.transparent : null,
                                        icon:
                                            Icon(Icons.delete, color: index == 0 ? Colors.transparent : AppColors.red))
                                  ],
                                );
                              },
                            ),
                            if (listIndex != 10)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomBtn(
                                      size: size,
                                      title: "${AppText.add[state.language]} +",
                                      onTap: () {
                                        setState(() {
                                          if (nutritionList[listIndex - 1].text.isNotEmpty &&
                                              calorieList[listIndex - 1].text.isNotEmpty) {
                                            setState(() {
                                              if (listIndex < 10) {
                                                listIndex = listIndex + 1;
                                              }
                                            });
                                          }
                                        });
                                      },
                                      btnColor: AppColors.primary,
                                      width: size.width * 0.5),
                                ],
                              ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                    if (state.isLoading) const Loading()
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget datePicker({
    required String title,
    required String date,
    required Function(DateTime?) onTap,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title :',
          style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            await showDatePicker(
                    context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(3000))
                .then((value) {
              if (value != null) {
                onTap(value);
              }
            });
          },
          child: Row(
            children: [
              Container(
                height: size.width * 0.1,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: const Icon(Icons.timer, color: Colors.white),
              ),
              Container(
                alignment: Alignment.center,
                height: size.width * 0.1,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  date,
                  style: TextStyle(fontSize: size.width * 0.035, color: Colors.black54),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

String convertToYMDFormat(DateTime time) {
  String date = "${time.day < 10 ? '0${time.day}' : '${time.day}'}-"
      "${time.month < 10 ? '0${time.month}' : '${time.month}'}-"
      "${time.year}";
  return date;
}
Widget textFiled({
  required String name,
  required TextEditingController controller,
  required Size size,
  TextInputType? keyboardType,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    // width: size.width - size.width * 0.11,
    // height: 50,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        labelText: name,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
  );
}
