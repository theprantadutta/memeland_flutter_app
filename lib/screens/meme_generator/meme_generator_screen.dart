import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/meme_model.dart';
import '../../services/meme_service.dart';
import '../../services/sharing_service.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/meme_card.dart';

class MemeGeneratorScreen extends ConsumerStatefulWidget {
  const MemeGeneratorScreen({super.key});

  @override
  ConsumerState<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends ConsumerState<MemeGeneratorScreen> {
  final MemeService _memeService = MemeService();
  String _selectedTopic = 'Programming';
  MemeModel? _generatedMeme;
  bool _isGenerating = false;
  String? _error;

  final List<String> _topics = ['Programming', 'Work', 'Relationships', 'Gym', 'College', 'Gaming'];

  Future<void> _generateMeme() async {
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final meme = await _memeService.generateMeme(_selectedTopic);
      setState(() => _generatedMeme = meme);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meme Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Choose a topic', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _topics.map((topic) => ChoiceChip(
                label: Text(topic),
                selected: _selectedTopic == topic,
                onSelected: (_) => setState(() => _selectedTopic = topic),
              )).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateMeme,
              icon: _isGenerating
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome),
              label: Text(_isGenerating ? 'Generating...' : 'Generate Meme'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],

            if (_generatedMeme != null) ...[
              const SizedBox(height: AppSpacing.xl),
              MemeCard(
                meme: _generatedMeme!,
                onSave: () async {
                  try {
                    await _memeService.saveMeme(_generatedMeme!.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Meme saved!')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                onShare: () => SharingService.shareMeme(
                  imageUrl: _generatedMeme!.imageUrl,
                  caption: _generatedMeme!.caption,
                ),
              ),

              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: _generateMeme,
                icon: const Icon(Icons.refresh),
                label: const Text('Regenerate'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
