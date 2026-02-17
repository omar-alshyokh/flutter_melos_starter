import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/src/presentation/cubit/post_details_cubit.dart';
import 'package:posts/src/presentation/utils/open_url.dart';
import 'package:posts/src/presentation/utils/post_ui_utils.dart';

class PostDetailsPage extends StatelessWidget {
  final int id;
  const PostDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
        builder: (context, state) {
          return switch (state) {
            PostDetailsLoading() => const Center(child: CircularProgressIndicator()),
            PostDetailsError(:final message) => Center(child: Text(message)),
            PostDetailsLoaded(:final story) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _Chip(text: '${story.score ?? 0} pts'),
                      if ((story.by ?? '').isNotEmpty) _Chip(text: 'by ${story.by}'),
                      _Chip(text: timeAgoFromUnixSeconds(story.time)),
                      if (domainFromUrl(story.url) != null) _Chip(text: domainFromUrl(story.url)!),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (story.url != null && story.url!.isNotEmpty)
                    FilledButton.icon(
                      onPressed: () => openUrl(story.url),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open link'),
                    ),
                ],
              ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
