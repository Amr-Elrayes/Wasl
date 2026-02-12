import 'package:wasl/core/job/models/list_item_model.dart';

class JobModel {
  final String jobId;
  final String? title;
  final String? company;
  final String? companyImg;
  final String? companyId;
  final String? location;
  final String? type;
  final double? salary;
  final String? description;
  final String status;
  final String? requirments;
  final List<ListItemModel>? reqSkills;
  final List<String>? applications;

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
    this.companyImg,
    this.companyId,
    this.applications,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobId: json['jobId'],
      title: json['title'],
      company: json['company'],
      companyImg: json['companyImg'],
      companyId: json['companyId'],
      location: json['location'],
      type: json['type'],
      salary: (json['salary'] as num?)?.toDouble(),
      description: json['description'],
      requirments: json['requirments'],
      status: json['status'],
      reqSkills: (json['reqSkills'] as List<dynamic>? ?? [])
          .map((e) => ListItemModel.fromJson(e))
          .toList(),
      applications: List<String>.from(json['applications'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'title': title,
        'company': company,
        'companyImg': companyImg,
        'companyId': companyId,
        'location': location,
        'type': type,
        'salary': salary,
        'description': description,
        'status': status,
        'requirments': requirments,
        'reqSkills': reqSkills?.map((e) => e.toJson()).toList(),
        'applications': applications,
      };
}
