import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_notifications_repository/notification/local_notification_service.dart';

import '../sample_di/service_locator.dart';
import '../sample_navigation/route_name.dart';
import '../sample_navigation/app_navigation.dart';
import '../sample_network/network_repository.dart';
import 'sample_model/notification_json.dart';
import 'sample_state_cubit_navigator/notification_cubit.dart';

class NotificationService {
  final AppNavigation navigation;
  final NetworkRepository networkRepository;
  final LocalNotificationService localNotificationService;
  NotificationService(this.navigation, this.networkRepository)
      : localNotificationService = LocalNotificationService(navigation);

  final fcm = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await fcm.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("User granted provisional permission");
    } else {
      log("User declined or has not accepted permission");
    }
  }

  Future<void> initNotifications({bool callFcm = false}) async {
    await localNotificationService.initLocalNotifications();
    List<Future> futures = [
      handleForegroundNotification(),
      handleBackgroundNotificationClick(),
      handleTerminatedNotificationClick(),
      if (callFcm) sendTokenToServer(),
    ];
    Future.wait(futures);
  }

  Future<void> handleForegroundNotification() async {
    log("FOREGROUND LISTENER INITIALIZED");
    FirebaseMessaging.onMessage.listen(
      handleMessage,
      onError: (obj) {
        log("Error handling foreground notification: ${obj.toString()}");
      },
      onDone: () {
        log("Foreground notification listener done");
      },
    );
  }

  Future<void> sendTokenToServer() async {
    try {
      String? firebaseMessagingToken = await fcm.getToken();
      log("firebaseMessagingToken: $firebaseMessagingToken");
      // send the fcmToken to your server here!!
      await networkRepository.post(url: "/users/fcmtoken/", data: {
        "token": firebaseMessagingToken,
      });
    } catch (e) {
      log("Failed to send FCM token to server: $e");
    }
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    if (message.notification != null) {
      // add the notification to you notifications list in your app!!
      addNotification(message);
    }
  }

  static Future<void> addNotification(RemoteMessage? message) async {
    if (message?.data != null) {
      var notification =
          NotificationJson.fromJson(message?.data ?? {}).toDomain();
      notification.isNew =
          true; // initially this is set true so that you can show it in UI and keep the newOne look seperate from old notifications!
      getIt<NotificationCubit>().addNotification(
          notification); // add the notification to your notifications list in your app!!

      // showing a local Notification
      await LocalNotificationService.showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: message?.notification?.title ?? 'New Notification',
        body: message?.notification?.body ?? '',
        payload: json.encode(message?.data),
      );
    }
  }

  Future<void> handleTerminatedNotificationClick() async {
    log("TERMINATED LISTENER INITIALIZED");
    await fcm.getInitialMessage().then((message) {
      log("App Terminated Notification Received");
      if (message != null) {
        log("Message Title: ${message.notification?.title}");
        log("Message Body: ${message.notification?.body}");
        log("Full message data: ${message.data}");
        addNotification(message);
        _navigateBasedOnMessageType(message);
      }
    });
  }

  Future<void> handleBackgroundNotificationClick() async {
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessageOpen);
  }

  static Future<void> handleBackgroundMessage(RemoteMessage? message) async {
    log("BACKGROUND LISTENER INITIALIZED");
    if (message == null) return;
    if (message.notification != null) {
      log("Background Message Title: ${message.notification?.title}");
      log("Background Message Body: ${message.notification?.body}");
      addNotification(message);
    }
    log("Background message data: ${message.data}");
  }

  void handleMessageOpen(RemoteMessage? message) {
    log("Background Notification opened");
    if (message == null) return;
    if (message.notification != null) {
      log("Message Title: ${message.notification?.title}");
      log("Message Body: ${message.notification?.body}");
      _navigateBasedOnMessageType(message);
    }
  }

  void _navigateBasedOnMessageType(RemoteMessage message) {
    final screen = getScreenType(message.data);
    navigation.push(screen.$1, arguments: screen.$2);
  }

  static (String, Map<String, dynamic>?) getScreenType(
    Map<String, dynamic>? message,
  ) {
    final screen =
        message?["screen"] ?? ""; // get you screen hint from backend.
    switch (screen) {
      case "postDetail":
        final postId = int.tryParse(message?["screen_id"].toString() ?? "") ??
            0; // get the id incase of nested screens and add it to params.
        return (RouteName.postDetail, {"params": postId});

      // add more cases according to you backend response, screens and navigation!
      default:
        return (
          RouteName.settings,
          {}
        ); // default navigation -> set to any screen!
    }
  }
}
