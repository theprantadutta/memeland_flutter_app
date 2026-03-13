class TopicModel {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;

  const TopicModel({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
    );
  }
}
