import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala_farmer/screens/auth/signup_screen.dart';

import 'View Models/CustomViewModel.dart';
import 'Widgets/firebase_setup.dart';
import 'theme/colors.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

GlobalKey<NavigatorState> navgationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  /// fire base setup
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  ///

  log("===>>> fcm token ${await FirebaseMessaging.instance.getToken()}");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomViewModel()),
      ],
      child: const MyApp(),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60
    ..textColor = Colors.black
    ..radius = 20
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.white
    ..indicatorColor = AppColors.primary
    ..userInteractions = false
    ..dismissOnTap = true
    ..boxShadow = <BoxShadow>[]
    ..indicatorType = EasyLoadingIndicatorType.fadingCube;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: navgationKey,
      title: 'Farmer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
          displayLarge: TextStyle(fontSize: 25, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w500),
          displayMedium: TextStyle(fontSize: 24, color: Colors.black, letterSpacing: 1, fontWeight: FontWeight.w900),
          displaySmall: TextStyle(
            fontSize: 16,
            color: Colors.black,
            letterSpacing: 1,
          ),
          headlineMedium: TextStyle(
            fontSize: 12,
            color: Colors.black,
            letterSpacing: 1,
          ),
          headlineSmall: TextStyle(fontSize: 12, color: Colors.black, letterSpacing: 1),
          titleLarge: TextStyle(fontSize: 10, color: Colors.black, letterSpacing: 1),
          labelLarge: TextStyle(fontSize: 16, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.w400),
        )),
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
      home: /*AppNotificationWrapper(
        child:*/
          const LoginScreen(),
      // ),
      builder: EasyLoading.init(),
    );
  }
}
