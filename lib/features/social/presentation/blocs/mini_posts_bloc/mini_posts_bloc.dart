import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_mini_posts_usecase.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/social_bloc/social_bloc.dart';

part 'mini_posts_event.dart';
part 'mini_posts_state.dart';

class MiniPostsBloc extends Bloc<MiniPostsEvent, MiniPostsState> {
  final GetMiniPostsUsecase _getMiniPostsUsecase;
  MiniPostsBloc({
    required GetMiniPostsUsecase getMiniPostsUsecase,
  })  : _getMiniPostsUsecase = getMiniPostsUsecase,
        super(MiniPostsInitial()) {
    on<MiniPostsEvent>((event, emit) {});
    on<GetMiniPostsEvent>(_getMiniPostsEvent);
  }

  Future<void> _getMiniPostsEvent(
      GetMiniPostsEvent event, Emitter<MiniPostsState> emit) async {
    final res =
        await _getMiniPostsUsecase(MiniPostParams(startindex: 0, count: 10));
    res.fold((l) => emit(MiniPostsFailedState(message: l.message)),
        (r) => emit(MiniPostsLoadedState(posts: r)));
  }
}
