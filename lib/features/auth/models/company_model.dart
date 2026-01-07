
class CompanyModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? bio;

  CompanyModel(
      { this.uid,
        this.name,
        this.email,
        this.image,
        this.bio
        });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {

    return CompanyModel(
      uid: json['uid'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      bio: json['bio']
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String , dynamic>{};
    data['uid'] = uid;
    data['name'] = name; 
    data['image'] = image;
    data['email'] = email;
    data['bio'] = bio;
    return data;
      }
}
