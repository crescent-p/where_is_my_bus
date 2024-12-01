part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoggedIn extends UserState {
  final my_user.User user;
  UserLoggedIn({required this.user});
  my_user.User get getUser => user;
}

final class UserLoggedOut extends UserState {}
