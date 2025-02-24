part of 'mini_posts_bloc.dart';

@immutable
sealed class MiniPostsState {}

final class MiniPostsInitial extends MiniPostsState {}

final class MiniPostsLoadedState extends MiniPostsState {
  final Map<String, List<MiniPost>> posts;

  MiniPostsLoadedState({required this.posts});
}

final class MiniPostsFailedState extends MiniPostsState {
  final String message;

  MiniPostsFailedState({required this.message});
}
