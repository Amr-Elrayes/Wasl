import 'package:wasl/core/job/models/job_model.dart';

class CompanyModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? field;
  final String? bio;
  bool isProfileCompleted;
  final List<JobModel>? uploadedJobs;
  final List<JobModel>? activeJobs;
  final List<JobModel>? terminatedJobs;

  CompanyModel({
    this.uid,
    this.name,
    this.email,
    this.image,
    this.field,
    this.bio,
    this.isProfileCompleted = false,
    this.uploadedJobs,
    this.activeJobs,
    this.terminatedJobs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      field: json['field'],
      bio: json['bio'],
      isProfileCompleted: json['isProfileCompleted'] ?? false,

      uploadedJobs: (json['uploadedJobs'] as List<dynamic>?)
          ?.map((e) => JobModel.fromJson(e))
          .toList(),

      activeJobs: (json['activeJobs'] as List<dynamic>?)
          ?.map((e) => JobModel.fromJson(e))
          .toList(),

      terminatedJobs: (json['terminatedJobs'] as List<dynamic>?)
          ?.map((e) => JobModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'field': field,
      'bio': bio,
      'isProfileCompleted': isProfileCompleted,
      'uploadedJobs': uploadedJobs?.map((e) => e.toJson()).toList(),
      'activeJobs': activeJobs?.map((e) => e.toJson()).toList(),
      'terminatedJobs': terminatedJobs?.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> updateData() => {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (image != null) 'image': image,
        if (field != null) 'field': field,
        if (bio != null) 'bio': bio,
        'isProfileCompleted': isProfileCompleted,
        if (uploadedJobs != null)
          'uploadedJobs': uploadedJobs!.map((e) => e.toJson()).toList(),
        if (activeJobs != null)
          'activeJobs': activeJobs!.map((e) => e.toJson()).toList(),
        if (terminatedJobs != null)
          'terminatedJobs': terminatedJobs!.map((e) => e.toJson()).toList(),
      };
}
