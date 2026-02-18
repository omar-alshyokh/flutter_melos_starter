import 'package:flutter/material.dart';
import 'package:posts/src/domain/entities/story.dart';
import 'package:posts/src/presentation/utils/post_ui_utils.dart';

class PostTile extends StatelessWidget {
  final Story story;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const PostTile({
    super.key,
    required this.story,
    this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final domain = domainFromUrl(story.url);
    final timeAgo = timeAgoFromUnixSeconds(story.time);
    final score = story.score ?? 0;
    final by = story.by ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  _Chip(text: '$score pts'),
                  if (by.isNotEmpty) _Chip(text: 'by $by'),
                  if (timeAgo.isNotEmpty) _Chip(text: timeAgo),
                  if (domain != null) _Chip(text: domain),
                ],
              ),
              if (onToggleFavorite != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: onToggleFavorite,
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                    icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                  ),
                ),
              ],
            ],
          ),
        ),
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
