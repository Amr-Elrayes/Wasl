import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  static final CollectionReference _careerCollection = FirebaseFirestore
      .instance
      .collection('Career');
  static final CollectionReference _companyCollection = FirebaseFirestore
      .instance
      .collection('Company');
  static final CollectionReference _jobsCollection = FirebaseFirestore
      .instance
      .collection('Jobs');


  static Future<QuerySnapshot> filterJobsByIndustry(
    String field,
  ) {
    return _jobsCollection
        .where("field", isEqualTo: field, isNull: false)
        .get();
  }
  static Future<QuerySnapshot> filterEmployeesByIndustry(
    String field,
  ) {
    return _careerCollection
        .where("field", isEqualTo: field, isNull: false)
        .get();
  }

  static Future<QuerySnapshot> getCompanyByName(String searchKey) {
    return _companyCollection
        .orderBy("name")
        .where('field', isNull: false)
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get();
  }

  static Future<String> getCompanyField() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final doc =
      await FirebaseFirestore.instance.collection('Company').doc(uid).get();

  return doc['field'];
}

}