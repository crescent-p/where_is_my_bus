part of 'social_bloc.dart';

@immutable
sealed class SocialState {}

final class SocialStateInitial extends SocialState {}


final class SocialStateFailed extends SocialState {
  final String message;

  SocialStateFailed({required this.message});
}

final class SocialCommentsFetchedState extends SocialState {
  final List<Comments> comments;

  SocialCommentsFetchedState({required this.comments});
}

final class SocialPostFetchedState extends SocialState {
  final Post post;

  SocialPostFetchedState({required this.post});
}
