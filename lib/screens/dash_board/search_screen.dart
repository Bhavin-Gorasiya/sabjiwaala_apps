import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import 'package:subjiwala/Widgets/custom_textfield.dart';
import 'package:subjiwala/models/product_models.dart';
import 'package:subjiwala/utils/helper.dart';

import '../../Widgets/shimmer_loader/image_loader.dart';
import '../../theme/colors.dart';
import '../../utils/app_config.dart';
import '../../utils/size_config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      pop(context);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.transparent,
                      width: size.width * 0.12,
                      height: size.width * 0.12,
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.75,
                    child: TextFormField(
                      controller: search,
                      onChanged: (String? value) {
                        CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                        state.searchVendor(value ?? "");
                      },
                      decoration: const InputDecoration(hintText: "Search Vendor here..."),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<CustomViewModel>(builder: (context, state, _) {
                return state.searchVendorList.isEmpty
                    ? const Center(
                        child: Text("No Vendor found"),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shrinkWrap: true,
                        itemCount: state.searchVendorList.length,
                        itemBuilder: (context, index) {
                          VendorProfile data = state.searchVendorList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    height: size.width * 0.15,
                                    width: size.width * 0.2,
                                    fit: BoxFit.cover,
                                    imageUrl: AppConfig.apiUrl + (data.userPicture ?? ""),
                                    placeholder: (context, url) => ImageLoader(
                                      height: SizeConfig.screenWidth! / 2.2 / 2.2,
                                      width: SizeConfig.screenWidth! / 3.5,
                                      radius: 10,
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      "assets/sabjiwaala.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data.userFname} ${data.userLname}",
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: size.width * 0.036,
                                          letterSpacing: 0.7),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.55,
                                      child: Text(
                                        data.userHaddress ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: size.width * 0.025,
                                              letterSpacing: 0.7,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.55,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.star, color: Colors.yellow.shade600, size: 18),
                                              const SizedBox(width: 7),
                                              Text(
                                                "4.5",
                                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: size.width * 0.032,
                                                    letterSpacing: 0.7),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "150m",
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: size.width * 0.033,
                                                  letterSpacing: 0.7,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
              }),
            )
          ],
        ),
      ),
    );
  }
}
