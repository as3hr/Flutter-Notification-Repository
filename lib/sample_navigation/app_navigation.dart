import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNavigation {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final context = navigatorKey.currentState!.context;
  void push(String routeName, {arguments}) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  pop() {
    Navigator.pop(context);
  }

  exitApp() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  pushReplacement(String routeName, {arguments}) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  popAll(String routeName) {
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeName,
        (Route<dynamic> route) => false,
      );
    }
  }
}
