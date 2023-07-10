import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sub_franchisee/helper/app_colors.dart';

import '../../../helper/navigations.dart';

class OrderPopup extends StatelessWidget {
  const OrderPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tooltip: '',
      iconSize: size.width * 0.06,
      padding: EdgeInsets.zero,
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.white),
      itemBuilder: (context) => [
        popupMenu(
            value: 0,
            name: 'Week',
            size: size,
            onTap: () {
              pop(context);
            }),
        popupMenu(
            value: 1,
            name: 'Today',
            size: size,
            onTap: () {
              pop(context);
            }),
        popupMenu(
            value: 2,
            name: 'Last Day',
            size: size,
            onTap: () {
              pop(context);
            }),
        /*     popupMenu(value: 3, name: 'On 25-03', size: size, onTap: () {}),
        popupMenu(value: 4, name: '3 Days ago', size: size, onTap: () {}),
        popupMenu(value: 5, name: '4 Days ago', size: size, onTap: () {}),
        popupMenu(value: 6, name: '5 Days ago', size: size, onTap: () {}),
        popupMenu(value: 7, name: '6 Days ago', size: size, onTap: () {}),*/
      ],
    );
  }

  PopupMenuItem<int> popupMenu({
    required String name,
    required Size size,
    required Function onTap,
    required int value,
  }) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      height: 8,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customPopup({
  required Size size,
  required String title,
  required String desc,
  required String pdfName,
  required String btnName,
  bool isShare = false,
  required BuildContext contex,
  Function? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.black,
          padding: EdgeInsets.all(size.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.05,
                ),
              ),
              GestureDetector(
                onTap: () {
                  pop(contex);
                  if (isShare) pop(contex);
                },
                child: Icon(
                  Icons.clear,
                  size: size.width * 0.06,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(size.width * 0.04),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pdfName,
                style: TextStyle(
                  fontSize: size.width * 0.042,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                desc,
                style: TextStyle(
                  fontSize: size.width * 0.038,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  pop(contex);
                  if (onTap != null) onTap();
                },
                child: Container(
                  width: size.width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Color(0xFF215DF5),
                    borderRadius: BorderRadius.circular(size.width * 0.2),
                  ),
                  child: Text(
                    btnName,
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
