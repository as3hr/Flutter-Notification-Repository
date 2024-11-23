# Flutter FCM Notification Service

A production-ready Firebase Cloud Messaging (FCM) implementation for Flutter that handles all notification states and scenarios. This service provides a robust foundation for handling push notifications in your Flutter applications.

## Features 🚀

- **Complete Lifecycle Management**
  - Foreground state handling
  - Background state handling
  - Terminated state handling
  - Auto-navigation on notification tap

- **Permission Management**
  - Streamlined permission flow
  - Proper iOS permission handling
  - Android permission management

- **Smart Navigation**
  - Configurable navigation patterns
  - Deep linking support
  - Screen arguments handling

## Installation 📦

1. Add the following dependencies to your `pubspec.yaml`:
```yaml
dependencies:
  firebase_messaging: ^latest_version
  firebase_core: ^latest_version
```

2. iOS Setup (in ios/Runner/Info.plist):
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

3. Android Setup (in android/app/src/main/AndroidManifest.xml):
```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />
    </application>
</manifest>
```

## Usage 💻

1. Initialize the service:
```dart
final notificationService = NotificationService(
  navigation: appNavigation,
  networkRepository: networkRepository,
);
```

2. Request permissions:
```dart
await notificationService.requestPermission();
```

3. Initialize notifications:
```dart
await notificationService.initNotifications(callFcm: true);
```

4. Handle navigation (customize `getScreenType`):
```dart
static (String, Map<String, dynamic>?) getScreenType(
  Map<String, dynamic>? message,
) {
  final screen = message?["screen"] ?? "";
  switch (screen) {
    case "yourScreen":
      return (RouteName.yourScreen, {"your": "params"});
    default:
      return (RouteName.default, null);
  }
}
```

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.