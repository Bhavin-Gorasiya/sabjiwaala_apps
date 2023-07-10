import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:employee_app/screens/dashboard_screen/setting_modual.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../helper/navigations.dart';
import '../../main.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initFirebase() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var initialzationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      push(navgationKey.currentContext!, const SettingScreen());
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    log("message  ===>>> ${message.notification!.android!.imageUrl}");

    if (notification != null && android != null) {
      // final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap((await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List());
      String url = notification.android!.imageUrl ?? "";

      Future<ByteArrayAndroidBitmap> getByteArrayFromUrl() async {
        // final http.Response response = await http.get(Uri.parse(notification!.android!.imageUrl ?? ""));
        final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
          (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List(),
        );
        return largeIcon;
      }
      // final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(await getByteArrayFromUrl());

      await getByteArrayFromUrl().then((value) => flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              styleInformation: BigPictureStyleInformation(
                value,
                htmlFormatContentTitle: false,
                htmlFormatSummaryText: false,
                hideExpandedLargeIcon: false,
              ),
              channel.id,
              channel.name,
              color: Colors.blue,
              icon: "@mipmap/ic_launcher",
            ),
          )));
    }
  });
}
