
import 'package:wasl/core/models/job_model.dart';

class CompanyModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? field;
  final String? bio;
  final List<JobModel>? uploadedJobs;
  final List<JobModel>? activeJobs;
  final List<JobModel>? terminatedJobs;

  CompanyModel(
      { this.uid,
        this.name,
        this.email,
        this.image,
        this.field,
        this.bio,
        this.uploadedJobs,
        this.activeJobs,
        this.terminatedJobs
        });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {

    return CompanyModel(
      uid: json['uid'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      field: json['field'],
      bio: json['bio'],
      uploadedJobs: json['uploadedJobs'],
      activeJobs: json['activeJobs'],
      terminatedJobs: json['terminatedJobs']
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String , dynamic>{};
    data['uid'] = uid;
    data['name'] = name; 
    data['image'] = image;
    data['email'] = email;
    data['field'] = field;
    data['bio'] = bio;
    data['uploadedJobs'] = uploadedJobs;
    data['activeJobs'] = activeJobs;
    data['terminatedJobs'] = terminatedJobs;
    return data;
      }

      Map<String, dynamic> updateData() => {
  if (name != null) 'name': name,
  if (email != null) 'email': email,
  if (image != null) 'image': image,
  if (uid != null) 'uid': uid,
  if (field != null) 'field': field,
  if (field != null) 'field': field,
  if (bio != null) 'bio': bio,
  if (uploadedJobs != null) 'uploadedJobs': uploadedJobs,
  if (activeJobs != null) 'activeJobs': activeJobs,
  if (terminatedJobs != null) 'terminatedJobs': terminatedJobs,
};
}
