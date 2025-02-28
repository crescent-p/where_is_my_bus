part of 'social_bloc.dart';

@immutable
sealed class SocialEvent {}

class GetMiniPostsEvent extends SocialEvent {
  final int limit;
  GetMiniPostsEvent({required this.limit});
}

class GetPostEvent extends SocialEvent {
  final String uuid;

  GetPostEvent({required this.uuid});
}


class FetchCommentEvent extends SocialEvent {
  final String postID;

  FetchCommentEvent({required this.postID});
}

class FetchPostEvent extends SocialEvent {
  final String postID;

  FetchPostEvent({required this.postID});
}
