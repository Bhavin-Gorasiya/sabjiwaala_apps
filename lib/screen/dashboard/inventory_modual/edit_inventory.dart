import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sub_franchisee/helper/app_config.dart';
import 'package:sub_franchisee/screen/widgets/custom_appbar.dart';
import 'package:sub_franchisee/screen/widgets/custom_textfields.dart';
import '../../../models/product_model.dart';

class EditInventory extends StatefulWidget {
  final bool isAdd;
  final InventoryModel data;

  const EditInventory({Key? key, this.isAdd = false, required this.data}) : super(key: key);

  @override
  State<EditInventory> createState() => _EditInventoryState();
}

class _EditInventoryState extends State<EditInventory> {
  TextEditingController title = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController desc = TextEditingController();

/*  List<XFile>? imageFileList = [
    XFile(
        "/Users/pc/Library/Developer/CoreSimulator/Devices/58480EF4-CD25-4C87-8B56-44B
        2EE5E14AA/data/Containers/Data/Application/1E8E883F-95A3-4DB9-B0BD-7F88A2AFEBE5
        /tmp/image_picker_B3AA232B-9BA1-4106-B953-54FD16C5B5AE-1889-0000057BF66E1421.png")
  ];
  final ImagePicker imagePicker = ImagePicker();

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    log("Image List Length:${imageFileList![0].path}");
    setState(() {});
  }

  */
  bool isEdit = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (!widget.isAdd) {
      title.text = widget.data.userproductPname ?? "";
      qty.text = "${widget.data.userproductQty ?? " "} kg.";
      price.text = "₹ ${widget.data.userproductPrice}/-";
      desc.text = widget.data.userproductDesc ?? "";
    } else {
      // imageFileList!.clear();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomAppBar(size: size, title: title.text),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Images",
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            height: size.width * 0.18,
                            width: size.width * 0.18,
                            imageUrl: (AppConfig.apiUrl + (widget.data.userproductPPic ?? '')),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/sabjiwaala.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextFields(
                          readOnly: !isEdit,
                          validation: "Please enter Item name",
                          hintText: "Enter item name",
                          controller: title),
                      CustomTextFields(
                        readOnly: !isEdit,
                        validation: "Please enter Item quantity",
                        hintText: "Enter item Qty.",
                        controller: qty,
                        keyboardType: TextInputType.phone,
                      ),
                      CustomTextFields(
                          readOnly: !isEdit,
                          validation: "Please enter Item Price per Kg.",
                          hintText: "Enter item Price/Kg.",
                          keyboardType: TextInputType.phone,
                          controller: price),
                      CustomTextFields(
                          readOnly: !isEdit,
                          validation: "Please enter Item description",
                          hintText: "Enter item Description",
                          maxLines: 4,
                          controller: desc),
                    ],
                  ),
                ),
              ),
            ),
            /*   if (isEdit || widget.isAdd)
              Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.05,
                    left: size.width * 0.05,
                    bottom: MediaQuery.of(context).padding.bottom + 5,
                    top: 5),
                child: CustomBtn(
                  size: size,
                  title: widget.isAdd ? "Add Item" : "Save",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (imageFileList != null && imageFileList!.isNotEmpty) {
                        pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select item Images"),
                          ),
                        );
                      }
                    }
                  },
                  btnColor: AppColors.primary,
                  radius: 10,
                ),
              )*/
          ],
        ),
      ),
    );
  }
}

/*
GridView.builder(
   padding: EdgeInsets.zero,
   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
     crossAxisCount: 5,
   ),
   shrinkWrap: true,
   itemCount: imageFileList == null ? 1 : imageFileList!.length + 1,
   physics: const NeverScrollableScrollPhysics(),
   itemBuilder: (context, index) {
     return index == imageFileList!.length
         ? (isEdit || widget.isAdd)
             ? GestureDetector(
                 onTap: () async {
                   await Permission.photos.status.then((value) {
                     if (value == PermissionStatus.granted) {
                       selectImages();
                     } else if (value == PermissionStatus.denied) {
                       selectImages();
                     } else {
                       openAppSettings();
                     }
                   });
                 },
                 child: DottedBorder(
                   borderType: BorderType.RRect,
                   radius: const Radius.circular(5),
                   dashPattern: const [4, 2],
                   color: Colors.black26,
                   strokeWidth: 2,
                   borderPadding: const EdgeInsets.all(7),
                   child: Container(
                     margin: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.black12,
                       borderRadius: BorderRadius.circular(5),
                     ),
                     child: const Center(
                       child: Icon(Icons.add),
                     ),
                   ),
                 ),
               )
             : const SizedBox()
         : Stack(
             alignment: Alignment.topRight,
             children: [
               Container(
                 margin: const EdgeInsets.all(7),
                 decoration: BoxDecoration(
                     image: DecorationImage(
                       fit: BoxFit.cover,
                       image: NetworkImage(AppConfig.apiUrl + (widget.data.userproductPPic ?? '')),
                     ),
                     borderRadius: BorderRadius.circular(5),
                     border: Border.all(color: Colors.black26)),
               ),
               if (isEdit || widget.isAdd)
                 GestureDetector(
                   onTap: () {
                     setState(() {
                       imageFileList!.removeAt(index);
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
           );
   },
 ),
* */
