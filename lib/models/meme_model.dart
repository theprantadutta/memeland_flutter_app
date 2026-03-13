class MemeModel {
  final String id;
  final String imageUrl;
  final String caption;
  final String? topicName;
  final DateTime createdAt;
  final bool isTrending;
  final bool isDaily;
  final int saveCount;

  const MemeModel({
    required this.id,
    required this.imageUrl,
    required this.caption,
    this.topicName,
    required this.createdAt,
    this.isTrending = false,
    this.isDaily = false,
    this.saveCount = 0,
  });

  factory MemeModel.fromJson(Map<String, dynamic> json) {
    return MemeModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      caption: json['caption'] as String,
      topicName: json['topic_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isTrending: json['is_trending'] as bool? ?? false,
      isDaily: json['is_daily'] as bool? ?? false,
      saveCount: json['save_count'] as int? ?? 0,
    );
  }
}
