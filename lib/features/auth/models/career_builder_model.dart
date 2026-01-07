import 'package:wasl/features/auth/models/listtile_item_model.dart';

class CareerBuilderModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? jobTitle;
  final String? summary;
  final List<ListTileItemModel>? workExperiences;
  final List<ListTileItemModel>? education;
  final List<ListTileItemModel>? certificates;
  final List<String>? skills;

  CareerBuilderModel(
      { this.uid,
        this.name,
        this.email,
        this.image,
        this.jobTitle,
        this.summary,
        this.workExperiences,
        this.education,
        this.certificates,
        this.skills});

  factory CareerBuilderModel.fromJson(Map<String, dynamic> json) {

    return CareerBuilderModel(
      uid: json['uid'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      certificates: json['certificates'],
      education: json['education'],
      jobTitle: json['jobTitle'],
      skills: json['skills'],
      summary: json['summary'],
      workExperiences: json['workExperiences']
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String , dynamic>{};
    data['uid'] = uid;
    data['name'] = name; 
    data['skills'] = skills;
    data['image'] = image;
    data['email'] = email;
    data['certificates'] = certificates;
    data['education'] = education;
    data['summary'] = summary;
    data['jobTitle'] = jobTitle;
    data['workExperiences'] = workExperiences;
    return data;
      }
}
