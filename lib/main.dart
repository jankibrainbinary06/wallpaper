import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper/screens/admin_page/admin_panel.dart';
import 'package:wallpaper/screens/home_page/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDJL7M__du8r2p7Ff5GybGkwTRASU0LcMs",
        authDomain: "wallpaper-app-8fd97.firebaseapp.com",
        projectId: "wallpaper-app-8fd97",
        storageBucket: "wallpaper-app-8fd97.appspot.com",
        messagingSenderId: "897445179773",
        appId: "1:897445179773:web:5821dfdcbc2a5b612c9c14",
        measurementId: "G-YLM53M0F2B"
    )
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home:    HomeScreen(),
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
