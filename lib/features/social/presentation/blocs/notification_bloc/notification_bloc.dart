import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/social/domain/entities/my_notification.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_notification_usecase.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/comments_bloc/comments_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationUsecase _getNotificationUsecase;
  NotificationBloc({required GetNotificationUsecase getNotificationUsecase})
      : _getNotificationUsecase = getNotificationUsecase,
        super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetNotificationEvent>(_getNotficationEvent);
  }
  Future<void> _getNotficationEvent(
      GetNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationInitial());
    final res = await _getNotificationUsecase(NoParams());
    res.fold((l) => emit(NotificationFailedState(message: l.message)),
        (r) => emit(NotificationFetchedState(notifications: r)));
  }
}
