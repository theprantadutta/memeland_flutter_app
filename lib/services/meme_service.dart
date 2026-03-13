import '../models/meme_model.dart';
import 'api_service.dart';

class MemeService {
  final ApiService _apiService = ApiService();

  Future<MemeModel> generateMeme(String topic) async {
    final data = await _apiService.generateMeme(topic);
    return MemeModel.fromJson(data);
  }

  Future<MemeModel?> getDailyMeme() async {
    try {
      final data = await _apiService.getDailyMeme();
      return MemeModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<List<MemeModel>> getTrendingMemes({int page = 1}) async {
    final data = await _apiService.getTrendingMemes(page: page);
    final items = data['items'] as List<dynamic>? ?? [];
    return items.map((e) => MemeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MemeModel>> getMemesByTopic(String topic) async {
    final data = await _apiService.getMemesByTopic(topic);
    return data.map((e) => MemeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveMeme(String memeId) async {
    await _apiService.saveMeme(memeId);
  }

  Future<List<MemeModel>> getSavedMemes() async {
    final data = await _apiService.getSavedMemes();
    return data.map((e) => MemeModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
