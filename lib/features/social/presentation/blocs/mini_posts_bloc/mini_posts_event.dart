part of 'mini_posts_bloc.dart';

@immutable
sealed class MiniPostsEvent {}

class GetMiniPostsEvent extends MiniPostsEvent {}
