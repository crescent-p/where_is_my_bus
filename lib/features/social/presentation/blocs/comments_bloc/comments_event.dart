part of 'comments_bloc.dart';

@immutable
sealed class CommentsEvent {}

class FetchCommentsEvent extends CommentsEvent {
  final String postID;

  FetchCommentsEvent({required this.postID});

}
