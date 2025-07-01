import 'package:flutter/material.dart';
import 'package:tic80_mo/pages/1.%20StartUp.dart';
import 'package:get/get.dart';
import 'package:tic80_mo/pages/start_up_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Get.put(start_up_controller());

    return GetMaterialApp(
      title: 'Yep',
      initialRoute: '/',

      routes: {
        '/': (context) => StartUp(),
        '/second': (context) => StartUp(),
      },

    );
  }
}