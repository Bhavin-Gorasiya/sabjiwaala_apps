import 'package:flutter/material.dart';

import 'app_colors.dart';

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


snackBar(BuildContext context, String title, {Color? color}) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title), backgroundColor: color ?? AppColors.red));
}

void logLongString(String s) {
  if (s == null || s.length <= 0) return;
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