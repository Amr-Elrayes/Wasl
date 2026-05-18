import 'package:wasl/core/job/models/job_model.dart';

class JobMatchModel {
  final JobModel job;
  final int matchScore;
  final List<String> matchedSkills;
  final List<String> missingSkills;

  JobMatchModel({
    required this.job,
    required this.matchScore,
    required this.matchedSkills,
    required this.missingSkills,
  });

  factory JobMatchModel.fromJson(Map<String, dynamic> json) {
    return JobMatchModel(
      job: JobModel.fromJson(json),
      matchScore: json['matchScore'] ?? 0,
      matchedSkills: List<String>.from(json['matchedSkills'] ?? []),
      missingSkills: List<String>.from(json['missingSkills'] ?? []),
    );
  }
}