import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/meme_model.dart';
import '../theme/app_spacing.dart';

class MemeCard extends StatelessWidget {
  final MemeModel meme;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final VoidCallback? onTap;

  const MemeCard({
    super.key,
    required this.meme,
    this.onSave,
    this.onShare,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Meme image
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: meme.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.broken_image, size: 48, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            // Caption + actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meme.caption,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (meme.topicName != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      meme.topicName!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      if (onSave != null)
                        IconButton(
                          icon: const Icon(Icons.bookmark_border, size: 20),
                          onPressed: onSave,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (onShare != null) ...[
                        const SizedBox(width: AppSpacing.md),
                        IconButton(
                          icon: const Icon(Icons.share, size: 20),
                          onPressed: onShare,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        '${meme.saveCount} saves',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
