import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_comments_usecase.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_mini_posts_usecase.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_specific_post_usecase.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final GetMiniPostsUsecase _getMiniPostsUsecase;
  final GetCommentsUsecase _getCommentsUsecase;
  final GetSpecificPostUseCase _getSpecificPostUseCase;
  
  SocialBloc({
    required GetMiniPostsUsecase getMiniPostsUsecase,
    required GetCommentsUsecase getCommentsUsecase,
    required GetSpecificPostUseCase getSpecificPostUseCase,
  })  : _getMiniPostsUsecase = getMiniPostsUsecase,
        _getCommentsUsecase = getCommentsUsecase,
        _getSpecificPostUseCase = getSpecificPostUseCase,
        super(SocialStateInitial()) {
    on<SocialEvent>((event, emit) {});
    on<GetMiniPostsEvent>(_getMiniPostsEvent);
    on<FetchCommentEvent>(_getCommentsEvent);
    on<FetchPostEvent>(_getSpecifiPostEvent);
  }
  Future<void> _getSpecifiPostEvent(
      FetchPostEvent event, Emitter<SocialState> emit) async {
    final res =
        await _getSpecificPostUseCase(SpecificPostParams(uuid: event.postID));
    res.fold((l) => emit(SocialStateFailed(message: l.message)),
        (r) => emit(SocialPostFetchedState(post: r)));
  }

  Future<void> _getCommentsEvent(
      FetchCommentEvent event, Emitter<SocialState> emit) async {
    final res = await _getCommentsUsecase(Params(postID: event.postID));
    res.fold((l) => emit(SocialStateFailed(message: l.message)),
        (r) => emit(SocialCommentsFetchedState(comments: r)));
  }

  Future<void> _getMiniPostsEvent(
      GetMiniPostsEvent event, Emitter<SocialState> emit) async {
    final res =
        await _getMiniPostsUsecase(MiniPostParams(startindex: 0, count: 10));
    res.fold((l) => emit(SocialStateFailed(message: l.message)),
        (r) => emit(SocialStateLoaded(posts: r)));
  }
}
