import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/add_comment_usecase.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_comments_usecase.dart';
// Removed unused import

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsUsecase _getCommentsUsecase;
  final AddCommentUsecase _addCommentUsecase;
  CommentsBloc({
    required GetCommentsUsecase getCommentsUsecase,
    required AddCommentUsecase addCommentUsecase,
  })  : _getCommentsUsecase = getCommentsUsecase,
        _addCommentUsecase = addCommentUsecase,
        super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) {});
    on<FetchCommentsEvent>(_getCommentsEvent);
    on<PostCommentEvent>(_postCommentEvent);
  }
  Future<void> _getCommentsEvent(
      FetchCommentsEvent event, Emitter<CommentsState> emit) async {
    final res = await _getCommentsUsecase(Params(postID: event.postID));
    res.fold((l) => emit(CommentsFailedState(message: l.message)),
        (r) => emit(CommentsFetchedState(comments: r)));
  }

  Future<void> _postCommentEvent(
      PostCommentEvent event, Emitter<CommentsState> emit) async {
    final res = await _addCommentUsecase(PostCommentParams(
        postID: event.postID, text: event.text, userEmail: event.email));
    res.fold(
      (l) => emit(CommentsFailedState(message: "Failed to post comments")),
      (r) => emit(CommentPostedState(message: "Successfully posted comment")),
    );
  }
}
