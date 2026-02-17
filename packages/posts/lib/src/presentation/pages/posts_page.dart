import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:posts/src/presentation/cubit/posts_cubit.dart';
import 'package:posts/src/presentation/cubit/posts_state.dart';
import 'package:posts/src/presentation/routes/posts_route_names.dart';
import 'package:posts/src/presentation/widgets/post_tile.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsCubit>().loadInitial();
    });
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final pos = _controller.position;
    if (!pos.hasContentDimensions) return;

    final threshold = pos.maxScrollExtent * 0.85;
    if (pos.pixels >= threshold) {
      context.read<PostsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          // First load
          if (state.isInitialLoading && state.items.isEmpty) {
            return const _LoadingList();
          }

          // Blocking error
          if (state.errorMessage != null && state.items.isEmpty) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () => context.read<PostsCubit>().loadInitial(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<PostsCubit>().refresh(),
            child: ListView(
              controller: _controller,
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                if (state.errorMessage != null && state.items.isNotEmpty)
                  _InlineErrorBanner(
                    message: state.errorMessage!,
                    onRetry: () => context.read<PostsCubit>().refresh(),
                  ),

                for (final item in state.items)
                  PostTile(
                    story: item,
                    onTap: () => context.pushNamed(
                      PostsRouteNames.postDetails,
                      pathParameters: {'id': item.id.toString()},
                    ),
                  ),

                if (state.loadMoreErrorMessage != null)
                  _InlineErrorBanner(
                    message: state.loadMoreErrorMessage!,
                    onRetry: () => context.read<PostsCubit>().loadMore(),
                  ),

                // bottom loading indicator (auto pagination)
                if (state.isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                if (!state.hasMore && state.items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Text(
                      'You’re all caught up.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 8,
      itemBuilder: (_, __) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: const SizedBox(height: 92),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _InlineErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineErrorBanner({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Material(
        color: color.errorContainer,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: color.onErrorContainer),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Retry',
                  style: TextStyle(color: color.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
