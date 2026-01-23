class JobModel {
  final String? title;
  final String? field;
  final String? type;
  final int? salary;
  final String? description;
  final String? status;
  final String? requirments;
  final List<String>? reqSkills;
  JobModel( 
{    this.field, 
    this.type, 
    this.salary, 
    this.description,
    this.status,
    this.requirments, 
    this.reqSkills, 
    this.title}
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
      status:json['status']
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
};
}
