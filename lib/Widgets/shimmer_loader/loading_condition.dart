import 'package:flutter/material.dart';

class LoadingCondition extends StatelessWidget {
  final bool isLoad;
  final List list;
  final Widget loader;
  final Widget child;

  const LoadingCondition(
      {Key? key, required this.isLoad, required this.list, required this.loader, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? loader
        : list.isEmpty
            ? const SizedBox()
            : child;
  }
}
