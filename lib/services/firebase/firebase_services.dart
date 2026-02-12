import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/features/auth/models/company_model.dart';

class FirestoreServices {
  static final CollectionReference _careerCollection =
      FirebaseFirestore.instance.collection('Career');
  static final CollectionReference _companyCollection =
      FirebaseFirestore.instance.collection('Company');
  static final CollectionReference _jobsCollection =
      FirebaseFirestore.instance.collection('jobs');

static Stream<QuerySnapshot> filterJobsByTitle(String title) {
  return _jobsCollection
      .where("title", isEqualTo: title)
      .snapshots();
}


  static Future<QuerySnapshot> filterEmployeesByIndustry(
    String field,
  ) {
    return _careerCollection
        .where("field", isEqualTo: field, isNull: false)
        .get();
  }
static Stream<QuerySnapshot> getAllJobs() {
  return _jobsCollection.snapshots();
}

static Stream<QuerySnapshot> getJobsByTitle(String title) {
  return _jobsCollection
      .where("title", isGreaterThanOrEqualTo: title)
      .where("title", isLessThanOrEqualTo: '$title\uf8ff')
      .snapshots();
}


  static Future<QuerySnapshot> getCompanyByName(String searchKey) {
    return _companyCollection
        .orderBy("name")
        .where('field', isNull: false)
        .startAt([searchKey]).endAt([searchKey + '\uf8ff']).get();
  }

  static Future<String> getCompanyField() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('Company').doc(uid).get();

    return doc.data()?['field'] ?? "";
  }

  static Future<String> getUserTitle() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('Career').doc(uid).get();

    return doc.data()?['jobTitle'] ?? "";
  }

  static Stream<CompanyModel> getCompanyStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('Company')
        .doc(uid)
        .snapshots()
        .map((doc) => CompanyModel.fromJson(doc.data()!));
  }

  static Stream<CareerBuilderModel> getCareerStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('Career')
        .doc(uid)
        .snapshots()
        .map((doc) => CareerBuilderModel.fromJson(doc.data()!));
  }
}
