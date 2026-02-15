import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:posts/domain/usecases/get_top_stories_usecase.dart';

import 'posts_state.dart';

@injectable
class PostsCubit extends Cubit<PostsState> {
  final GetTopStoriesUseCase _useCase;

  PostsCubit(this._useCase) : super(const PostsInitial());

  Future<void> load({int limit = 20}) async {
    emit(const PostsLoading());

    final result = await _useCase(limit: limit);

    switch (result) {
      case Success(:final data):
        emit(PostsLoaded(data));
      case Failure(:final error):
        emit(PostsError(error.message));
    }
  }
}
