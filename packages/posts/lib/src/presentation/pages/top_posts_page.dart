import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/top_posts_cubit.dart';
import '../cubit/top_posts_state.dart';
import '../routes/posts_route_names.dart';
import '../widgets/post_tile.dart';

class TopPostsPage extends StatefulWidget {
  const TopPostsPage({super.key});

  @override
  State<TopPostsPage> createState() => _TopPostsPageState();
}

class _TopPostsPageState extends State<TopPostsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<TopPostsCubit>();
      cubit.init();
      cubit.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Posts')),
      body: BlocBuilder<TopPostsCubit, TopPostsState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.items.isEmpty) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () => context.read<TopPostsCubit>().load(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<TopPostsCubit>().refresh(),
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                if (state.errorMessage != null && state.items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                for (final item in state.items)
                  PostTile(
                    story: item,
                    isFavorite: state.favoriteIds.contains(item.id),
                    onToggleFavorite: () =>
                        context.read<TopPostsCubit>().toggleFavorite(item.id),
                    onTap: () => context.pushNamed(
                      PostsRouteNames.postDetails,
                      pathParameters: {'id': item.id.toString()},
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
