import 'package:flutter/material.dart';
import 'package:flutter_notifications_repository/initilizer.dart';
import 'package:flutter_notifications_repository/sample_navigation/app_navigation.dart';

void main() {
  Initializer.initializeApp().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigation.navigatorKey,
      // onGenerateRoute: , add your routing method here
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NOTIFICATION DEMO!!'),
        ),
        body: const Column(
          children: [],
        ),
      ),
    );
  }
}
