import 'package:wasl/features/auth/models/listtile_item_model.dart';

class CareerBuilderModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? jobTitle;
  final String? summary;
  final String? field;
  bool isProfileCompleted;
  List<ListTileItemModel>? workExperiences;
  List<ListTileItemModel>? education;
  List<ListTileItemModel>? certificates;
  List<ListTileItemModel>? skills;

  CareerBuilderModel(
      {this.uid,
      this.name,
      this.email,
      this.image,
      this.jobTitle,
      this.summary,
      this.workExperiences,
      this.education,
      this.certificates,
      this.skills,
      this.field,
      this.isProfileCompleted = false
      });

  factory CareerBuilderModel.fromJson(Map<String, dynamic> json) {
    return CareerBuilderModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      jobTitle: json['jobTitle'],
      summary: json['summary'],
      field: json['field'],
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((e) => ListTileItemModel.fromJson(e))
          .toList(),
      workExperiences: (json['workExperiences'] as List<dynamic>? ?? [])
          .map((e) => ListTileItemModel.fromJson(e))
          .toList(),
      education: (json['education'] as List<dynamic>? ?? [])
          .map((e) => ListTileItemModel.fromJson(e))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>? ?? [])
          .map((e) => ListTileItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'jobTitle': jobTitle,
      'summary': summary,
      'field': field,
      'isProfileCompleted': isProfileCompleted,
      'skills': skills?.map((e) => e.toJson()).toList(),
      'certificates': certificates?.map((e) => e.toJson()).toList(),
      'education': education?.map((e) => e.toJson()).toList(),
      'workExperiences': workExperiences?.map((e) => e.toJson()).toList(),
    };
  }

Map<String, dynamic> updateData() => {
  if (name != null) 'name': name,
  if (email != null) 'email': email,
  if (image != null) 'image': image,
  if (jobTitle != null) 'jobTitle': jobTitle,
  if (summary != null) 'summary': summary,
  if (field != null) 'field': field,
  if (uid != null) 'uid': uid,
  'isProfileCompleted': isProfileCompleted,

  if (workExperiences != null)
    'workExperiences': workExperiences!.map((e) => e.toJson()).toList(),

  if (education != null)
    'education': education!.map((e) => e.toJson()).toList(),

  if (certificates != null)
    'certificates': certificates!.map((e) => e.toJson()).toList(),

  if (skills != null)
    'skills': skills!.map((e) => e.toJson()).toList(),
};

}
