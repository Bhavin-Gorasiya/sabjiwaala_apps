import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/Widgets/custom_appbar.dart';

import '../../../View Models/CustomViewModel.dart';
import '../../../Widgets/shimmer_loader/image_loader.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_text.dart';

class TrainingDetails extends StatefulWidget {
  const TrainingDetails({Key? key}) : super(key: key);

  @override
  State<TrainingDetails> createState() => _TrainingDetailsState();
}

class _TrainingDetailsState extends State<TrainingDetails> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomAppBar(size: size, title: AppText.details[state.language]),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: false,
                        // aspectRatio: 2.0,
                        // height: 400,
                        viewportFraction: 1.0,
                        // enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: [1, 2].map(
                      (index) {
                        // log(AppConfig.apiUrl + index.bannerFile!);
                        return Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 5, right: 15, left: 15),
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  color: AppColors.bgColorCard,
                                ),
                                height: size.width * 0.2,
                                width: size.width,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: "https://www.inclusivebusiness.net/sites/default/files/styles/"
                                      "blog_header_images_max_960x960_/public/2018-09/Agri1.jpg?itok=7ZlSJJys",
                                  placeholder: (context, url) =>
                                      ImageLoader(height: size.width * 0.2, width: size.width, radius: 15),
                                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2].asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: _current != entry.key
                          ? Container(
                              width: 10.0,
                              height: 10.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                            )
                          : Container(
                              width: 10.0,
                              height: 10.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Training Title",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.045),
                      ),
                      Text(
                        "The best training title from te user will understand properly tht whole "
                        "problem that you giving solution is come here...",
                        style: TextStyle(fontSize: size.width * 0.032),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppText.videos[state.language],
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.045),
                      ),
                      GridView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 10, childAspectRatio: 1.4),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "https://www.inclusivebusiness.net/sites/default/files/wp/Agri4.png"))),
                            child: GestureDetector(
                              child: const CircleAvatar(
                                backgroundColor: Colors.white38,
                                child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
