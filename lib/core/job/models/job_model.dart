import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/features/auth/models/listtile_item_model.dart';

class JobModel {
  final String jobId; 
  final String? title;
  final String? company;
  final String? location;
  final String? type;
  final double? salary;
  final String? description;
  final String status;
  final String? requirments;
  final List<ListTileItemModel>? reqSkills;
  final List<CareerBuilderModel>? applications;

  JobModel({
    required this.jobId,
    this.location,
    this.type,
    this.salary,
    this.description,
    this.status = "Active",
    this.requirments,
    this.reqSkills,
    this.title,
    this.company,
    this.applications,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobId: json['jobId'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      type: json['type'],
      salary: json['salary'],
      description: json['description'],
      requirments: json['requirments'],
      status: json['status'],
      reqSkills: (json['reqSkills'] as List<dynamic>? ?? [])
          .map((e) => ListTileItemModel.fromJson(e))
          .toList(),
      applications: (json['applications'] as List<dynamic>? ?? [])
          .map((e) => CareerBuilderModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'title': title,
        'company': company,
        'location': location,
        'type': type,
        'salary': salary,
        'description': description,
        'status': status,
        'requirments': requirments,
        'reqSkills': reqSkills?.map((e) => e.toJson()).toList(),
        'applications': applications?.map((e) => e.toJson()).toList(),
      };
}
