import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/src/domain/entities/story.dart';
import 'package:posts/src/domain/usecases/get_story_details.dart';

sealed class PostDetailsState {
  const PostDetailsState();
}

class PostDetailsInitial extends PostDetailsState {
  const PostDetailsInitial();
}

class PostDetailsLoading extends PostDetailsState {
  const PostDetailsLoading();
}

class PostDetailsLoaded extends PostDetailsState {
  final Story story;
  const PostDetailsLoaded(this.story);
}

class PostDetailsError extends PostDetailsState {
  final String message;
  const PostDetailsError(this.message);
}

class PostDetailsCubit extends Cubit<PostDetailsState> {
  final GetStoryDetailsUseCase _useCase;
  void _emitSafe(PostDetailsState next) {
    if (!isClosed) emit(next);
  }

  PostDetailsCubit(this._useCase) : super(const PostDetailsInitial());

  Future<void> load(int id) async {
    _emitSafe(const PostDetailsLoading());
    final res = await _useCase(id);
    if (isClosed) return;
    res.when(
      success: (story) => _emitSafe(PostDetailsLoaded(story)),
      failure: (f) => _emitSafe(PostDetailsError(f.message)),
    );
  }
}
