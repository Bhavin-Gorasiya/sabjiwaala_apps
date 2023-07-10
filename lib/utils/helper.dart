import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

String? fcmtoken;
String app_version = "";
const API_KEY = "AIzaSyAaHgfDzwtlUYxsaBZfqNCTbROLVhhw_N4";

void commonLaunchURL(_url) async => await canLaunchUrl(_url)
    ? await launchUrl(_url)
    : throw 'Could not launch $_url';

int getColorCode(String color) {
  return int.parse(color.replaceAll("#", "0xff"));
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}

push(BuildContext context, Widget destination) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}

pop(BuildContext context) {
  Navigator.pop(context);
}

void commonToast(BuildContext context, String msg, {Color? color}) {
  Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: msg,
      backgroundColor: color ?? Colors.black,
      textColor: Colors.white);
}

void logLongString(String s) {
  if (s.isEmpty) return;
  const int n = 1000;
  int startIndex = 0;
  int endIndex = n;
  while (startIndex < s.length) {
    if (endIndex > s.length) endIndex = s.length;
    print(s.substring(startIndex, endIndex));
    startIndex += n;
    endIndex = startIndex + n;
  }
}
