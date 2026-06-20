import 'package:wasl/features/career/future_plane/data/models/learning_week_model.dart';

class LearningPlanModel {
  final String targetRole;
  final String currentLevel;
  final String totalDuration;
  final int weeklyHours;
  final List<LearningWeekModel> plan;
  final List<String> certifications;
  final List<String> portfolioProjects;
  final List<String> tips;

  LearningPlanModel({
    required this.targetRole,
    required this.currentLevel,
    required this.totalDuration,
    required this.weeklyHours,
    required this.plan,
    required this.certifications,
    required this.portfolioProjects,
    required this.tips,
  });

  factory LearningPlanModel.fromJson(Map<String, dynamic> json) {
    return LearningPlanModel(
      targetRole: json['target_role'] ?? '',
      currentLevel: json['current_level'] ?? '',
      totalDuration: json['total_duration'] ?? '',
      weeklyHours: json['weekly_hours'] ?? 0,
      plan: (json['plan'] as List<dynamic>? ?? [])
          .map((e) => LearningWeekModel.fromJson(e))
          .toList(),
      certifications: List<String>.from(json['certifications'] ?? []),
      portfolioProjects: List<String>.from(json['portfolio_projects'] ?? []),
      tips: List<String>.from(json['tips'] ?? []),
    );
  }
}
