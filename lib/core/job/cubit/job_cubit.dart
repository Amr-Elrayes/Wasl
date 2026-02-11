import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/features/auth/models/company_model.dart';
import 'package:wasl/core/job/models/list_item_model.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobInitialState());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var describtionController = TextEditingController();
  var requirmentsController = TextEditingController();
  var salaryController = TextEditingController();
  List<ListItemModel> reqskills = [];
  String? title;
  Jobtype? jobType;
  Joblocation? jobLocation;
  // ignore: unused_field
  JobListType? _currentListType;
  List<JobModel> _currentJobs = [];

  Future<void> uploadJob({
    required String companyId,
  }) async {
    try {
      emit(JobLoadingState());

      /// 1- generate jobId
      final jobDoc = FirebaseFirestore.instance.collection('jobs').doc();
      final jobId = jobDoc.id;
      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);
      final companySnapshot = await companyDoc.get();
      final Company =
          CompanyModel.fromJson(companySnapshot.data() as Map<String, dynamic>);

      /// 2- create job model
      final job = JobModel(
        jobId: jobId,
        title: title,
        company: FirebaseAuth.instance.currentUser?.displayName,
        companyImg: Company.image,
        location: jobLocation?.name,
        type: jobType?.name,
        salary: double.tryParse(salaryController.text),
        description: describtionController.text,
        requirments: requirmentsController.text,
        reqSkills: reqskills,
      );

      /// 3- batch (عشان يترفعوا مع بعض)
      final batch = FirebaseFirestore.instance.batch();

      /// 4- jobs collection
      batch.set(jobDoc, job.toJson());

      /// 5- company document
      batch.update(companyDoc, {
        'uploadedJobs': FieldValue.arrayUnion([job.toJson()]),
        'activeJobs': FieldValue.arrayUnion([job.toJson()]),
      });

      /// 6- commit
      await batch.commit();

      emit(JobSuccessState());
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }

  void clearForm() {
    describtionController.clear();
    requirmentsController.clear();
    salaryController.clear();

    title = null;
    jobType = null;
    jobLocation = null;

    reqskills.clear();

    formKey = GlobalKey<FormState>();
  }

  Future<void> getJobsByType({
    required String companyId,
    required JobListType type,
  }) async {
    emit(JobLoadingState());

    _currentListType = type;

    final doc = await FirebaseFirestore.instance
        .collection('Company')
        .doc(companyId)
        .get();

    if (!doc.exists) {
      _currentJobs = [];
      emit(JobListLoadedState([]));
      return;
    }

    final data = doc.data()!;
    List jobsJson = [];

    switch (type) {
      case JobListType.uploaded:
        jobsJson = data['uploadedJobs'] ?? [];
        break;

      case JobListType.active:
        jobsJson = data['activeJobs'] ?? [];
        break;

      case JobListType.terminated:
        jobsJson = data['terminatedJobs'] ?? [];
        break;
    }

    _currentJobs = jobsJson
        .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    emit(JobListLoadedState(_currentJobs));
  }

  Future<void> updateJob({
    required String companyId,
    required String jobId,
  }) async {
    try {
      emit(JobLoadingState());

      final updatedJob = JobModel(
        jobId: jobId,
        title: title,
        company: FirebaseAuth.instance.currentUser?.displayName,
        location: jobLocation?.name,
        type: jobType?.name,
        salary: double.tryParse(salaryController.text),
        description: describtionController.text,
        requirments: requirmentsController.text,
        reqSkills: reqskills,
        status: "Active",
      );

      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);

      final snapshot = await companyDoc.get();
      final data = snapshot.data()!;

      List uploadedJobs = List.from(data['uploadedJobs'] ?? []);
      List activeJobs = List.from(data['activeJobs'] ?? []);
      List terminatedJobs = List.from(data['terminatedJobs'] ?? []);

      List updateList(List list) {
        final index = list.indexWhere((j) => j['jobId'] == jobId);
        if (index != -1) {
          list[index] = updatedJob.toJson();
        }
        return list;
      }

      uploadedJobs = updateList(uploadedJobs);
      activeJobs = updateList(activeJobs);
      terminatedJobs = updateList(terminatedJobs);

      await companyDoc.update({
        'uploadedJobs': uploadedJobs,
        'activeJobs': activeJobs,
        'terminatedJobs': terminatedJobs,
      });

      // تحديث الـ document في collection jobs
      final jobDocRef =
          FirebaseFirestore.instance.collection('jobs').doc(jobId);

      final jobSnapshot = await jobDocRef.get();
      if (jobSnapshot.exists) {
        await jobDocRef.update(updatedJob.toJson());
      }

      // نحدث الـ Cubit لو إحنا في TotalScreen (مش HomeScreen)
      if (_currentListType != null) {
        _currentJobs = _currentJobs.map((job) {
          if (job.jobId == jobId) return updatedJob;
          return job;
        }).toList();

        emit(JobListLoadedState(_currentJobs));
      } else {
        emit(JobSuccessState()); // مجرد نجاح لو مش في TotalScreen
      }
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }

  Future<void> terminateJobFromActive(String jobId) async {
    try {
      emit(JobLoadingState());

      final companyId = FirebaseAuth.instance.currentUser!.uid;
      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);

      final snapshot = await companyDoc.get();
      final data = snapshot.data()!;

      List uploadedJobs = List.from(data['uploadedJobs'] ?? []);
      List activeJobs = List.from(data['activeJobs'] ?? []);
      List terminatedJobs = List.from(data['terminatedJobs'] ?? []);

      // 1️⃣ نجيب الجوب من active
      final index = activeJobs.indexWhere((job) => job['jobId'] == jobId);
      if (index == -1) return;

      Map<String, dynamic> job = Map.from(activeJobs[index]);

      // 2️⃣ نحدث status
      job['status'] = 'Terminated';

      // 3️⃣ نشيلها من active
      activeJobs.removeAt(index);

      // 4️⃣ نضيفها في terminated
      terminatedJobs.add(job);

      // 5️⃣ نحدثها داخل uploaded
      final uploadedIndex = uploadedJobs.indexWhere((j) => j['jobId'] == jobId);
      if (uploadedIndex != -1) {
        uploadedJobs[uploadedIndex] = job;
      }

      // 6️⃣ Update Company
      await companyDoc.update({
        'activeJobs': activeJobs,
        'terminatedJobs': terminatedJobs,
        'uploadedJobs': uploadedJobs,
      });

      // 7️⃣ نشيلها من jobs collection
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();

      // 8️⃣ تحديث الـ UI
      _currentJobs.removeWhere((j) => j.jobId == jobId);
      emit(JobListLoadedState(_currentJobs));
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }

  Future<void> restoreJob(String jobId) async {
    try {
      emit(JobLoadingState());

      final companyId = FirebaseAuth.instance.currentUser!.uid;
      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);

      final snapshot = await companyDoc.get();
      final data = snapshot.data()!;

      List uploadedJobs = List.from(data['uploadedJobs'] ?? []);
      List activeJobs = List.from(data['activeJobs'] ?? []);
      List terminatedJobs = List.from(data['terminatedJobs'] ?? []);

      final index = terminatedJobs.indexWhere((job) => job['jobId'] == jobId);
      if (index == -1) return;

      Map<String, dynamic> job = Map.from(terminatedJobs[index]);

      job['status'] = 'Active';

      // 1️⃣ شيلها من terminated
      terminatedJobs.removeAt(index);

      // 2️⃣ ضيفها في active
      activeJobs.add(job);

      // 3️⃣ حدث uploaded
      final uploadedIndex = uploadedJobs.indexWhere((j) => j['jobId'] == jobId);
      if (uploadedIndex != -1) {
        uploadedJobs[uploadedIndex] = job;
      }

      // 4️⃣ رجّعها لل jobs collection
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).set(job);

      // 5️⃣ Update Company
      await companyDoc.update({
        'activeJobs': activeJobs,
        'terminatedJobs': terminatedJobs,
        'uploadedJobs': uploadedJobs,
      });

      _currentJobs.removeWhere((j) => j.jobId == jobId);
      emit(JobListLoadedState(_currentJobs));
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }

  Future<void> deleteJobPermanently(String jobId) async {
    try {
      emit(JobLoadingState());

      final companyId = FirebaseAuth.instance.currentUser!.uid;
      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);

      final snapshot = await companyDoc.get();
      final data = snapshot.data()!;

      List uploadedJobs = List.from(data['uploadedJobs'] ?? []);
      List terminatedJobs = List.from(data['terminatedJobs'] ?? []);

      uploadedJobs.removeWhere((j) => j['jobId'] == jobId);
      terminatedJobs.removeWhere((j) => j['jobId'] == jobId);

      await companyDoc.update({
        'uploadedJobs': uploadedJobs,
        'terminatedJobs': terminatedJobs,
      });

      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();

      _currentJobs.removeWhere((j) => j.jobId == jobId);
      emit(JobListLoadedState(_currentJobs));
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }
}
