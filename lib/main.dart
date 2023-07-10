import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/shared_prefe/app_preferences.dart';
import 'View Models/CustomViewModel.dart';
import 'Widgets/firebase_setup.dart';
import 'screens/dash_board/dashboard.dart';
import 'theme/colors.dart';

String? uid;

GlobalKey<NavigatorState> navgationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  uid = await AppPreferences.getLoggedin() ?? '';

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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CustomViewModel()),
    ],
    child: const MyApp(),
  ));
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    jumpScreen();
    super.initState();
  }

  void jumpScreen() async {
    log("===>>> fcm token ${await FirebaseMessaging.instance.getToken()}");
    log('==== user id $uid  ===');
    if (uid == '') {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
      });
    } else {
      Provider.of<CustomViewModel>(context, listen: false).uid = uid ?? "";
      await Provider.of<CustomViewModel>(context, listen: false).getCustomerProfile(userId: uid!).then((value) async {
        if (value == "Success") {
          setState(() {
            isLoggedIn = true;
            isLoading = false;
          });
          await initFirebase();
        } else {
          setState(() {
            isLoggedIn = false;
            isLoading = false;
          });
        }
      });
      log('==== user id $uid  ===');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navgationKey,
      title: 'Subjiwaala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
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
      ),
      home: /*AppNotificationWrapper(
        child:*/
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : /*isLoggedIn
                  ?*/
              const DashBoard(),
      // : const SignUpScreen(),
      // ),
      builder: EasyLoading.init(),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
