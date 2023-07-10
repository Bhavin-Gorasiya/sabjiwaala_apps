import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Size size;
  final IconData icon;
  final Function onTap;
  final Color color;

  const CustomIconButton({Key? key, required this.size, required this.icon, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.transparent,
        width: size.width * 0.1,
        height: size.width * 0.1,
        child: Icon(icon, color: color),
      ),
    );
  }
}
