import 'dart:io';

import 'package:demo_app/src/main/app.dart';
import 'package:demo_app/utils/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // ให้แน่ใจว่า Widgets ของ Flutter ถูก initialize ก่อน
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId,
    ));
  } else {
    await Firebase.initializeApp();
  }

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }

  const deviceLocale = Locale('en', 'US');

  runApp(EasyLocalization(
    path: 'assets/locales',
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('th', 'TH')
    ],
    fallbackLocale: deviceLocale,
    saveLocale: true,
    child: const MyApp(),
  ));
}
