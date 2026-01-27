import 'package:wasl/features/auth/models/career_builder_model.dart';

class JobModel {
  final String? title;
  final String? field;
  final String? type;
  final int? salary;
  final String? description;
  final String? status;
  final String? requirments;
  final List<String>? reqSkills;
  final List<CareerBuilderModel>? applications;
  JobModel( 
{    this.field, 
    this.type, 
    this.salary, 
    this.description,
    this.status,
    this.requirments, 
    this.reqSkills, 
    this.title,
    this.applications
    }
    );


      factory JobModel.fromJson(Map<String, dynamic> json) {

    return JobModel(
      title: json['title'],
      field: json['field'],
      type: json['type'],
      salary: json['salary'],
      description: json['description'],
      requirments: json['requirments'],
      reqSkills: json['reqSkills'],
      status:json['status'],
      applications: json['applications']
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String , dynamic>{};
    data['title'] = title;
    data['field'] = field; 
    data['type'] = type;
    data['salary'] = salary;
    data['description'] = description;
    data['requirments'] = requirments;
    data['reqSkills'] = reqSkills;
    data['applications'] = applications;
    return data;
      }

      Map<String, dynamic> updateData() => {
  if (title != null) 'title': title,
  if (field != null) 'field': field,
  if (type != null) 'type': type,
  if (salary != null) 'salary': salary,
  if (description != null) 'description': description,
  if (requirments != null) 'requirments': requirments,
  if (reqSkills != null) 'reqSkills': reqSkills,
  if (applications != null) 'applications': applications,
};
}
