import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/product_details.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/products_screen.dart';
import 'package:subjiwala_farmer/screens/suggetion_modual/widgets/cosausle_slider.dart';
import 'package:subjiwala_farmer/utils/helper.dart';
import '../auth/signup_screen.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({Key? key}) : super(key: key);

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final CarouselController _controller = CarouselController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCarousle(
          controller: _controller,
          img: "https://static.agrostar.in/static/A_Banner52508_1.jpg",
        ),
        text(size: size, title: "Categories"),
        SizedBox(
          height: size.width * 0.25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * .05),
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  push(context, const ProductsScreen());
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage("https://static.agrostar.in/static/category/category-seed.png"),
                        ),
                      ),
                      SizedBox(height: size.width * 0.01),
                      const Expanded(
                        flex: 1,
                        child: Text("Seeds"),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        text(size: size, title: "Popular products"),
        productContainer(
            size: size,
            index: 5,
            name: "Powergro Sulfur 90% G (Sulphur 90% Powder) 3 Kg",
            img: "https://static.agrostar.in/static/AGS-CN-425_N2_l.jpg"),
        text(size: size, title: "Popular products"),
        productContainer(
            size: size,
            index: 5,
            name: "Humic Power (Humic & Fulvic Acid 50%, Carrier 50%, Total 100 w/w) 250 g",
            img: "https://static.agrostar.in/static/AGS-CN-035_N1_l.jpg"),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 15)
      ],
    );
  }

  Widget text({required Size size, required String title}) {
    return Padding(
      padding: EdgeInsets.only(left: sizes(size.width * 0.05, 25, size), top: 25, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black.withOpacity(0.8),
          fontSize: size.width * 0.045,
        ),
      ),
    );
  }
}

Widget productContainer({required Size size, required int index, required String name, required String img}) {
  return GridView.builder(
    itemCount: index,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: size.width * 0.0018),
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          push(context, ProductDetail(name: name, img: img));
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black54)),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Image(
                  image: NetworkImage(img),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ 450",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "₹ 600",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
