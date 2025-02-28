part of 'comments_bloc.dart';

@immutable
sealed class CommentsEvent {}

class FetchCommentsEvent extends CommentsEvent {
  final String postID;

  FetchCommentsEvent({required this.postID});
}

class PostCommentEvent extends CommentsEvent {
  final String email;
  final String postID;
  final String text;

  PostCommentEvent(
      {required this.email, required this.postID, required this.text});
}
