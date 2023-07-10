import 'dart:developer';

import 'package:delivery_app/screens/home_modual/order_history.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      push(navgationKey.currentContext!, const OrderHistory());
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    log("message");
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.blue,
              icon: "@mipmap/ic_launcher",
            ),
          ));
    }
  });
}
//
// Future listenNot() async {
//   /*var initialzationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);*/
//
// /*  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     log("message");
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               color: Colors.blue,
//               icon: "@mipmap/ic_launcher",
//             ),
//           ));
//     }
//   });*/
//
//   /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     // if (notification != null && android != null) {
//     push(navgationKey.currentContext!, const OrderScreen());
//       // showDialog(
//       //     // context: context,
//       //     builder: (_) {
//       //       return AlertDialog(
//       //         title: Text( "done"),
//       //         content: SingleChildScrollView(
//       //           child: Column(
//       //             crossAxisAlignment: CrossAxisAlignment.start,
//       //             children: [Text("done")],
//       //           ),
//       //         ),
//       //       );
//       //     },
//       //     context: context);
//     // }
//   });*/
// }
