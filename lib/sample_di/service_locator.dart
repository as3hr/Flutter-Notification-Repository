import 'package:flutter_notifications_repository/sample_navigation/app_navigation.dart';
import 'package:flutter_notifications_repository/sample_network/network_repository.dart';
import 'package:flutter_notifications_repository/notification/notification_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> configureServiceLocator() async {
    getIt.registerSingleton<AppNavigation>(AppNavigation());
    getIt.registerSingleton<NetworkRepository>(NetworkRepository());
    getIt.registerSingleton<NotificationService>(
      NotificationService(
        getIt(),
        getIt(),
      ),
    );
  }
}
