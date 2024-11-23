import 'package:flutter_bloc/flutter_bloc.dart';

import '../sample_model/notification_entity.dart';
import 'notification_navigator.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationNavigator navigator;
  NotificationCubit(this.navigator) : super(NotificationState.empty());

  void getNotifications() {
    /// get your notifications from backend here and emit the state and call this function!
    emit(state.copyWith(notifications: state.notifications));
  }

  void addNotification(NotificationEntity notification) {
    state.notifications.insert(0, notification);
    emit(state.copyWith(
      notifications: state.notifications,
    ));
  }

  void navigateToRelatedScreen(String routeName, Map<String, dynamic>? args) {
    navigator.push(routeName, args);
  }
}
