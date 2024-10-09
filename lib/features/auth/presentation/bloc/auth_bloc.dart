import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as myUser;
import 'package:flutter/material.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_current_user_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_in_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_out_usecase.dart';
import 'package:where_is_my_bus/features/bus_list_page/presentation/bloc/bloc/locations_bloc.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignUpWithGoogleUsecase _authSignUpWithGoogleUsecase;
  final AuthSignOutUsecase _authSignOutUsecase;
  final AuthCurrentUserUsecase _authGetCurrentUserUsecase;
  final UserCubit _userCubit;
  Timer? _listUpdateTimer;
  Timer? _locationUpdateTimer;

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    // Check if we have transitioned to AuthAuthenticated
    if (transition.nextState is AuthSuccess) {
      _startPeriodicTimers();
    } else {
      if (_listUpdateTimer != null) {
        _listUpdateTimer!.cancel();
        _locationUpdateTimer!.cancel();
        FlutterLocalNotificationsPlugin plugin =
            FlutterLocalNotificationsPlugin();
        plugin.cancel(NOTIFICATION_ID);
      }
    }
  }

  void _startPeriodicTimers() {
    _listUpdateTimer?.cancel();
    _locationUpdateTimer?.cancel();

    _listUpdateTimer =
        Timer.periodic(Duration(seconds: UPDATE_LIST_INTERVAL), (timer) {
      serviceLocator<LocationsBloc>().add(GetBusLocationsEvent());
    });

    _locationUpdateTimer =
        Timer.periodic(Duration(seconds: UPDATE_LOCATION_INTERVAL), (timer) {
      serviceLocator<LocationsBloc>().add(UpdateCurrentLocationEvent());
    });
  }

  @override
  Future<void> close() {
    _listUpdateTimer?.cancel();
    _locationUpdateTimer?.cancel();
    return super.close();
  }

  AuthBloc(
      {required AuthSignUpWithGoogleUsecase authSignUpWithGoogleUsecas,
      required AuthSignOutUsecase authSignOutUseCase,
      required AuthCurrentUserUsecase authCurrentUserUsecase,
      required UserCubit userCubit})
      : _authSignOutUsecase = authSignOutUseCase,
        _authSignUpWithGoogleUsecase = authSignUpWithGoogleUsecas,
        _authGetCurrentUserUsecase = authCurrentUserUsecase,
        _userCubit = userCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignInEvent>(_authSignInEvent);
    on<AuthSignOutEvent>(_authSignOutEvent);
    on<AuthCurrentUserEvent>(
        (event, emit) => _authCurrentUserEvent(event, emit));
  }
  void _authSignInEvent(
      AuthSignInEvent authSignOutEvent, Emitter<AuthState> emit) async {
    final res = await _authSignUpWithGoogleUsecase(NoParams());
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (r) => _emitAuthSucces(r, emit));
  }

  void _authSignOutEvent(
      AuthSignOutEvent authSignOutEvent, Emitter<AuthState> emit) async {
    final res = await _authSignOutUsecase(NoParams());
    res.fold((onLeft) => emit(AuthFailure(message: onLeft.message)),
        (onRight) => emit(AuthSignOutSuccess()));
  }

  void _authCurrentUserEvent(AuthCurrentUserEvent authCurrentUserEvent,
      Emitter<AuthState> emit) async {
    final res = await _authGetCurrentUserUsecase(NoParams());
    res.fold((onLeft) => _emitAuthFailure(onLeft, emit),
        (onRight) => _emitAuthSucces(onRight, emit));
  }

  void _emitAuthSucces(myUser.User user, Emitter<AuthState> emit) {
    _userCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }

  void _emitAuthFailure(Failure left, Emitter<AuthState> emit) {
    _userCubit.noUserFound();
    emit(AuthFailure(message: left.message));
  }
}
