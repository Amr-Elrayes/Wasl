
class LearningResourceModel {
  final String type;
  final String name;
  final String provider;
  final String url;
  final bool free;
  final int estimatedHours;

  LearningResourceModel({
    required this.type,
    required this.name,
    required this.provider,
    required this.url,
    required this.free,
    required this.estimatedHours,
  });

  factory LearningResourceModel.fromJson(Map<String, dynamic> json) {
    return LearningResourceModel(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      provider: json['provider'] ?? '',
      url: json['url'] ?? '',
      free: json['free'] ?? false,
      estimatedHours: json['estimated_hours'] ?? 0,
    );
  }
}