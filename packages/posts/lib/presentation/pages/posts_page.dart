import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/presentation/state/posts_cubit.dart';
import 'package:posts/presentation/state/posts_state.dart';
import 'package:url_launcher/url_launcher.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    // trigger load once
    Future.microtask(() => context.read<PostsCubit>().load(limit: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Stories')),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          return switch (state) {
            PostsInitial() => Center(
              child: ElevatedButton(
                onPressed: () => context.read<PostsCubit>().load(limit: 20),
                child: const Text('Load Top Stories'),
              ),
            ),
            PostsLoading() => const Center(child: CircularProgressIndicator()),
            PostsLoaded(:final stories) => RefreshIndicator(
              onRefresh: () => context.read<PostsCubit>().load(limit: 30),
              child: ListView.separated(
                itemCount: stories.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final s = stories[index];
                  return ListTile(
                    title: Text(s.title),
                    subtitle: Text('${s.by ?? "unknown"} • score ${s.score ?? 0}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final url = s.url;
                      if (url == null) return;
                      final uri = Uri.parse(url);
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                  );
                },
              ),
            ),
            PostsError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(message, textAlign: TextAlign.center),
              ),
            ),
          };
        },
      ),
    );
  }
}
