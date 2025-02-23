import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_comments_usecase.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_specific_post_usecase.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  GetCommentsUsecase _getCommentsUsecase;
  CommentsBloc({
    required GetCommentsUsecase getCommentsUsecase,
  })  : _getCommentsUsecase = getCommentsUsecase,
        super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) {});
    on<FetchCommentsEvent>((event, emit) => _getCommentsEvent);
  }
  Future<void> _getCommentsEvent(
      FetchCommentsEvent event, Emitter<CommentsState> emit) async {
    final res = await _getCommentsUsecase(Params(postID: event.postID));
    res.fold((l) => emit(CommentsFailedState(message: l.message)),
        (r) => emit(CommentsFetchedState(comments: r)));
  }
}
