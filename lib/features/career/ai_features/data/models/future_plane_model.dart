class FuturePlanModel {
  final String skill;
  final String priority;
  final String reason;

  FuturePlanModel({
    required this.skill,
    required this.priority,
    required this.reason,
  });

  factory FuturePlanModel.fromJson(Map<String, dynamic> json) {
    return FuturePlanModel(
      skill: json['skill'] ?? '',
      priority: json['priority'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}