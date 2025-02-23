part of 'comments_bloc.dart';

@immutable
sealed class CommentsState {}

final class CommentsInitial extends CommentsState {}

final class CommentsFetchedState extends CommentsState {
  final List<Comments> comments;

  CommentsFetchedState({required this.comments});
}

final class CommentsFailedState extends CommentsState {
  final String message;

  CommentsFailedState({required this.message});
}
