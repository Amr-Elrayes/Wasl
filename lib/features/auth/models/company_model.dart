
class CompanyModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? field;
  final String? bio;

  CompanyModel(
      { this.uid,
        this.name,
        this.email,
        this.image,
        this.field,
        this.bio
        });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {

    return CompanyModel(
      uid: json['uid'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      field: json['field'],
      bio: json['bio']
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
};
}
