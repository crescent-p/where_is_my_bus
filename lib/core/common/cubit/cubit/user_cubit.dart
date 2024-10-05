import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as myUser;

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void updateUser(myUser.User? user) {
    if (user != null) {
      emit(UserLoggedIn(user: user));
    } else {
      emit(UserLoggedOut());
    }
  }

  void noUserFound() {
    emit(UserLoggedOut());
    
  }
}
