import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/meme_providers.dart';
import '../../services/sharing_service.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/meme_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/app_error_widget.dart';

class SavedMemesScreen extends ConsumerWidget {
  const SavedMemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final savedMemes = ref.watch(savedMemesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Memes')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(savedMemesProvider),
        child: savedMemes.when(
          data: (memes) {
            if (memes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border, size: 64, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text('No saved memes yet', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Save memes to find them here', style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: memes.length,
              itemBuilder: (context, index) {
                final meme = memes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: MemeCard(
                    meme: meme,
                    onShare: () => SharingService.shareMeme(
                      imageUrl: meme.imageUrl,
                      caption: meme.caption,
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(message: 'Loading saved memes...'),
          error: (e, _) => AppErrorWidget(
            message: 'Could not load saved memes',
            onRetry: () => ref.invalidate(savedMemesProvider),
          ),
        ),
      ),
    );
  }
}
