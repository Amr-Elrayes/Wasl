import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/job/models/list_item_model.dart';

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
  final jobData = json['job'] as Map<String, dynamic>;

  return JobMatchModel(
    job: JobModel(
      jobId: jobData['id'] ?? '',
      title: jobData['title'] ?? '',
      description: jobData['description'] ?? '',
      status: 'Active',
      reqSkills: (jobData['skills'] as List<dynamic>? ?? [])
          .map((s) => ListItemModel(name: s.toString()))
          .toList(),
    ),
    matchScore: ((json['score'] as num? ?? 0) * 100).round(),
    matchedSkills: List<String>.from(jobData['skills'] ?? []),
    missingSkills: [],
  );
}
}