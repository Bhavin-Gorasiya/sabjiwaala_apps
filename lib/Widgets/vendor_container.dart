import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:subjiwala/Widgets/shimmer_loader/image_loader.dart';
import 'package:subjiwala/models/product_models.dart';
import 'package:subjiwala/utils/app_config.dart';
import '../screens/dash_board/vendor_screen.dart';
import '../theme/colors.dart';
import '../utils/size_config.dart';

class VendorContainer extends StatelessWidget {
  final Size size;
  final VendorProfile data;
  final int index;

  const VendorContainer({
    Key? key,
    required this.size,
    required this.data, required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VendorDetailScreen(
              index: index,
              data: data,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, bottom: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: AppColors.bgColorCard,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: size.width * 0.2,
                    width: SizeConfig.screenWidth! / 3.5,
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
              ),
              const SizedBox(height: 5),
              Text(
                "${data.userFname} ${data.userLname}",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w700, fontSize: size.width * 0.036, letterSpacing: 0.7),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow.shade600, size: 18),
                  const SizedBox(width: 7),
                  Text(
                    "4.5",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w800, fontSize: size.width * 0.03, letterSpacing: 0.7),
                  ),
                ],
              ),
              SizedBox(
                width: size.width * 0.3,
                child: Text(
                  data.userHaddress ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w800,
                        fontSize: size.width * 0.03,
                        letterSpacing: 0.7,
                      ),
                ),
              ),
              Text(
                "150m",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      fontSize: size.width * 0.03,
                      letterSpacing: 0.7,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
