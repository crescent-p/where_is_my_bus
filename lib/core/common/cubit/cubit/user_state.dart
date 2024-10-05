part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoggedIn extends UserState {
  final myUser.User user;
  UserLoggedIn({required this.user});
  myUser.User get getUser => user;
}

final class UserLoggedOut extends UserState {}
