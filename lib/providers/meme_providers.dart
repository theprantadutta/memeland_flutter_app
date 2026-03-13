import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meme_model.dart';
import '../services/meme_service.dart';

final memeServiceProvider = Provider<MemeService>((ref) => MemeService());

final dailyMemeProvider = FutureProvider<MemeModel?>((ref) async {
  final service = ref.read(memeServiceProvider);
  return service.getDailyMeme();
});

final trendingMemesProvider = FutureProvider<List<MemeModel>>((ref) async {
  final service = ref.read(memeServiceProvider);
  return service.getTrendingMemes();
});

final savedMemesProvider = FutureProvider<List<MemeModel>>((ref) async {
  final service = ref.read(memeServiceProvider);
  return service.getSavedMemes();
});

final memesByTopicProvider = FutureProvider.family<List<MemeModel>, String>((ref, topic) async {
  final service = ref.read(memeServiceProvider);
  return service.getMemesByTopic(topic);
});
