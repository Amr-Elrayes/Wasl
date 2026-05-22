import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/job/models/job_model.dart';

mixin JobManagementMixin on Cubit<JobState> {
  // ignore: unused_field
  JobListType? _currentListType;
  List<JobModel> _currentJobs = [];
  StreamSubscription<DocumentSnapshot>? companySubscription;

  void getJobsByType({
    required String companyId,
    required JobListType type,
  }) {
    emit(JobLoadingState());

    _currentListType = type;
    companySubscription?.cancel();

    companySubscription = FirebaseFirestore.instance
        .collection('Company')
        .doc(companyId)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) {
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

      final jobs = jobsJson
          .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      _currentJobs = jobs;

      emit(JobListLoadedState(jobs));
    });
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

      final index = activeJobs.indexWhere((job) => job['jobId'] == jobId);
      if (index == -1) return;

      Map<String, dynamic> job = Map.from(activeJobs[index]);
      job['status'] = 'Terminated';

      activeJobs.removeAt(index);
      terminatedJobs.add(job);

      final uploadedIndex =
          uploadedJobs.indexWhere((j) => j['jobId'] == jobId);
      if (uploadedIndex != -1) {
        uploadedJobs[uploadedIndex] = job;
      }

      await companyDoc.update({
        'activeJobs': activeJobs,
        'terminatedJobs': terminatedJobs,
        'uploadedJobs': uploadedJobs,
      });

      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();

      final usersSnapshot =
          await FirebaseFirestore.instance.collection('Career').get();
      for (var doc in usersSnapshot.docs) {
        List appliedJobs = List.from(doc['appliedJobs'] ?? []);
        if (appliedJobs.contains(jobId)) {
          appliedJobs.remove(jobId);
          await doc.reference.update({'appliedJobs': appliedJobs});
        }
      }

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

      final index =
          terminatedJobs.indexWhere((job) => job['jobId'] == jobId);
      if (index == -1) return;

      Map<String, dynamic> job = Map.from(terminatedJobs[index]);
      job['status'] = 'Active';

      terminatedJobs.removeAt(index);
      activeJobs.add(job);

      final uploadedIndex =
          uploadedJobs.indexWhere((j) => j['jobId'] == jobId);
      if (uploadedIndex != -1) {
        uploadedJobs[uploadedIndex] = job;
      }

      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(jobId)
          .set(job);

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