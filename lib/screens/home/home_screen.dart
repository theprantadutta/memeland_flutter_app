import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/meme_providers.dart';
import '../../router/route_names.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/meme_card.dart';
import '../../widgets/loading_widget.dart';
import '../../services/sharing_service.dart';
import '../../services/meme_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dailyMeme = ref.watch(dailyMemeProvider);
    final trendingMemes = ref.watch(trendingMemesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MEMELAND',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.push(AppRoutes.savedMemes),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dailyMemeProvider);
          ref.invalidate(trendingMemesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Meme Section
              Text('Daily Meme', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              dailyMeme.when(
                data: (meme) {
                  if (meme == null) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Center(
                          child: Text('No daily meme yet!', style: theme.textTheme.bodyLarge),
                        ),
                      ),
                    );
                  }
                  return MemeCard(
                    meme: meme,
                    onSave: () => MemeService().saveMeme(meme.id),
                    onShare: () => SharingService.shareMeme(imageUrl: meme.imageUrl, caption: meme.caption),
                  );
                },
                loading: () => const SizedBox(height: 200, child: LoadingWidget()),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text('Could not load daily meme', style: theme.textTheme.bodyMedium),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // Topics Section
              Text('Topics', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildTopicChip(context, 'Programming', Icons.code),
                  _buildTopicChip(context, 'Work', Icons.work_outline),
                  _buildTopicChip(context, 'Relationships', Icons.favorite_border),
                  _buildTopicChip(context, 'Gym', Icons.fitness_center),
                  _buildTopicChip(context, 'College', Icons.school_outlined),
                  _buildTopicChip(context, 'Gaming', Icons.sports_esports),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // Trending Section
              Text('Trending', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              trendingMemes.when(
                data: (memes) {
                  if (memes.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Center(
                          child: Text('No trending memes yet. Generate some!', style: theme.textTheme.bodyLarge),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: memes.map((meme) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: MemeCard(
                        meme: meme,
                        onSave: () => MemeService().saveMeme(meme.id),
                        onShare: () => SharingService.shareMeme(imageUrl: meme.imageUrl, caption: meme.caption),
                      ),
                    )).toList(),
                  );
                },
                loading: () => const SizedBox(height: 200, child: LoadingWidget()),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text('Could not load trending memes', style: theme.textTheme.bodyMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.memeGenerator),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate'),
      ),
    );
  }

  Widget _buildTopicChip(BuildContext context, String topic, IconData icon) {
    final theme = Theme.of(context);
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(topic),
      onPressed: () => context.push(AppRoutes.memeGenerator),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
