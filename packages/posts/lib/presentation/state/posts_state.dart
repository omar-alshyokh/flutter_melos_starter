import 'package:equatable/equatable.dart';
import 'package:posts/domain/entities/story.dart';

sealed class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<Story> stories;
  const PostsLoaded(this.stories);

  @override
  List<Object?> get props => [stories];
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}
