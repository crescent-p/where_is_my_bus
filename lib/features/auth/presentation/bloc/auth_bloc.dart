import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/common/cubit/cubit/user_cubit.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as myUser;
import 'package:flutter/material.dart';
import 'package:where_is_my_bus/core/usecases/usecases.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_current_user_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_in_usecase.dart';
import 'package:where_is_my_bus/features/auth/domain/usecases/auth_sign_out_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignUpWithGoogleUsecase _authSignUpWithGoogleUsecase;
  final AuthSignOutUsecase _authSignOutUsecase;
  final AuthCurrentUserUsecase _authGetCurrentUserUsecase;
  final UserCubit _userCubit;

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
    on<AuthCurrentUserEvent>(_authCurrentUserEvent);
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
    res.fold((onLeft) => emit(AuthFailure(message: onLeft.message)),
        (onRight) => _emitAuthSucces(onRight, emit));
  }

  void _emitAuthSucces(myUser.User user, Emitter<AuthState> emit) {
    _userCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
