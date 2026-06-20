import 'package:wasl/features/career/future_plane/data/models/learning_resource_model.dart';


class LearningWeekModel {
  final String week;
  final String focus;
  final List<String> learningObjectives;
  final List<LearningResourceModel> resources;
  final String practiceProject;
  final String milestone;

  LearningWeekModel({
    required this.week,
    required this.focus,
    required this.learningObjectives,
    required this.resources,
    required this.practiceProject,
    required this.milestone,
  });

  factory LearningWeekModel.fromJson(Map<String, dynamic> json) {
    return LearningWeekModel(
      week: json['week'] ?? '',
      focus: json['focus'] ?? '',
      learningObjectives: List<String>.from(json['learning_objectives'] ?? []),
      resources: (json['resources'] as List<dynamic>? ?? [])
          .map((e) => LearningResourceModel.fromJson(e))
          .toList(),
      practiceProject: json['practice_project'] ?? '',
      milestone: json['milestone'] ?? '',
    );
  }
}
