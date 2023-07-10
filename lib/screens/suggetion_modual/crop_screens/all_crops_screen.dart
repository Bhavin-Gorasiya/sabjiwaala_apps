import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/crop_screens/crop_dash_board.dart';
import 'package:subjiwala_farmer/utils/helper.dart';

import '../../auth/signup_screen.dart';

class AllCropsScreen extends StatelessWidget {
  const AllCropsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes(size.width * 0.05, 25, size), vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gridView(
            onTap: () {
              push(context, CropDashBoard(name: "Milky"));
            },
            size: size,
            name: "Milky",
            title: "Vegetables",
            img: "https://static.agrostar.in/static/Bottle%20Gourd%20(Dudhi).jpg",
            item: 8,
          ),
          gridView(
            onTap: () {
              push(context, CropDashBoard(name: "WaterMelon"));
            },
            size: size,
            name: "WaterMelon",
            title: "Fruits",
            img: "https://static.agrostar.in/static/Watermelon_new.jpg",
            item: 4,
          ),
          gridView(
            onTap: () {
              push(context, CropDashBoard(name: "Mug"));
            },
            size: size,
            name: "Mug",
            title: "Beans",
            img: "https://static.agrostar.in/static/Green%20Gram%20(Moong).jpg",
            item: 2,
          ),
          gridView(
            onTap: () {
              push(context, CropDashBoard(name: "Corn"));
            },
            size: size,
            name: "Corn",
            title: "Cereal",
            img: "https://static.agrostar.in/static/Maize.jpg",
            item: 5,
          ),
        ],
      ),
    );
  }
}

Widget gridView({
  required Size size,
  required String name,
  required String title,
  required String img,
  required int item,
  required Function onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.8),
            fontSize: size.width * 0.045,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          itemCount: item,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 10, childAspectRatio: 0.7),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        child: Image(
                          width: size.width,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            img,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
