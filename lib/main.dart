import 'package:flutter/material.dart';
import 'package:tic80_mo/pages/1.%20StartUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yep',
      initialRoute: '/',

      routes: {
        '/': (context) => StartUp(),
        '/second': (context) => StartUp(),

      },

    );
  }
}

