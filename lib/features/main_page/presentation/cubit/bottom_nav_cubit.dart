import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); //default to zero

  void changeTab(int index) {
    emit(index);
  }
}
