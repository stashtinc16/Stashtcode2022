import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:stasht/firebase_options.dart';
import 'package:stasht/login_signup/bindings/signup_binding.dart';
import 'package:stasht/routes/app_pages.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => {
          FirebaseFirestore.instance.terminate(),
          FirebaseFirestore.instance.clearPersistence().then(
              (value) => {print('clearPersistence'), runApp(const MyApp())}),
        });
    configLoading();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.primaryColor
    ..backgroundColor = Colors.white
    ..indicatorColor = AppColors.primaryColor
    ..textColor = AppColors.primaryColor
    ..maskColor = AppColors.primaryColor.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: AppPages.initial,
      initialBinding: SignupBinding(),
      builder: EasyLoading.init(),
      theme: ThemeData(
          fontFamily: robotoRegular,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent),
    );
  }
}
