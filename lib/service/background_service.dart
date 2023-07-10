import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/app_preferences.dart';
import '../view model/CustomViewModel.dart';

class BackgroundService {
  static const notificationChannelId = 'my_foreground';
  static const notificationId = 888;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'MY FOREGROUND SERVICE', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
        ),
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: notificationChannelId,
          initialNotificationTitle: 'Sabjiwaala Location',
          initialNotificationContent: 'Initializing',
          foregroundServiceNotificationId: notificationId,
        ));
    log("===>>>");
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;
    DartPluginRegistrant.ensureInitialized();
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    log(" === is shop open  ${prefs.containsKey(PreferenceKeys.shop)}");
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      count = count + 1;
      CustomViewModel.determinePosition().then((value) async {
        CustomViewModel().updateLatLong(
            userLat: "${value.latitude}",
            userLong: "${value.longitude}",
            id: await AppPreferences.getLoggedin() ?? "0");
      });
      /*flutterLocalNotificationsPlugin.show(
        notificationId,
        'COOL SERVICE',
        'Awesome ${DateTime.now()}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );*/
    });
  }
}
