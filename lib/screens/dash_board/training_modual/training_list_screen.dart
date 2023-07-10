import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/View%20Models/CustomViewModel.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';
import 'package:subjiwala_farmer/theme/colors.dart';
import 'package:subjiwala_farmer/utils/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Models/training_model.dart';
import '../../../Widgets/shimmer_loader/image_loader.dart';
import '../../../utils/app_config.dart';

class TrainingListScreen extends StatefulWidget {
  const TrainingListScreen({Key? key}) : super(key: key);

  @override
  State<TrainingListScreen> createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<TrainingListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        final state = Provider.of<CustomViewModel>(context, listen: false);
        await state.getTraining();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(size: size, title: AppText.training[state.language]),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            return Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : state.trainingList.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          height: size.height * 0.7,
                          child: Text(
                            "No Data found",
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.trainingList.length,
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
                          itemBuilder: (context, index) {
                            return trainingTile(size, context, state.trainingList[index]);
                          },
                        ),
            );
          }),
        ],
      ),
    );
  }

  Widget trainingTile(Size size, BuildContext context, Training data) {
    return GestureDetector(
      onTap: () {
        launch(data.customnotificationUrl ?? "");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.width * 0.45,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: AppConfig.apiUrl + (data.customnotificationPic ?? ""),
                  placeholder: (context, url) => ImageLoader(height: size.width * 0.2, width: size.width, radius: 15),
                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.customnotificationTitle ?? "Training title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.customnotificationMsg ?? "this is the training description that you have to read once.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: size.width * 0.028),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat("dd MMMM, yyyy  hh:mm a").format(data.customnotificationDate ?? DateTime.now()),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: size.width * 0.028),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
                          ],
                        ),
                        child: const Text("View Link", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
