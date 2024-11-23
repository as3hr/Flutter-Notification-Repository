import '../sample_model/notification_entity.dart';

class NotificationState {
  List<NotificationEntity> notifications;
  NotificationState({
    required this.notifications,
  });

  copyWith({
    List<NotificationEntity>? notifications,
  }) =>
      NotificationState(
        notifications: notifications ?? this.notifications,
      );

  factory NotificationState.empty() => NotificationState(
        notifications: List<NotificationEntity>.empty(),
      );
}
