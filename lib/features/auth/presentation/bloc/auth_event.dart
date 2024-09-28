part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignInEvent extends AuthEvent {
  AuthSignInEvent();
}

final class AuthCurrentUserEvent extends AuthEvent {
  AuthCurrentUserEvent();
}

final class AuthSignOutEvent extends AuthEvent {
  AuthSignOutEvent();
}
