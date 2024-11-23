import '../../sample_navigation/route_name.dart';
import '../../sample_navigation/app_navigation.dart';

class NotificationNavigator {
  final AppNavigation navigation;
  NotificationNavigator(this.navigation);

  void push(String routeName, Map<String, dynamic>? args) {
    navigation.push(routeName, arguments: args);
  }
}

mixin NotificationRoute {
  void goToNotification() => navigation.push(RouteName.notification);
  AppNavigation get navigation;
}
