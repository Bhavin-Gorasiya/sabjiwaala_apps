// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/helper.dart';

BuildContext? parentContextPostWidget;

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late final WebViewController _controller1;
  late final WebViewController _controller2;

  List<Widget> _list = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller1 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://sabjiwaala.radarsofttech.in/post.php?content=" +
            Uri.encodeComponent(content1) +
            "&css=" +
            Uri.encodeComponent(css1)),
      );
    /*..loadRequest(
        Uri.parse("https://google.com"),
      );*/

    _controller2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://sabjiwaala.radarsofttech.in/post.php?content=" +
            Uri.encodeComponent(content2) +
            "&css=" +
            Uri.encodeComponent(css2)),
      );

    _list.add(Container(
      height: 2000,
      child: WebViewWidget(
        controller: _controller1,
      ),
    ));
    _list.add(Container(
      height: 2000,
      child: WebViewWidget(
        controller: _controller2,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: /* WebViewWidget(
          controller: _controller1,
        ),*/
            Image.memory(base64Decode(base64Content.toString().substring(22))),
      ),
    );
  }
}
