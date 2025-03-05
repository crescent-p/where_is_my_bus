part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationFetchedState extends NotificationState {
  final List<MyNotification> notifications;

  NotificationFetchedState({required this.notifications});
}

final class NotificationFailedState extends NotificationState {
  final String message;

  NotificationFailedState({required this.message});
}
