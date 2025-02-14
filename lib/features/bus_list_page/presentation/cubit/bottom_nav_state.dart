part of 'bottom_nav_cubit.dart';

@immutable
sealed class BottomNavState {}

final class BottomNavInitial extends BottomNavState {}

final class Index extends BottomNavState {
  final int index;
  Index({required this.index});
  int get getIndex => index;
}
