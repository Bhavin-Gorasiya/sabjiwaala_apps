import 'dart:developer';

import 'package:employee_app/screens/sign_up_modual/signup_screen.dart';
import 'package:employee_app/screens/widgets/firebase_setup.dart';
import 'package:employee_app/view%20model/CustomViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'helper/app_colors.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  String url = notification!.android!.imageUrl ?? "";

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
      AppLifecycleState.detached.name,
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

GlobalKey<NavigatorState> navgationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// fire base setup
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  ///

  log("===>>> fcm token ${await FirebaseMessaging.instance.getToken()}");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navgationKey,
      debugShowCheckedModeBanner: false,
      title: 'Employee',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 25, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w500),
          displayMedium: TextStyle(fontSize: 24, color: Colors.black, letterSpacing: 1, fontWeight: FontWeight.w900),
          displaySmall: TextStyle(fontSize: 16, color: Colors.black, letterSpacing: 1),
          headlineMedium: TextStyle(fontSize: 12, color: Colors.black, letterSpacing: 1),
          headlineSmall: TextStyle(fontSize: 12, color: Colors.black, letterSpacing: 1),
          titleLarge: TextStyle(fontSize: 10, color: Colors.black, letterSpacing: 1),
          labelLarge: TextStyle(fontSize: 16, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.w400),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: const IconThemeData(
            color: AppColors.primary,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(background: Colors.white),
      ),
      home: const SignUpScreen(),
    );
  }
}
